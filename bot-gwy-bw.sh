#!/bin/bash
#Collecting the call-for-opinion notices from some Ministries of the State Counsel.
# Added at 09.08.2016


. $HOME/CSObot/variables.sh "gwy-bw"

# 1.-----------------------

wget www.sda.gov.cn/WS01/CL0014/ -O $Text
cat $Text | grep -2 "$Month1" | iconv -f GB2312 -t UTF-8 | sed 's/\.\./http:\/\/www.sda.gov.cn\/WS01/g' > $Text1

        pandoc -f html -t markdown $Text1 | sed '1s/^/*国家食品药品监督总局征集意见*     /g' > $MDText

. $HOME/CSObot/toMe.sh "$Text" "$MDText" "国家食品药品监督总局"

# 2.------------------------

curl http://www.moe.gov.cn/jyb_xxgk/moe_1777/moe_1778/ | grep "href=.*$Month" | sed 's/=\"\./=\"http:\/\/www.moe.gov.cn\/jyb_xxgk\/moe_1777\/moe_1778/g' > $Text
	# 政策文件
curl http://www.moe.gov.cn/s78/A02/zfs__left/s5911/moe_621/ | grep "href=.*$Month" | sed 's/\.\.\/\.\.\/\.\.\/\.\.\/\.\./http:\/\/www.moe.gov.cn/g' >> $Text
	# 通知公告
curl http://www.moe.gov.cn/jyb_xwfb/s248/ | grep "href=.*$Month" | sed 's/=\"\./=\"http:\/\/www.moe.gov.cn\/jyb_xwfb\/s248/g' >> $Text 
	# 徵求意見

        pandoc -f html -t markdown_github $Text | sed '1s/^/**教育政策和教育部門規章**     /g' | sed 's/ \".*\"//g' > $MDText

. $HOME/CSObot/toMe.sh "$Text" "$MDText" "教育部"

# 3.------------------------

curl http://www.nhfpc.gov.cn/zhuzhan/gongw/lists.shtml | grep "href=.*$Month" | sed 's/\.\.\/\.\./http:\/\/www.nhfpc.gov.cn/g' > $Text

        pandoc -f html -t markdown_github $Text | sed '1s/^/**衛生計生委文件發佈**     /g' | sed 's/ \".*\"//g' > $MDText

. $HOME/CSObot/toMe.sh "$Text" "$MDText" "卫生计生委"

# 4.------------------------

curl http://www.mohrss.gov.cn/SYrlzyhshbzb/zcfg/ | grep "href=.*$Month" | sed 's/\.\//http:\/\/www.mohrss.gov.cn\/SYrlzyhshbzb\/zcfg\//g' > $Text

        pandoc -f html -t markdown_github $Text | sed '1s/^/**人社部文件發佈**     /g' | sed 's/ \".*\"//g' > $MDText

. $HOME/CSObot/toMe.sh "$Text" "$MDText" "人社部"

# 5.------------------------
curl http://www.mohurd.gov.cn/wjfb/index.html | grep "href=.*$Month" > $Text

        pandoc -f html -t markdown_github $Text | sed '1s/^/**住建部文件發佈**     /g' > $MDText

. $HOME/CSObot/toMe.sh "$Text" "$MDText" "住建部"

# 6.------------------------
curl http://www.miit.gov.cn/n1146295/n1652858/index.html | grep -2 "href=.*$Month1" | grep -v "href=.*$Month1" | sed 's/\.\.\/\.\./http:\/\/www.miit.gov.cn/g' > $Text
	# 政策文件
curl http://www.miit.gov.cn/n1146295/n1146557/n1146624/index.html | grep -2 "$Month1" | sed 's/\.\.\/\.\.\/\.\./http:\/\/www.miit.gov.cn/g' >> $Text
	# 部門規章
curl http://www.miit.gov.cn/n1146295/n1146557/index.html | grep -2 "$Month1" | sed 's/\.\.\/\.\./http:\/\/www.miit.gov.cn/g' >> $Text
	# 法律法規

        pandoc -f html -t markdown_github $Text | sed '1s/^/**工信部文件和規章發佈**     /g' > $MDText

. $HOME/CSObot/toMe.sh "$Text" "$MDText" "工信部"

echo "Done. Sended to TGbots."
echo
exit 0
