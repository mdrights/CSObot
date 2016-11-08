#!/bin/bash

. $HOME/CSObot/variables.sh "gwy-bw"

# 3.------------------------

curl http://www.nhfpc.gov.cn/zhuzhan/gongw/lists.shtml | grep "href=.*$Month" | sed 's/\.\.\/\.\./http:\/\/www.nhfpc.gov.cn/g' > $Text

        pandoc -f html -t markdown_github $Text | sed -e '1s/^/**衛生計生委文件發佈**     /g' -e 's/ \".*\"//g' -e 's/&gt//g'  > $MDText

. $HOME/CSObot/toMe.sh "$Text" "$MDText" "卫生计生委"


exit

