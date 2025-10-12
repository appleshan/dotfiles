#!/bin/bash

#原文链接：
# https://qnnp.me/javascript/let-curl-support-pac.html
# https://juejin.cn/post/7309732740705124378
# alias curl='~/.local/bin/curl_with_pac.sh'


# 优先使用 PAC_PATH
#PAC_PATH=~/.hosts/pac.loc/pac.js
PAC_PATH=~/.nghttpx/proxy-test.pac
PAC_URL=http://127.0.0.1/pac.js

CURL_BINARY_PATH=/usr/bin/curl
QJS_BINARY_PATH=/usr/bin/qjs

# main

REQUEST_URI=""
SKIP_NEXT=false
ARGS=""
for arg in "$@"; do
  ARGS="$ARGS $(sed -r 's:([() ;&~?]):\\\1:g' <<< "$arg")"
  if [[ $SKIP_NEXT == true ]]; then
    SKIP_NEXT=false
  else
    if [[ $arg =~ ^https?:// ]]; then
      REQUEST_URI="$arg"
    fi
  fi

  if [[ $arg == "--proxy" || $arg == "-x" ]]; then
    SKIP_NEXT=true
  fi
done

if [ "$REQUEST_URI" == "" ]; then
  sh -c "$CURL_BINARY_PATH $ARGS"
else
  SCRIPT="
    $([ "$PAC_PATH" == "" ] && $CURL_BINARY_PATH -s $PAC_URL || cat "$PAC_PATH")
    const args = '$REQUEST_URI'.match(/^[a-zA-Z]+:\/\/([^/]+)/);
    const proxy = FindProxyForURL(...args);
    if(proxy !== 'DIRECT') {
      const [proto,host] = proxy.split(/[ ;]+/);
      if(proto === 'SOCKS5') {
        console.log('--proxy socks5h://' + host);
      }
      if(proto === 'PROXY') {
        console.log('--proxy ' + host);
      }
    }
  "
  PROXY="$($QJS_BINARY_PATH -e "$SCRIPT")"
  sh -c "$CURL_BINARY_PATH $PROXY $ARGS"
fi
