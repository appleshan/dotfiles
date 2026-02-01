#!/usr/bin/env bash
set -u

NGINX_DIR="/var/log/nginx"
RECENT_LINES=2000
TMP_CF="/tmp/cf_all_ips.txt"
TMP_LOG="/tmp/nginx_logs_combined.txt"

cleanup(){
    rm -f "$TMP_CF" "$TMP_LOG"
}
trap cleanup EXIT

echo "=== 获取 Cloudflare IPv4/IPv6 列表… ==="

curl -s https://www.cloudflare.com/ips-v4/ > "$TMP_CF"
curl -s https://www.cloudflare.com/ips-v6/ >> "$TMP_CF"

if [ ! -s "$TMP_CF" ]; then
    echo "❌ 失败：无法获取 Cloudflare IP 列表"
    exit 1
fi

echo "Cloudflare IP 段已加载："
wc -l "$TMP_CF"

echo ""
echo "=== 收集 Nginx 日志… ==="

mapfile -d $'\0' LOGS < <(find "$NGINX_DIR" -maxdepth 1 -type f \( -iname "*access.log" -o -iname "*.log" -o -iname "*.gz" \) -print0)

if [ ${#LOGS[@]} -eq 0 ]; then
    echo "未找到任何 Nginx access 日志"
    exit 0
fi

# 合并最近日志
> "$TMP_LOG"
for LOG in "${LOGS[@]}"; do
    if [[ "$LOG" =~ \.gz$ ]]; then
        zcat "$LOG" 2>/dev/null >> "$TMP_LOG"
    else
        cat "$LOG" 2>/dev/null >> "$TMP_LOG"
    fi
done

echo "合并日志完成：$(wc -l < "$TMP_LOG") 行"
echo ""

###################################
# 提取最近访问 IP 并对比 CF
###################################

echo "=== 检查最近 $RECENT_LINES 行访问中非 Cloudflare IP ==="

# 提取 IP
tail -n "$RECENT_LINES" "$TMP_LOG" | awk '{print $1}' | sort -u > /tmp/nginx_ips.txt

echo ""
echo "开始比对..."

# 逐个判断是否属于 CF 段
NON_CF_IPS=()

while read -r ip; do
    if ! grep -qE "^$(echo "$ip" | sed 's/\./\\./g')(/|$)" "$TMP_CF"; then
        # 不是直接文本匹配，而是 CIDR 检查
        match=""
        while read -r cidr; do
            if [[ "$cidr" == *.* ]]; then
                # IPv4 CIDR check
                if ipcalc -c "$ip" "$cidr" >/dev/null 2>&1; then
                    match="1"
                    break
                fi
            else
                # IPv6 CIDR
                if sipcalc "$ip" "$cidr" >/dev/null 2>&1; then
                    match="1"
                    break
                fi
            fi
        done < "$TMP_CF"

        if [ -z "$match" ]; then
            NON_CF_IPS+=("$ip")
        fi
    fi
done < /tmp/nginx_ips.txt

echo ""
if [ ${#NON_CF_IPS[@]} -eq 0 ]; then
    echo "✔ 没有发现绕过 Cloudflare 的 IP（全部访问来自 Cloudflare）"
else
    echo "⚠ 检测到 **非 Cloudflare** 源站访问（注意安全）：" 
    printf '%s\n' "${NON_CF_IPS[@]}"
fi

echo ""
echo "=== 检查完成，临时文件已删除 ✔ ==="
