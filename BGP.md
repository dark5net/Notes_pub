>没那么简单就能找到聊得来的伴~ 别说找到红颜知己了，就连BGP都不简单啊。

<!-- TOC -->

- [相关名词介绍](#相关名词介绍)
    - [IGP介绍](#igp介绍)
    - [EGP介绍](#egp介绍)
    - [BGP介绍](#bgp介绍)
    - [IBGP介绍](#ibgp介绍)
    - [EBGP介绍](#ebgp介绍)
- [BGP配置](#bgp配置)
    - [EBGP配置](#ebgp配置)
    - [IBGP配置](#ibgp配置)
    - [EBGP和IBGP混合配置](#ebgp和ibgp混合配置)
- [参考](#参考)

<!-- /TOC -->

## 相关名词介绍
### IGP介绍
&emsp;**IGP（Interior Gateway Protocol,内部网关协议）是在一个自治网络内网关（主机和路由器）间交换路由信息的协议。** 路由信息能用于网间协议（IP）或者其它网络协议来说明路由传送是如何进行的。Internet网被分成多个域或多个自治系统。一个域（domain）是一组主机和使用相同路由选择协议的路由器集合，并由单一机构管理。**IGP协议包括RIP、OSPF、IS-IS、IGRP、EIGRP。**

### EGP介绍
&emsp;外部网关协议（Exterior Gateway Protocol）是AS之间使用的路由协议。



### BGP介绍
&emsp;边界网关协议（BGP）是运行于 TCP 上的一种自治系统的路由协议。 **BGP可以说是EGP的改良。** BGP 是唯一一个用来处理像因特网大小的网络的协议，也是唯一能够妥善处理好不相关路由域间的多路连接的协议。 BGP 构建在 EGP 的经验之上。 BGP 系统的主要功能是和其他的 BGP 系统交换网络可达信息。网络可达信息包括列出的自治系统（AS）的信息。这些信息有效地构造了 AS 互联的拓朴图并由此清除了路由环路，同时在 AS 级别上可实施策略决策。
&emsp;

### IBGP介绍
&emsp;IBGP(Internal Border Gateway Protocol)——内部BGP协议(IBGP)仅用于多归属场合。IBGP允许边缘路由器共享NLRI及其相关属性，从而增强系统范围内的路由策略。此外，当位于转接（transit）AS中的边缘路由器将学习自外部对等体的路由传递给其他边缘路由器（以便将该路由宣告给外部对等体）时，就可以利用IBGP来作为传递手段。

### EBGP介绍
&emsp;EBGP —— (External Border Gateway Protocol) 外部边界网关协议，用于在不同的自治系统间交换路由信息。

## BGP配置
### EBGP配置
### IBGP配置
### EBGP和IBGP混合配置

## 参考

[思科路由器 BGP (EGBP) 路由协议最简单的配置实例详解](https://zhuanlan.zhihu.com/p/27016475)

