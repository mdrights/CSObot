#!/bin/bash
## Grab gd.gov.cn regulations for consultation, also published.
## Inititated at 2016.08.06
## It only sends to me.

Text="$HOME/bot-gd.html"
Text1="$HOME/bot-gd.1.html"
MDText="$HOME/bot-gd.md"
MDText1="$HOME/bot-gd.1.md"

Token="260947680:AAF87IQ2967PLVOhVWdU2xlGZnHz5_gq49o"
Chatid="`cat $HOME/github/CSObot/id-list.txt`"
Date="`date +%Y%m`"
Date1="`date +%Y`"

# 1.-----------------------

curl http://www.gd.gov.cn/govpub/flfg/ | grep "www\.fzb\.gd\.gov\.cn.*$Date" > $Text

if [ -s "$Text" ]; then
        pandoc -f html -t markdown $Text -o $MDText
        sed '1s/^/*广东省征求意见草案*/g' $MDText > $MDText1
        w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=64960773&text=`cat $MDText1`&parse_mode=Markdown" 1&>/dev/null
else
        w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=64960773&parse_mode=Markdown&text=Oops, no news today." 1&>/dev/null
fi


# 2.-----------------------

curl http://zwgk.gd.gov.cn/szfl.htm | grep "$Date1" | sed 's/\"\./\"http:\/\/zwgk.gd.gov.cn/g' > $Text
	#sed 's/\"\./\"http:\/\/zwgk.gd.gov.cn\/szfl.htm'
curl http://zwgk.gd.gov.cn/szfwj.htm | grep "$Date" | sed 's/\"\./\"http:\/\/zwgk.gd.gov.cn/g' >> $Text

if [ -s "$Text" ]; then
        pandoc -f html -t markdown $Text -o $MDText
        sed '1s/^/*广东省政府大法和本月规范性文件发布*    /g' $MDText | sed 's/ \".*\"//g' > $MDText1
        w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=64960773&text=`cat $MDText1`&parse_mode=Markdown" 1&>/dev/null
else
        w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=64960773&parse_mode=Markdown&text=Oops, no new release till now." 1&>/dev/null
fi


# 3.-----------------------

curl http://www.gd.gov.cn/govpub/bmguifan/ | grep "$Date" | sed 's/\"\./\"http:\/\/www.gd.gov.cn/govpub/bmguifan/g' > $Text

if [ -s "$Text" ]; then
        pandoc -f html -t markdown $Text -o $MDText
        sed '1s/^/*广东省政府部门规范性文件发布*      /g' $MDText | sed 's/ \".*\"//g' > $MDText1
        w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=64960773&text=`cat $MDText1`&parse_mode=Markdown" 1&>/dev/null
else
        w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=64960773&parse_mode=Markdown&text=Omg, no news today." 1&>/dev/null
fi

echo "Done."
echo
exit 0

