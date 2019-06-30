#!/bin/bash
# Crawl NGOCN.net's contents regularly. And send them to my Bot :)
# Initiated at 2016.07.23. Revised at 2017.07.15 (make it sent to IRC bot)
# 2.0


. $HOME/CSObot/variables.sh "ngo-cn"
#. variables.sh "ngo-cn"

# echo "----Today's news from NGOCN.net, $Date1.----" > $Text

curl http://www.ngocn.net | grep "www.ngocn.net/news/$Date1" | grep -v "/upload/" > $Text

pandoc -f html -t markdown $Text -o $MDText

sed -i '1s/^/----Today news from NGOCN.net: /g' $MDText

cat $MDText >> $Final


