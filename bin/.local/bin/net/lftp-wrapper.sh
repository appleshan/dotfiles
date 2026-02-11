#!/usr/bin/env bash
# @See https://blog.ferstar.org/post/issue-64/
# 该脚本用于处理yay安装软件时，由 google-chrome 下载缓慢甚至无法下载的问题
# 检测域名是不是github，如果是，则执行 github-mirror-axel.sh

LFTP_BIN=/usr/bin/lftp

USER_AGENT="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36"
PROCESS_COUNT=$(($(nproc)+1))
URL=$1
OUT_PATH=$2

# 解析域名
DOMAIN=$(echo "$URL" | cut -f3 -d'/')

# check if http or https proxy is set
if [ -n "$http_proxy" ]; then
    PROXY=$http_proxy
elif [ -n "$https_proxy" ]; then
    PROXY=$https_proxy
else
    PROXY=""
fi

# 仅针对 github.com 和 raw.githubusercontent.com 启用代理逻辑
if [ -z "$PROXY" ] && ([[ "$DOMAIN" == *"github.com"* ]] || [[ "$DOMAIN" == "raw.githubusercontent.com" ]]); then
    /usr/local/bin/github-mirror-axel.sh $OUT_PATH $URL
else
    $LFTP_BIN -e \
        "set ssl:verify-certificate false;
        set net:idle 10;
        set net:max-retries 3;
        set net:reconnect-interval-base 3;
        set net:reconnect-interval-max 3;
        set http:user-agent '$USER_AGENT';
        pget -n $PROCESS_COUNT -c $URL -o $OUT_PATH;
        quit;"
fi
