#!/bin/bash
# Grab information from npc.gov.cn
# 2016-07-29
# 0.1.0

Text="$HOME/npc.gov.html"
Text1="$HOME/npc.gov.1.html"
MDText="$HOME/npc.gov.md"
MDText1="$HOME/npc.gov.1.md"

Token="260947680:AAF87IQ2967PLVOhVWdU2xlGZnHz5_gq49o"
Chatid="64960773"
Date="`date +%Y-%m-%d`"

#----------------------------

echo "人大常委会法律草案征求意见" > $Text
echo "" >> $Text

curl http://www.npc.gov.cn/npc/flcazqyj/node_8176.htm | grep "<a href=\"\.\.\/\.\.\/COB" >> $Text

pandoc -f html -t markdown $Text -o $MDText

sed 's/\.\.\/\.\./http:\/\/www.npc.gov.cn/g' $MDText > $MDText1

# sed '2s/^/正在征求意见：/g

w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=$Chatid&text=`cat $MDText1`" 1&>/dev/null

echo "News had been sent."
exit 0
