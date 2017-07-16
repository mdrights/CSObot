#!/bin/bash
## Grab notices, news and new-release of policies on SZ Government's website.
## Initiated at 2016-08-05


. $HOME/CSObot/variables.sh "sz"
# . variables.sh "sz"

# 1.-----------------------

wget --follow-tags="<A>" --user-agent="Mozilla/5.0 (Windows NT 6.1; rv:54.0) Gecko/20100101 Firefox/54.0" -O - http://www.sz.gov.cn/cn/xxgk/zfxxgj/tzgg/ | grep -a "$Date" > $Text

	iconv -f GB2312 -t UTF-8 $Text > $Text1
	pandoc -f html -t markdown $Text1 -o $MDText	
	sed -i -e '1s/^/----深圳政府官网通知----/g' -e 's/\.\//http:\/\/www.sz.gov.cn\/cn\/xxgk\/zfxxgj\/tzgg\//g' -e 's/ \".*\"//g' $MDText

cat $MDText >> $Final

#. $HOME/CSObot/toAll.sh "$Text" "$MDText1" "深圳政府官网"
	

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

#curl http://fzb.sz.gov.cn/xxgk/qt/tzgg/ | grep "href=.*$Month" | sed 's/href=\"\./href=\"http:\/\/fzb.sz.gov.cn\/xxgk\/qt\/tzgg/g' > $Text
#curl http://fzb.sz.gov.cn/xxgk/qt/gzdt/ | grep "href=.*201611" | sed 's/href=\"\./href=\"http:\/\/fzb.sz.gov.cn\/xxgk\/qt\/tzgg/g' >> $Text

#iconv -f GB2312 -t UTF-8 $Text > $Text1						# Convert codes to UTF otherwise failing to grab content.
#pandoc -f html -t markdown $Text1 | sed '1s/^/*深圳市府法制办通知公告*    /g' > $MDText		

#. $HOME/CSObot/toAll.sh "$Text" "$MDText" "深圳市法制办"

# 4.-----------------------

