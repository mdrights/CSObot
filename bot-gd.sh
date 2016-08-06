#!/bin/bash
## Grab gd.gov.cn regulations for consultation.
## Inititated at 2016.08.06

Text="$HOME/bot-gd.html"
Text1="$HOME/bot-gd.1.html"
MDText="$HOME/bot-gd.md"
MDText1="$HOME/bot-gd.1.md"

Token="260947680:AAF87IQ2967PLVOhVWdU2xlGZnHz5_gq49o"
Chatid="`cat $HOME/github/CSObot/id-list.txt`"
Date="`date +%Y%m`"

# 1.-----------------------

curl http://www.gd.gov.cn/govpub/flfg/ | grep "www\.fzb\.gd\.gov\.cn.*201607" > $Text

if [ -s "$Text" ]; then
        pandoc -f html -t markdown $Text1 -o $MDText
        sed '1s/^/*News from SZ Gov website*    /g' $MDText | sed 's/\.\//http:\/\/www.sz.gov.cn\/cn\/xxgk\/szgg\/tzgg\//g' | sed 's/ \".*\"//g' > $MDText1
        w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=64960773&text=`cat $MDText1`&parse_mode=Markdown" 1&>/dev/null
else
        w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=64960773&parse_mode=Markdown&text=Oops, no news today." 1&>/dev/null
fi

echo
exit 0

