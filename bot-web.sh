#!/bin/bash
# Grab specific websites' contents regularly. And send them to my Bot :)
# Initiated at 2016.07.23
# ver 1.2.0


Text="$HOME/bot-web.html"
Text="$HOME/bot-web.1.html"
MDText="$HOME/bot-web.md"
MDText1="$HOME/bot-web.1.md"

Token="260947680:AAF87IQ2967PLVOhVWdU2xlGZnHz5_gq49o"
Chatid="`cat $HOME/github/CSObot/id-list.txt`"
Date="`date +%Y-%m-%d`"
Date1="`date +%m-%d`"
Date2="`date +%Y%m`"

# 1.-----------------------

	curl http://www.chinalaw.gov.cn/article/cazjgg/ | grep "<a.*href=.*$Date2.*" > $Text

if [ -s $Text ]; then
	sed '1s/^/国务院法制办：草案征集公告*    /g' >> $Text
	pandoc -f html -t markdown $Text -o $MDText

	sed 's/ \".*\"//g' $MDText | sed 's/(\(.*)\)/\(http:\/\/www.chinalaw.gov.cn\1/g' | sed '1s/^/*国务院法制办：草案征集公告*    /g' > $MDText1

	for i in $Chatid;
	do
	w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=$i&text=`cat $MDText1`&parse_mode=Markdown" 1&>/dev/null
	done
else
	echo "*Today's news from 国务院法制办：草案征集公告*  
-还没有新出的草案，休息一下吧～" >> $Text
#	for i in $Chatid;
#	do
	w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=64960773&text=`cat $Text`&parse_mode=Markdown" 1&>/dev/null
#	done
fi


# 2.----------------------

curl http://www.gov.cn/zhengce/index.htm | grep "2016-`date +%m`/`date +%d`.*国务院办公厅" > $Text

if [ -s $Text ]; then
	echo "<em>Today's news from 国务院办公厅大法好</em>" >> $Text
	pandoc -f html -t markdown $Text -o $MDText

	for i in $Chatid;
	do
	w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=$i&text=`cat $MDText`&parse_mode=Markdown" 1&>/dev/null
	done
else
	echo "*Today's news from 国务院办公厅大法好*  
-还没有新出的大法呢？" >> $Text
#	for i in $Chatid;
#	do					Change to sending notice to myself only.
	w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=64960773&text=`cat $Text`&parse_mode=Markdown" 1&>/dev/null
#	done
fi



# 3.----------------------

curl http://www.chinalaw.gov.cn/article/fgkd/xfg/gwybmgz/ | grep "<a title=.*$Date" > $Text
if [ -s $Text ]; then
        echo "<em>Today's news from 国务院部门规章</em>" >> $Text
        pandoc -f html -t markdown $Text -o $MDText

        for i in $Chatid;
        do
        w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=$i&text=`cat $MDText`&parse_mode=Markdown" 1&>/dev/null
        done
else
        echo "*Today's news from 国务院部门规章*  
-还没有新出的大法呢？" >> $Text
        #for i in $Chatid;
        #do
	w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=64960773&text=`cat $Text`&parse_mode=Markdown" 1&>/dev/null
        #done
fi


# 4.----------------------

curl http://www.chinalaw.gov.cn/article/fgkd/xfg/xzfg/ | grep "<a title=.*$Date" > $Text
if [ -s $Text ]; then
        echo "<em>Today's news from 国务院行政法规</em>" >> $Text
        pandoc -f html -t markdown $Text -o $MDText

        for i in $Chatid;
        do
        w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=$i&text=`cat $MDText`&parse_mode=Markdown" 1&>/dev/null
        done
else
        echo "*Today's news from 国务院行政法规*
-还没有新出的大法呢？" >> $Text
        #for i in $Chatid;
        #do
	w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=64960773&text=`cat $Text`&parse_mode=Markdown" 1&>/dev/null
        #done
fi


# 5.----------------------

curl http://www.chinalaw.gov.cn/ | grep "fzxw.*$Date1" | sed 's/href=\"/href=\"http:\/\/www.chinalaw.gov.cn/g' > $Text

if [ -s $Text ]; then
        pandoc -f html -t markdown $Text -o $MDText
	sed '1s/^/*国务院法制办新闻*     /g' $MDText > $MDText1

	for i in $Chatid;
        do
        w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=$i&text=`cat $MDText1`&parse_mode=Markdown" 1&>/dev/null
        done
else
	echo "今天国务院法制办歇菜了？" >> $Text
	w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=64960773&text=`cat $Text`&parse_mode=Markdown" 1&>/dev/null
fi



#-------------------------
echo "News had been sent."
exit 0
