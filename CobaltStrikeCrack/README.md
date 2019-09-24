# Cobalt Strike 3.14 破解教程


Cobalt Strike 官网：https://cobaltstrike.com/

程序校验：https://verify.cobaltstrike.com/

## I 需要修改的点

1. 修改程序使用时间限制及提示框

	文件位置：`common/License.class`

	+ 使用时间
	
	```
	private static long life = 21L;
	将21天的试用期修改成
	private static long life = 99999L;
	```
	+ 修改isTrail的判断逻辑
	
	```
	public static boolean isTrial()
    {
        return true;
    }
	修改成
    public static boolean isTrial()
    {
        return false;
    }
	```
	
	+ 去除打开软件弹框框
	
	```
	public static void checkLicenseGUI(Authorization auth)
	{
		....
	}
	修改成
	public static void checkLicenseGUI(Authorization authorization)
	{
	}
	同理
	public static void checkLicenseConsole(Authorization authorization)
	```



2. 去除被检测指纹（后门指纹）
	```
	common/ArtifactUtils.class
	common/ListenerConfig.class
	common/BaseArtifactUtils.class
	server/ProfileEdits.class
	resource/template.x64.ps1
	resource/template.x86.ps1
	```

	搜索关键字`ANTIVIRUS`，并做适当修改，去除全部或去除字符串。



3. 去除监听器数量限制

	`aggressor/dialogs/ListenerDialog.class`

	搜索关键词并去除以下判断
	```
	if(Listener.isEgressBeacon(payload) && DataUtils.isBeaconDefined(datal) && !name.equals(DataUtils.getEgressBeaconListener(datal)))
			{
				DialogUtils.showError("You may only define one egress Beacon per team server.\nThere are a few things I need to sort before you can\nput multiple Beacon HTTP/DNS listeners on one server.\nSpin up a new team server and add your listener there.");
			} else
	```

4. 空格后门
>在3.13版爆出后门一个，可以通过该后们发现该VPS是C&C服务器。

文件位置：`common/WebTransforms.class`

代码段：`response.status += " ";`


## II 编译回去
`javac -classpath cobaltstrike.jar xxxx.java`

## III 编译问题
有时候编译会出问题的，不是error的话没啥问题。Error请看这个：[cobalt strike修改小坑](https://utf32.com/2019/02/11/cobalt-strike-crack/)

## IV 参考
https://rcoil.me/2018/10/CobaltStrike-3-12-%E7%A0%B4%E8%A7%A3/

https://wbglil.github.io/2019/03/03/cobaltstrike-3-13/

https://mrxn.net/hacktools/619.html

https://www.mrwu.red/fenxiang/3389.html

https://kingx.me/CobaltStrike-Patch.html

https://utf32.com/2019/02/11/cobalt-strike-crack/

http://caidaome.com/?post=140

https://www.cnblogs.com/ssooking/p/9825917.html