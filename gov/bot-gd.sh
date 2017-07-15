#!/bin/bash
## Grab gd.gov.cn regulations for consultation, also published.
## Inititated at 2016.08.06
## It only sends to me.

. $HOME/CSObot/variables.sh "gd"

# 1.-----------------------

curl http://www.gd.gov.cn/govpub/flfg/ | grep "www\.fzb\.gd\.gov\.cn.*$Month" > $Text
        pandoc -f html -t markdown $Text -o $MDText
        sed '1s/^/*广东省征求意见草案*    /g' $MDText > $MDText1

. $HOME/CSObot/toAll.sh "$Text" "$MDText1" "广东省政府（征求意见）"

# 2.-----------------------

curl http://zwgk.gd.gov.cn/szfl.htm | grep "$Month" | sed 's/\"\./\"http:\/\/zwgk.gd.gov.cn/g' > $Text
	#sed 's/\"\./\"http:\/\/zwgk.gd.gov.cn\/szfl.htm'
curl http://zwgk.gd.gov.cn/szfwj.htm | grep "$Month" | sed 's/\"\./\"http:\/\/zwgk.gd.gov.cn/g' >> $Text

        pandoc -f html -t markdown $Text -o $MDText
        sed '1s/^/*广东省政府大法和本月规范性文件发布*    /g' $MDText | sed 's/ \".*\"//g' > $MDText1

. $HOME/CSObot/toAll.sh "$Text" "$MDText1" "广东省政府（法规和文件发布）"

# 3.-----------------------

curl http://www.gd.gov.cn/govpub/bmguifan/ | grep "$Month" | sed 's/\"\./\"http:\/\/www.gd.gov.cn\/govpub\/bmguifan/g' > $Text

        pandoc -f html -t markdown $Text -o $MDText
        sed '1s/^/*广东省政府部门规范性文件发布*      /g' $MDText | sed 's/ \".*\"//g' > $MDText1

. $HOME/CSObot/toAll.sh "$Text" "$MDText1" "广东省政府部门文件发布"

echo "Done."
echo
exit 0

