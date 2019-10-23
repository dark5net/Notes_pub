

# CCNA之访问控制列表（ACL）

## 前言
&emsp;为什么写？做记录，方便自己。你一个做渗透的需要这些？嗯，你提高一下水平就知道要不要了。
>大学时候学的CCNA知识已经全部还给老师了，他说我们从此两不相欠，哈哈哈~

## ACL的分类
访问控制列表（Access Control Lists,ACL）分为：
* 标准访问控制列表（Standard ACL）
* 扩展访问控制列表（Extended ACL）
* 命名访问控制列表（using Name ACL）

**标准的ACL使用 1 ~ 99 以及1300~1999之间的数字作为表号，扩展的ACL使用 100 ~ 199以及2000~2699之间的数字作为表号。访问控制列表是自上往下匹配的，之前匹配到一条规则就不会再往下匹配了。** 详细请转：https://wenku.baidu.com/view/dbafd03b0b4c2e3f572763b8.html

## 标准访问控制列表（Standard ACL）
这个就是比较简单的访问控制功能，就比如运训谁访问谁；不允许谁访问谁。**标准ACL要尽量靠近目的端。**
```
  <1-99>       Standard IP access-list number
  <1300-1999>  Standard IP access-list number (expanded range)
  WORD         Access-list name
```

```
access-list 99 permit 192.168.1.0 0.0.0.255
access-list 99 deny 192.168.2.0 0.0.0.255

int f1/1
ip access-group 99 out
```
删除和弃用acl都是在语句前面加no，如：`no access-list 99` **该模式无法删除单条acl，只能把整个列表删除。**


## 扩展访问控制列表（Extended ACL）
顾名思义，就是在加强版的标准访问控制列表。**扩展ACL要尽量靠近源端。**
格式是：`access-list access-list-number {permit|deny} protocol source source-wildcard [poerator port] destination destination-wildcard [operator port] [established] [log]`

```
R2(config)#ip access-list extended ?
  <100-199>    Extended IP access-list number
  <2000-2699>  Extended IP access-list number (expanded range)
  WORD         Access-list name
```

```
access-list 101 deny tcp 172.16.4.0 0.0.0.255 172.16.3.0 0.0.0.255 eq 21 #禁止172.16.4.0/24 网段机器访问172.16.3.0/24网段的21端口
access-list 101 deny tcp 172.16.5.0 0.0.0.255 172.16.3.0 0.0.0.255 eq 23  #禁止172.16.5.0/24 网段机器访问172.16.3.0/24网段的23端口
access-list 101 permit ip any any

int f0/0
ip access-group 101 out
```
删除和弃用acl都是在语句前面加no，如：`no access-list 101` **该模式无法删除单条acl，只能把整个列表删除。**



## 命名访问控制列表（using Name ACL）
这个是可高度自定义的访问控制列表功能。
```
ip access-list {standard | extended} name
    number {permit|deny} {ip access list test conditions}
```
```
ip access-list extended test //创建一个基于扩展访问控制列表名为test的命名访问控制列表并进入配置模式
    permit tcp host 10.22.22.1 any eq telnet  //默认号是10，然后以10递增
    111 deny tcp host 10.22.22.1 any eq telnet  //定义该条规则号为111
    exit

int f0/0
ip access-group test out
```

如果需要重新配置test，就重新进入就可以了，如：`ip access-list extended test`

## 