## 前言
&emsp;看到老十的46叔叔补天每天的洞都能有好几K，搞得我好心动啊，我决定，提高工作效率，腾出时间找一下洞。找洞第一步：收集资产 - 子域名。

## 脚本说明
&emsp;使用了几款子域名收集工具收集域名，并去重、筛选存活、获取IP。

**子域名收集工具包括**
1. subDomainBrute
2. Teemo
3. wydomain

```bash
#!/bin/bash

#########################
	Team Dark5	#
 https://www.dark5.net	#
#########################

rm -rf domain
rm -rf ips
rm -rf mail

echo && read -e -p "[-] Please input domain: " domainname

cd /opt/subDomainsBrute&&python subDomainsBrute.py --full $domainname -o /opt/subdomain_find/lijiejie_$domainname.dic
cd /opt/wydomain&&python wydomain.py -d $domainname -o /opt/subdomain_find/wydomain_$domainname.dic
cd /opt/teemo&&python teemo.py -d $domainname -o /opt/subdomain_find/teemo_$domainname.dic

cd /opt/subdomain_find/

###lijiejie
cat lijiejie_$domainname.dic|awk '{print($1)}'>>domain.txt


###wydomain
cat wydomain_$domainname.dic |sed 's/,//g' |sed 's/"//g' |sed 's/]//g'  |sed 's/ \+//g' |sed 's/\t//g' |sed '1d' >>domain.txt

###teemo
cat teemo_$domainname.dic |grep -v @|grep -v / |awk '{print($1)}' |grep -v ^[0-9]>>domain.txt
cat teemo_$domainname.dic |grep @ >>mail

cat domain.txt|sort|uniq|grep -v 'chinaz.com'>>domain
rm -rf *.txt

### Alive
cat domain|while read domainname
do
re_curl_code=`curl -s --connect-timeout 2 --head $domainname |head -n 1 |awk '{print($2)}'`

domain_ip=`ping -c 1 -w 1 $domainname |head -n 1 |awk '{print($3)}' |sed 's/(//g' |sed 's/)//g'`

if [ "$re_curl_code" != "" ]
then	
	printf "%-35s %-10s %-4s %-15s\n" $domainname 'is Alive.' $re_curl_code $domain_ip
else
	printf "%-30s %-10s %-15s\n" $domainname 'is Died.' $domain_ip
fi
done


echo "We are completed."
```

