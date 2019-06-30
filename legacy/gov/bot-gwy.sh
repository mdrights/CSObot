#!/bin/bash
# Grab specific websites' contents regularly. And send them to my Bot :)
# Initiated at 2016.07.23
# Renamed from bot-web.sh.
# ver 1.2.0

. $HOME/CSObot/variables.sh "gwy"

# 1.-----------------------

curl http://www.chinalaw.gov.cn/article/cazjgg/ | grep "<a.*href=.*$Month.*" > $Text
curl http://www.chinalaw.gov.cn/ | grep "fzxw.*$Date2" | sed 's/href=\"/href=\"http:\/\/www.chinalaw.gov.cn/g' >> $Text

	sed '1s/^/国务院法制办：草案征集和新闻*    /g' >> $Text
	pandoc -f html -t markdown $Text -o $MDText

	sed 's/ \".*\"//g' $MDText | sed 's/(\(.*)\)/\(http:\/\/www.chinalaw.gov.cn\1/g' | sed '1s/^/*国务院法制办：草案征集公告*    /g' > $MDText1

. $HOME/CSObot/toAll.sh "$Text" "$MDText1" "国务院法制办"

# 2.----------------------

curl http://www.gov.cn/zhengce/index.htm | grep "2016-`date +%m`/`date +%d`.*国务院办公厅" > $Text

	echo "<em>Today's news from 国务院办公厅大法好</em>" >> $Text
	pandoc -f html -t markdown $Text -o $MDText

. $HOME/CSObot/toAll.sh "$Text" "$MDText" "国务院办公厅"


# 3.----------------------

curl http://www.chinalaw.gov.cn/article/fgkd/xfg/gwybmgz/ | grep "<a title=.*$Date1" > $Text
        echo "<em>Today's news from 国务院部门规章</em>" >> $Text
        pandoc -f html -t markdown $Text -o $MDText

. $HOME/CSObot/toAll.sh "$Text" "$MDText" "国务院部门"

# 4.----------------------

curl http://www.chinalaw.gov.cn/article/fgkd/xfg/xzfg/ | grep "<a title=.*$Date1" > $Text
        echo "<em>Today's news from 国务院行政法规</em>" >> $Text
        pandoc -f html -t markdown $Text -o $MDText

. $HOME/CSObot/toAll.sh "$Text" "$MDText" "国务院行政法规发布"

# 5.----------------------





#-------------------------
echo "News had been sent."
exit 0
