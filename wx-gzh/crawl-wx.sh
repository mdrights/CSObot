#!/bin/bash
#

set -eu

Date=$(date +%s)
GZH="ngocn05"

TMP="/tmp"
URL1="wx.sogou"
Page1="wx.gzh.json"
Page2="wx.gzh.md"
LINK1="wx.link1"

# Crawl the search result page of GZH on weixin.sogou.com 
echo "Crawl the search result page of GZH on weixin.sogou.com" 

wget --follow-tags="<A>" --user-agent="Mozilla/5.0 (Windows NT 6.1; rv:54.0) Gecko/20100101 Firefox/54.0" -O - "http://weixin.sogou.com/weixin?type=1&s_from=input&query=$GZH" | grep "account_name_0" | awk -F'"' '{print $6}' | sed 's/amp;//g' > $TMP/$URL1

sed -i "s/timestamp=.*\&/timestamp=$Date\&/g" $TMP/$URL1

# Crawl the GZH's homepage (might be expired that needs verification code :(
echo "Crawl the GZH's homepage (might be expired that needs verification code :("

wget --user-agent="Mozilla/5.0 (Windows NT 6.1; rv:54.0) Gecko/20100101 Firefox/54.0" -O - "$(cat $TMP/$URL1)" | grep "var msgList" > $TMP/$Page1

# Parse JSON in the page
echo "Parse JSON in the page"

sed -e 's/[{}]/''/g' $TMP/$Page1 | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' > $TMP/$Page2

# Absorb the links of articles in the homepage, and parse them.
echo "Absorb the links of articles in the homepage, and parse them."

grep "content_url" $TMP/$Page2 | sed 's/amp;//g' | awk -F'"' '{print $4}' | sed '/mp.weixin.qq.com/ d' | sed '/^$/ d' | sed 's@^@http:\/\/mp.weixin.qq.com@g' | sed "s/timestamp=.*\&/timestamp=$Date\&/g" > $TMP/$LINK1  

# Grab the pages of articles
echo "Grab the pages of articles"

links=$(cat $TMP/$LINK1)
pageDir="$HOME/$GZH"

[[ ! -d "$pageDir" ]] && mkdir $pageDir

n=1
for link in $links
do
	wget --user-agent="Mozilla/5.0 (Windows NT 6.1; rv:54.0) Gecko/20100101 Firefox/54.0" -O "$pageDir/$n.html"
	n=$n+1
done

echo "Done!"
exit
