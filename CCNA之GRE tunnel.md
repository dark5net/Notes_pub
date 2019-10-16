Tunnel分成兩種：
1. IP-over-IP 
2. GRE

GRE tunnel：Generi Routing Encapsulation tunnel，是通用路由封装协议，可以对某些网路层协议的数据报进行封装，使这些被封装的数据报能够在IPv4/IPv6 网络中传输。

![GRE tunnel](http://ww1.sinaimg.cn/large/b837ef10gy1g30voayamuj20rn0cr0tg.jpg)

首先就是配置各个路由器的IP,然后让R1与R3连通，然后就是本文要说的:

**R1**
```
interface Tunnel1  //interface tunnel 1
 tunnel mode gre
 ip address 1.1.1.1 255.255.255.0
 tunnel source Ethernet0/0
 tunnel destination 192.168.2.2

ip route 192.168.1.0 255.255.255.0 tunnel 1
```

**R3**
```
interface Tunnel1  //interface tunnel 2
 tunnel mode gre
 ip address 1.1.1.2 255.255.255.0
 tunnel source Ethernet1/0
 tunnel destination 192.168.3.1

ip route 192.168.4.0 255.255.255.0 tunnel 2
```

**tunnel两端的IP段必须是在同一个网段；建立好tunnel后再配置tunnel路由，选择路由的时候要用tunnel，不要选择对端地址，这样最为稳妥.**