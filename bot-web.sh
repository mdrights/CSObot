#!/bin/bash
# Grab specific websites' contents regularly. And send them to my Bot :)
# 2016.07.23
# ver 0.2.1


Text="$HOME/bot-website-links.html"
MDText="$HOME/bot-md-links.md"
MDText1="$HOME/bot-md-links1.md"

Token="260947680:AAF87IQ2967PLVOhVWdU2xlGZnHz5_gq49o"
Chatid="64960773"
Date="`date +%Y-%m-%d`"

# 1.-----------------------
echo "Today's news from 国务院法制办：草案征集公告" > $Text
curl http://www.chinalaw.gov.cn/article/cazjgg/ | grep "<a title=" >> $Text

pandoc -f html -t markdown $Text -o $MDText

sed 's/\".*\"//g' $MDText | sed 's/(\(.*)\)/\(http:\/\/www.chinalaw.gov.cn\1/g' > $MDText1

w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=$Chatid&text=`cat $MDText1`" 1&>/dev/null


# 2.----------------------






echo "News had been sent."
exit 0
