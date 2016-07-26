#!/bin/bash
# Grab specific websites' contents regularly. And send them to my Bot :)
# 2016.07.23


Text="$HOME/bot-website-links.html"
MDText="$HOME/bot-md-links.txt"
Token="260947680:AAF87IQ2967PLVOhVWdU2xlGZnHz5_gq49o"
Chatid="64960773"
Date="2016-07-25"  # date +%Y-%m-%d

echo "News from NGOCN.net on $Date." > $Text
curl http://www.ngocn.net | grep "www.ngocn.net/news/$Date" >> $Text


pandoc -f html -t markdown $Text -o $MDText

w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=$Chatid&text=`cat $MDText`" 1&>/dev/null

echo "News had been sent."
exit 0
