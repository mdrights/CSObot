#!/bin/bash
## Grab notices, news and new-release of policies on SZ Government's website.
## Initiated at 2016-08-05
## It only sends to me.


. $HOME/CSObot/variables.sh "sz"

# 1.-----------------------

curl http://www.sz.gov.cn/cn/xxgk/szgg/tzgg/ | grep "$Date" > $Text  #The current day.

	iconv -f GB2312 -t UTF-8 $Text > $Text1
	pandoc -f html -t markdown $Text1 -o $MDText	
	sed '1s/^/深圳政府官网通知    /g' $MDText | sed 's/\.\//http:\/\/www.sz.gov.cn\/cn\/xxgk\/szgg\/tzgg\//g' | sed 's/ \".*\"//g' > $MDText1

. $HOME/CSObot/toMe.sh "$Text" "$MDText1" "深圳政府官网"
	

# 2.-----------------------

#curl http://www.sz.gov.cn/xxgk/zcfg/ | sed '/title/d' > $Text                   # Failed to convert codes if this line exists.

#iconv -f GB2312 -t UTF-8 $Text > $Text1						# Convert codes to UTF otherwise failing to grab content.

#sed -n -e '/.*深圳市法规及规章.*/,/.*rightAreaEnd.*/ { p }' $Text1 > $Text2	# Grab the content I want.

# if [ -s "$Text" ]; then
#        pandoc -f html -t markdown $Text2 -o $MDText				# TG fails to render markdown if there's any "_" in links.
#	sed 's/\.\.\/\.\./http:\/\/www.sz.gov.cn/g' $MDText > $MDText1
#        w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=64960773&text=`cat $MDText1`" 1&>/dev/null
#else
       # w3m "https://api.telegram.org/bot$Token/sendmessage?chat_id=64960773&parse_mode=Markdown&text=Oops, no news today." 1&>/dev/null
#fi


# 3.-----------------------

curl http://fzb.sz.gov.cn/xxgk/qt/tzgg/ | grep "href=.*$Month" | sed 's/href=\"\./href=\"http:\/\/fzb.sz.gov.cn\/xxgk\/qt\/tzgg/g' > $Text
curl http://fzb.sz.gov.cn/xxgk/qt/gzdt/ | grep "href=.*201611" | sed 's/href=\"\./href=\"http:\/\/fzb.sz.gov.cn\/xxgk\/qt\/tzgg/g' >> $Text

iconv -f GB2312 -t UTF-8 $Text > $Text1						# Convert codes to UTF otherwise failing to grab content.
pandoc -f html -t markdown $Text1 | sed '1s/^/*深圳市府法制办通知公告*    /g' > $MDText		

. $HOME/CSObot/toMe.sh "$Text" "$MDText" "深圳市法制办"

# 4.-----------------------

echo
exit 0
