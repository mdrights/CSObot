#!/bin/bash

. $HOME/CSObot/variables.sh "gz"

curl http://www.gzlo.gov.cn/sofpro/bmyyqt/gzsfzb/lfzqyj/opinion.jsp | sed -n -e '/add.jsp/,/征集中/ { p; }' > $Text

        sed 's/href=/href=http:\/\/www.gzlo.gov.cn/g' $Text > $Text1
        pandoc -f html -t markdown $Text1 -o $MDText
        sed '1s/^/*广州市府法制办征求意见*    /g' $MDText > $MDText1

. $HOME/CSObot/toMe.sh "$Text" "$MDText1" "广州市法制办"

exit
