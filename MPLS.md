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
CE：Customer Edge，用户边缘设备，服务提供商所连接的用户端路由器。CE路由器通过连接一个或多个PE路由器，为用户提供服务接入。CE路由器通常是一台IP路由器，它与连接的PE路由器建立邻接关系。

### PE
PE：Provider Edge，即Provide的边缘设备，服务提供商骨干网的边缘路由器，它相当于标签边缘路由器（LER）。PE路由器连接CE路由器和P路由器，是最重要的网络节点。用户的流量通过PE路由器流入用户网络，或者通过PE路由器流到MPLS骨干网。

### RD
### RT


## 参考

[MPLS-VPN中RD/RT/VRF](https://darkless.cn/2016/11/26/MPLS-VPN-RD-RT-VRF/)

[在IP网络中，P、PE、CE代表意思](https://www.cnblogs.com/zafu/p/8494481.html)