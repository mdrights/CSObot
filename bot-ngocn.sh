#!/bin/bash
# Grab NGOCN.net's contents regularly. And send them to my Bot :)
# Initiated at 2016.07.23
# 1.2.0


. $HOME/CSObot/variables.sh "ngo-cn"

curl http://www.ngocn.net | grep "www.ngocn.net/news/$Date1" | grep -v "/upload/" > $Text

	echo "<em>Today's news from NGOCN.net, $Date1.</em>" >> $Text
	pandoc -f html -t markdown $Text -o $MDText

. $HOME/CSObot/toMe.sh "$Text" "$MDText" "NGOCN.net"

echo "News had been sent."
exit 0
