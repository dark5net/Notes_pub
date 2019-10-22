## 前言
&emsp;看到老十的46叔叔补天每天的洞都能有好几K，搞得我好心动啊，我决定，提高工作效率，腾出时间找一下洞。找洞第一步：收集资产 - 子域名。

## 脚本说明
&emsp;使用了几款子域名收集工具收集域名，并去重、筛选存活、获取IP。

**I 子域名收集工具包括**
1. subDomainBrute
2. Teemo
3. wydomain

**II 使用说明**
&emsp;由于是配合的其他子域名收集的，所以就用把相关子域名工具放置在特定的位置：`/opt/`，然后再把本BASH脚本放在：`/opt/subdomain_find/`。配合我写的Linux环境配置脚本用起来就会很舒服了的。[Linux_pentest_initv2](https://raw.githubusercontent.com/52stu/Notes_pub/master/Linux_pentest_init/Linux_pentest_initv2.sh) 还有不懂的就自己领会吧。

**III 脚本代码如下**
