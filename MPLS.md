>别问我为什么一个渗透选手要学习CCIE的知识。那么该文章里面的东西我懂不懂呢？我肯定是不懂啊😄。


<!-- TOC -->

- [I. 名词释义](#i-名词释义)
    - [VRF](#vrf)
    - [MPLS](#mpls)
    - [CE](#ce)
    - [PE](#pe)
    - [RD](#rd)
    - [RT](#rt)
    - [LER](#ler)
    - [LSR](#lsr)
- [参考](#参考)

<!-- /TOC -->

## I. 名词释义
### VRF
VRF：Virtual Routing and Forwarding，翻译成虚拟路由及转发，它是一种VPN路由和转发实例。一台PE路由器，由于可能同时连接了多个VPN用户，这些用户（的路由）彼此之间需要相互隔离，那么这时候就用到了VRF，PE路由器上每一个VPN都有一个VRF。PE路由器除了维护全局IP路由表之外，还为每个VRF维护一张独立的IP路由表，这张路由表称为VRF路由表。

### MPLS
MPLS：Multi-Protocol Label Switching，译作多协议标签交换，mpls的出现主要是因为上世纪90年代传统ip路由转发出现瓶颈，MPLS最初是为了提高路由器的转发速度而提出的。与传统IP路由方式相比，它在数据转发时，只在网络边缘分析IP报文头，而不用在每一跳都分析IP报文头，节约了处理时间，所以才想到了使用标签转发来替代传统的ip查表转发。但是随着硬件工艺的发展，逐渐出现的硬件转发和芯片转发，之前ip转发查表慢的问题已经不复存在。

由于mpls标签转发的思想在mpls vpn和mpls TE（流量工程）方面的应用也使得这一技术得以存在并且大放异彩，MPLS vpn在企业网和运营商中运用的都比较多，MPLS TE主要在运营商中应用。本篇先介绍MPLS，mpls vpn随后介绍。

### CE
CE：Customer Edge，用户边缘设备，服务提供商所连接的用户端路由器。CE路由器通过连接一个或多个PE路由器，为用户提供服务接入。CE路由器通常是一台IP路由器，它与连接的PE路由器建立邻接关系。

### PE
PE：Provider Edge，即Provide的边缘设备，服务提供商骨干网的边缘路由器，它相当于标签边缘路由器（LER）。PE路由器连接CE路由器和P路由器，是最重要的网络节点。用户的流量通过PE路由器流入用户网络，或者通过PE路由器流到MPLS骨干网。

### RD


### RT

### LER

### LSR

## 参考
[MPLS基础总结](https://darkless.cn/2018/03/23/MPLS-summary/)

[MPLS-VPN中RD/RT/VRF](https://darkless.cn/2016/11/26/MPLS-VPN-RD-RT-VRF/)

[在IP网络中，P、PE、CE代表意思](https://www.cnblogs.com/zafu/p/8494481.html)