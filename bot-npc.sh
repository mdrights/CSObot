#!/bin/bash
# Grab information from npc.gov.cn
# 2016-07-29
# 0.1.2

Text="$HOME/npc.gov.html"
Text1="$HOME/npc.gov.1.html"
MDText="$HOME/npc.gov.md"
MDText1="$HOME/npc.gov.1.md"

Token="260947680:AAF87IQ2967PLVOhVWdU2xlGZnHz5_gq49o"
Chatid="`cat $HOME/github/CSObot/id-list.txt`"
Date="`date +%Y-%m-%d`"

# 1.----------------------------

echo "<em>人大常委会法律草案征求意见</em>" > $Text
echo "" >> $Text

curl http://www.npc.gov.cn/npc/flcazqyj/node_8176.htm | grep "<a href=\"\.\.\/\.\.\/COB" >> $Text

pandoc -f html -t markdown $Text -o $MDText

sed 's/\.\.\/\.\./http:\/\/www.npc.gov.cn/g' $MDText > $MDText1

# sed '2s/^/正在征求意见：/g

for i in $Chatid;
do
w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=$i&text=`cat $MDText1`&parse_mode=Markdown" 1&>/dev/null
done


# 2.----------------------------


curl http://www.npc.gov.cn/npc/xinwen/node_12488.htm | grep "<a href=.*$Date" > $Text

if [ -s $Text ]; then
	pandoc -f html -t markdown $Text -o $MDText

	sed 's/href=\"/href=\"http:\/\/www.npc.gov.cn\/npc\/xinwen\//g' $MDText | sed '1s/^/*人大常委会法律发布*/g' > $MDText1

	for i in $Chatid;
	do
	w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=$i&text=`cat $MDText1`&parse_mode=Markdown" 1&>/dev/null
	done
else
	echo "No news from there."
fi


# 3.----------------------------

curl http://www.npc.gov.cn/npc/xinwen/node_12491.htm | grep "<a href=.*$Date" > $Text

if [ -s $Text ]; then
        pandoc -f html -t markdown $Text -o $MDText

        sed 's/href=\"/href=\"http:\/\/www.npc.gov.cn\/npc\/xinwen\//g' $MDText | sed '1s/^/*人大常委会报告发布*/g' > $MDText1

        for i in $Chatid;
        do
        w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=$i&text=`cat $MDText1`&parse_mode=Markdown" 1&>/dev/null
        done
else
        echo "No news from there."
fi

# ------------------------------

echo "News had been sent."
exit 0
