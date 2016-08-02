#!/bin/bash
# Grab specific websites' contents regularly. And send them to my Bot :)
# 2016.07.23
# ver 0.2.4


Text="$HOME/bot-website-links.html"
MDText="$HOME/bot-md-links.md"
MDText1="$HOME/bot-md-links1.md"

Token="260947680:AAF87IQ2967PLVOhVWdU2xlGZnHz5_gq49o"
Chatid="`cat $HOME/github/CSObot/id-list.txt`"
Date="`date +%Y-%m-%d`"

# 1.-----------------------

	curl http://www.chinalaw.gov.cn/article/cazjgg/ | grep "<a title=.*$Date" > $Text

if [ -s $Text ]; then
	echo "<em>Today's news from 国务院法制办：草案征集公告</em>" >> $Text
	pandoc -f html -t markdown $Text -o $MDText

	sed 's/\".*\"//g' $MDText | sed 's/(\(.*)\)/\(http:\/\/www.chinalaw.gov.cn\1/g' > $MDText1

	for i in $Chatid;
	do
	w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=$i&text=`cat $MDText1`&parse_mode=Markdown" 1&>/dev/null
	done
else
	echo "*Today's news from 国务院法制办：草案征集公告*  -还没有新出的草案，休息一下吧～" >> $Text
	for i in $Chatid;
	do
	w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=$i&text=`cat $Text`&parse_mode=Markdown" 1&>/dev/null
	done
fi


# 2.----------------------
echo "<em>Today's news from 国务院办公厅大法好</em>" > $Text
echo "" >> $Text

curl http://www.gov.cn/zhengce/index.htm | grep "2016-`date +%m`/`date +%e`.*国务院办公厅" > $Text

if [ -s $Text ]; then
	echo "<em>Today's news from 国务院办公厅大法好</em>" >> $Text
	pandoc -f html -t markdown $Text -o $MDText

	for i in $Chatid;
	do
	w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=$i&text=`cat $MDText`&parse_mode=Markdown" 1&>/dev/null
	done
else
	echo "*Today's news from 国务院办公厅大法好*  -还没有新出的大法呢？" >> $Text
	for i in $Chatid;
	do
	w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=$i&text=`cat $Text`&parse_mode=Markdown" 1&>/dev/null
	done
else
fi



# 3.----------------------


echo "News had been sent."
exit 0
