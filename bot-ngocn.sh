#!/bin/bash
# Grab NGOCN.net's contents regularly. And send them to my Bot :)
# Initiated at 2016.07.23
# 1.2.0


Text="$HOME/bot-ngocn.html"
MDText="$HOME/bot-ngocn.md"
Token="260947680:AAF87IQ2967PLVOhVWdU2xlGZnHz5_gq49o"
Chatid="`cat $HOME/github/CSObot/id-list.txt`"
Date="`date +%Y-%m-%d`"


curl http://www.ngocn.net | grep "www.ngocn.net/news/$Date" | grep -v "/upload/" > $Text

if [ -s $Text ]; then
	echo "<em>Today's news from NGOCN.net, $Date.</em>" >> $Text
	pandoc -f html -t markdown $Text -o $MDText

	for i in $Chatid;
	do
	w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=$i&text=`cat $MDText`&parse_mode=Markdown" 1&>/dev/null
	done
else
	a="*Today's news from NGOCN.net, $Date.*  Oops，现在还没有新的内容！"
	
#	for i in $Chatid;
#	do
	echo $a
         w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=64960773&text=$a&parse_mode=Markdown" 1&>/dev/null

#	done
fi

echo "News had been sent."
exit 0
