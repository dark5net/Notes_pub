>别问我为什么一个渗透选手要学习CCIE的知识。那么该文章里面的东西我懂不懂呢？我肯定是不懂啊。


<!-- TOC -->

- [名词释义](#名词释义)
    - [VRF](#vrf)
    - [MPLS](#mpls)
    - [CE](#ce)
    - [PE](#pe)
    - [RD](#rd)
    - [RT](#rt)
- [参考](#参考)

<!-- /TOC -->

## 名词释义
### VRF
VRF：Virtual Routing and Forwarding，翻译成虚拟路由及转发，它是一种VPN路由和转发实例。一台PE路由器，由于可能同时连接了多个VPN用户，这些用户（的路由）彼此之间需要相互隔离，那么这时候就用到了VRF，PE路由器上每一个VPN都有一个VRF。PE路由器除了维护全局IP路由表之外，还为每个VRF维护一张独立的IP路由表，这张路由表称为VRF路由表。

### MPLS
### CE
### PE


### RD
### RT


## 参考

[MPLS-VPN中RD/RT/VRF](https://darkless.cn/2016/11/26/MPLS-VPN-RD-RT-VRF/)
[在IP网络中，P、PE、CE代表意思](https://www.cnblogs.com/zafu/p/8494481.html)