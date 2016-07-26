#!/bin/bash
# Grab NGOCN.net's contents regularly. And send them to my Bot :)
# 2016.07.23
# 0.1.2


Text="$HOME/bot-website-links.html"
MDText="$HOME/bot-md-links.txt"
Token="260947680:AAF87IQ2967PLVOhVWdU2xlGZnHz5_gq49o"
Chatid="64960773"
Date="`date +%Y-%m-%d`"

echo "Today's news from NGOCN.net, $Date." > $Text
echo >> $Text

curl http://www.ngocn.net | grep "www.ngocn.net/news/$Date" | grep -v "/upload/" >> $Text


pandoc -f html -t markdown $Text -o $MDText

w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=$Chatid&text=`cat $MDText`" 1&>/dev/null

echo "News had been sent."
exit 0
