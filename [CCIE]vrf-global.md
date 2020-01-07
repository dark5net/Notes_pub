## 前言
那年风高月圆夜，公司新来的妹纸草莓深夜来电问我MPLS VPN里面的vrf路由表如何才能与全局路由表互通。秉承爱江山更爱美女的原则，我立马起身给她找解决方案。经研究发现，Cisco的路由要达到目的并不难，两条命令足以。

## 相关配置
![](https://raw.githubusercontent.com/52stu/Images/master/xsj/20200107075323.png)

```
R2
ip route 192.168.4.0 255.255.255.0 192.168.3.2

R3
ip route 192.168.4.0 255.255.255.0 Ethernet0/0 192.168.4.2
ip route vrf jx 0.0.0.0 0.0.0.0 192.168.3.1 global
```

![](https://raw.githubusercontent.com/52stu/Images/master/xsj/20200107075708.png)

## 其他
除开这种，官网还有更加多的配置方法，可定义度较高。

>至此，就已经圆满完成草莓给的任务。“歪，草莓啊，哥给你整完了，明天咋感谢我呀？” “emmmm，渣哥，那我明晚给你按摩行不行吖~”

[从MPLS VPN的互联网访问使用一张全局路由表](https://www.cisco.com/c/zh_cn/support/docs/multiprotocol-label-switching-mpls/mpls/24508-internet-access-mpls-vpn.html)