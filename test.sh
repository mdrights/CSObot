#!/bin/bash

. $HOME/CSObot/variables.sh "gwy-bw"

# 1.-----------------------

curl www.sda.gov.cn/WS01/CL0014/ | grep -2 "$Month1" | iconv -f GB2312 -t UTF-8 | sed 's/\.\./http:\/\/www.sda.gov.cn\/WS01/g' > $Text

        pandoc -f html -t markdown $Text | sed '1s/^/*国家食品药品监督总局征集意见----*     /g' > $MDText

. $HOME/CSObot/toMe.sh "$Text" "$MDText" "国家食品药品监督总局"


exit

