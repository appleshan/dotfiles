#!/usr/bin/env bash
# ===============================================================
# check-docker-ports.sh
# 检查 Docker 容器端口暴露与 UFW 状态
# ===============================================================

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RESET="\033[0m"

echo "🔍 正在检查 Docker 端口暴露情况..."
echo "=============================================================="

# 获取 docker ps 输出
docker_ps=$(docker ps --format '{{.Names}}|{{.Ports}}')

if [ -z "$docker_ps" ]; then
  echo "❌ 没有正在运行的容器。"
  exit 0
fi

printf "%-25s %-25s %-20s\n" "容器名" "绑定地址" "状态"
echo "--------------------------------------------------------------"

while IFS='|' read -r name ports; do
  if [[ -z "$ports" ]]; then
    printf "%-25s %-25s ${GREEN}%-20s${RESET}\n" "$name" "无对外端口" "安全"
    continue
  fi

  # 分析每个映射
  for port in $(echo "$ports" | tr ',' '\n'); do
    port=$(echo "$port" | sed 's/ //g')

    if [[ "$port" =~ 0\.0\.0\.0 ]]; then
      printf "%-25s %-25s ${RED}%-20s${RESET}\n" "$name" "$port" "⚠️ 公网暴露"
    elif [[ "$port" =~ 127\.0\.0\.1 ]]; then
      printf "%-25s %-25s ${GREEN}%-20s${RESET}\n" "$name" "$port" "本机安全"
    else
      printf "%-25s %-25s ${YELLOW}%-20s${RESET}\n" "$name" "$port" "内部网络"
    fi
  done
done <<< "$docker_ps"

echo "--------------------------------------------------------------"
echo "🧱 检查宿主机端口监听状态..."
ss -tlnp | grep -E 'docker|LISTEN' | awk '{print $4, $6}' | sed 's/users://g' | sed 's/"//g' | sed 's/,//g' | sed 's/\[::\]://g'
echo "--------------------------------------------------------------"

echo "🧩 检查 UFW 规则..."
sudo ufw status numbered

echo "=============================================================="
echo "✅ 检查完成。绿色=安全，黄色=内部安全，红色=公网暴露。"
