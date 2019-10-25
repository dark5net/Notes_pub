
<!-- TOC -->

- [前言](#前言)
- [抓不到的原因](#抓不到的原因)
- [解决该问题的原理](#解决该问题的原理)
- [解决该问题的具体办法](#解决该问题的具体办法)
- [测试环境说明](#测试环境说明)
- [参考](#参考)

<!-- /TOC -->
## 前言
&emsp;因项目原因，需重新测试windows server 2012及以上系统的抓明文密码的方法。

## 抓不到的原因
&emsp;从 **windows 8.1 开始** ，微软为了增加系统的安全性，做了一些安全的策略来防止像 mimikatz 或 WCE 这类工具，直接获取明文密码。但是即便如此我们仍然可以有机会获取到明文密码。


## 解决该问题的原理

Windows 8.1 介绍了以下的注册表项，可以用来设置你的 WDigest 密码是否要支持以明文形式，保存在 LSA 内存中：

`HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest\UseLogonCredential`

在 < 8.1 的 windows 版本中，该注册表键值都默认设置为 “1”，也就是说都支持以明文形式保存在 LSA 内存中。从win 8.1开始，如果想获取到明文密码，还需修改目标机器的以下注册表键值为 “1”，cmd命令如下：

`reg add HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest /v UseLogonCredential /t REG_DWORD /d 1 /f`


## 解决该问题的具体办法
先利用一切可执行cmd的办法添加注册表，CMD命令如下：
`reg add HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest /v UseLogonCredential /t REG_DWORD /d 1 /f`

然后需要让此注册表生效，可通过锁屏**或**注册目标账号让其重新登陆来达到生效目的。
* **锁屏CMD命令**
`rundll32.exe user32.dll,LockWorkStation` 此命令应用在Console登陆（非RDP登录）情况下。

* **注销目标账号**
`query user` `logoff ID` 此命令兼容各种情况，但注销在操作的管理员账号，此操作属于高危操作。

## 测试环境说明
笔者测试
* 系统环境
Microsoft Windows Server 2016 Standard 10.0.14393
* 杀软情况
Windows defender已关闭
* 登陆情况
    + 远程登陆断开状态添加注册后登陆（抓明文失败）
    + 远程登陆状态注销目标账号后登陆（抓明文成功）

## 参考
[如何获取Windows 8.1&Server 2012的WDigest密码 ?](http://www.secist.com/archives/2160.html)

[Win10及2012系统以后的明文抓取方式](https://www.anquanke.com/post/id/175364)