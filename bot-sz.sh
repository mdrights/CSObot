#!/bin/bash
## Grab notices, news and new-release of policies on SZ Government's website.
## Initiated at 2016-08-05


Text="$HOME/bot-sz.html"
Text1="$HOME/bot-sz.1.html"
Text2="$HOME/bot-sz.2.html"
MDText="$HOME/bot-sz.md"
MDText1="$HOME/bot-sz.1.md"

Token="260947680:AAF87IQ2967PLVOhVWdU2xlGZnHz5_gq49o"
Chatid="`cat $HOME/github/CSObot/id-list.txt`"
Date="`date +%Y%m%d`"

# 1.-----------------------

curl http://www.sz.gov.cn/cn/xxgk/szgg/tzgg/ | grep "$Date" > $Text

if [ -s "$Text" ]; then
	iconv -f GB2312 -t UTF-8 $Text > $Text1
	pandoc -f html -t markdown $Text1 -o $MDText	
	sed '1s/^/*深圳政府官网通知*    /g' $MDText | sed 's/\.\//http:\/\/www.sz.gov.cn\/cn\/xxgk\/szgg\/tzgg\//g' | sed 's/ \".*\"//g' > $MDText1
	w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=64960773&text=`cat $MDText1`&parse_mode=Markdown" 1&>/dev/null
else
	w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=64960773&parse_mode=Markdown&text=Oops, no news today." 1&>/dev/null
fi
	

# 2.-----------------------

curl http://www.sz.gov.cn/xxgk/zcfg/ | sed '/title/d' > $Text                   # Failed to convert codes if this line exists.

iconv -f GB2312 -t UTF-8 $Text > $Text1						# Convert codes to UTF otherwise failing to grab content.

sed -n -e '/.*深圳市法规及规章.*/,/.*rightAreaEnd.*/ { p }' $Text1 > $Text2	# Grab the content I want.

# if [ -s "$Text" ]; then
        pandoc -f html -t markdown $Text2 -o $MDText				# TG fails to render markdown if there's any "_" in links.
	sed 's/\.\.\/\.\./http:\/\/www.sz.gov.cn/g' $MDText > $MDText1
        w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=64960773&text=`cat $MDText1`" 1&>/dev/null
#else
       # w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=64960773&parse_mode=Markdown&text=Oops, no news today." 1&>/dev/null
#fi


echo
exit 0
