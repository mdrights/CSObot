#!/bin/bash
## Grab notices, news and new-release of policies on SZ Government's website.
## Initiated at 2016-08-05


Text="$HOME/bot-sz.html"
Text1="$HOME/bot-sz.1.html"
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
	sed '1s/^/*News from SZ Gov website* <br>/g' $MDText | sed 's/\.\//http:\/\/www.sz.gov.cn\/cn\/xxgk\/szgg\/tzgg\//g' | sed 's/ \".*\"//g' > $MDText1
	w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=64960773&text=`cat $MDText1`&parse_mode=Markdown" 1&>/dev/null
else
	w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=64960773&parse_mode=Markdown&text=Oops, no news today." 1&>/dev/null
fi
	
echo
exit 0
