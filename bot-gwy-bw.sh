#!/bin/bash
#Collecting the call-for-opinion notices from some Ministries of China.
# Added at 09.08.2016


Text="$HOME/bot-sda.html"
Text1="$HOME/bot-sda.1.html"
MDText="$HOME/bot-sda.md"

Token="260947680:AAF87IQ2967PLVOhVWdU2xlGZnHz5_gq49o"
Chatid="`cat $HOME/github/CSObot/id-list.txt`"
Date="`date +%Y%m%d`"
Month="`date +%Y-%m`"

# 1.-----------------------

wget www.sda.gov.cn/WS01/CL0014/ -O $Text
cat $Text | grep -2 "$Month" | iconv -f GB2312 -t UTF-8 | sed 's/\.\./http:\/\/www.sda.gov.cn\/WS01/g' > $Text1

if [ -s "$Text1" ]; then
        pandoc -f html -t markdown $Text1 | sed '1s/^/*国家食品药品监督总局征集意见*     /g' > $MDText

	for i in $Chatid
	do
	w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=$i&text=`cat $MDText`&parse_mode=Markdown" 1&>/dev/null
	done

else
	a="No news from 食品药品总局."
         w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=64960773&text=$a&parse_mode=Markdown" 1&>/dev/null
fi

#------------------------

echo
exit 0
