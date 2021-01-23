# unbound.conf

使用说明可参考[使用 Unbound + DNSCrypt 搭建无污染 DNS](https://lawrencexs.xyz/2016/03/build-a-no-pollution-dns-server-with-unbound-and-dnscrypt/)

国内域名默认由114.114.114.114和223.5.5.5解析，配置在unbound.forward-zone.China.conf。
其他域名默认由监听在9999端口的DNSCrypt解析，配置在unbound.forward-zone.Global.conf。

国内域名列表取自[dnsmasq-china-list](https://github.com/felixonmars/dnsmasq-china-list)，如果你有其他国内域名需要添加，请直接向dnsmasq-china-list项目反馈。
