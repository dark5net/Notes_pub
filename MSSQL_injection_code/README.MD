## 支持基于提交的分类
+ POST
+ GET

## 基于注入效果的分类
+ 联合查询
+ 堆栈查询
+ 延时盲注
+ 布尔盲注
+ 报错注入


## 搭建

**环境**
1. windows server 2008 R2
2. [SQL Server 2005](ed2k://|file|cs_sql_2005_dev_all_dvd.iso|1870581760|25D3E5CEFB407E7CA1036BE303AC4643|/)

**搭建**
1. 架设IIS
2. 安装SQL Server 2005
    安装的时候注意选择“windows身份验证和SQL用户登录的混合模式”，大概是这个意思，名字可能有点不对。
3. 然后新建数据库 - 建表 - 字段 - 填内容
4. 看看1433端口是否打开`netstat -ano|findstr "1433"`，如若没有请看：https://www.cnblogs.com/newcapecjmc/p/9307618.html
5. 确认打开之后，再修改`post.aspx.cs`、`get.aspx`，`index.html`里面的相关参数。
    `index.html`把网址改成自己的IP地址


## 使用方法
直接解析到index.html，然后由html的传送的对应的页面。

## 关于数据库里面的数据
![](https://github.com/52stu/Notes_pub/blob/master/MSSQL_injection_code/images/users.bmp)

![](https://www.github.com/52stu/Images/raw/master/小书匠/1568462292636.png)