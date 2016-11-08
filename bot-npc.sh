#!/bin/bash
# Grab information from npc.gov.cn
# Initiated at 2016-07-29
# 1.2.0

. $HOME/CSObot/variables.sh "npc"

# 1.----------------------------


	curl http://www.npc.gov.cn/npc/flcazqyj/node_8176.htm | grep "<a href=\"\.\.\/\.\.\/COB" > $Text

	pandoc -f html -t markdown $Text -o $MDText
	sed 's/\.\.\/\.\./http:\/\/www.npc.gov.cn/g' $MDText | sed '1s/^/人大常委会法律草案征求意见/g' > $MDText1

. $HOME/CSObot/toMe.sh "$Text" "$MDText1" "人大常委会（草案征集）"

# 2.----------------------------


curl http://www.npc.gov.cn/npc/xinwen/node_12488.htm | grep "<a href=.*$Date1" > $Text

	pandoc -f html -t markdown $Text -o $MDText

	sed 's/href=\"/href=\"http:\/\/www.npc.gov.cn\/npc\/xinwen\//g' $MDText | sed '1s/^/*人大常委会法律发布*/g' > $MDText1

. $HOME/CSObot/toMe.sh "$Text" "$MDText1" "人大常委会（法律发布）"

# 3.----------------------------

curl http://www.npc.gov.cn/npc/xinwen/node_12491.htm | grep "<a href=.*$Date1" | sed 's/href=\"/href=\"http:\/\/www.npc.gov.cn\/npc\/xinwen\//g' | sed '1s/^/*人大常委会报告发布*/g' > $Text

        pandoc -f html -t markdown $Text -o $MDText

. $HOME/CSObot/toMe.sh "$Text" "$MDText" "人大常委会（报告发布）"

# 4.------------------------------

# ------------------------------
echo "News had been sent."
exit 0
