## CSObot (alpha)

- A bot serving the civil society organisations in China.
- 一個幫助中國的公民社會組織的機器人(bot)。

## This bot will grab and push:  
- 目前推送：
	- 推送平台：
		- #aqi-data-share (irc at OFTC) 
		- #csobot:matrix.org （Matrix 平台的房间）
	- `OONI probe` 探测可能被墙网站（采用 Citizen Lab 的[cn 列表](https://github.com/citizenlab/test-lists/blob/master/lists/cn.csv)），每日执行一次。 
		- OONI probe 报告发送到 [OONI API](https://api.ooni.io), 报告编号和被墙网站数量推送到以上平台。  
	- `IPFS 转换器`：把单一网页上传到 IPFS 并返回相应 IPFS gateway 网址（大部分可直接访问；约4～5个url） 
		- 用户发送 `ipfs-add <url>` 稍等片刻即可得到 IPFS gateway 网址（如果遇到下载网页失败请再试一下） 
	- 检查`Signal (Android)`无谷歌框架版的更新（[官方发布网站](https://signal.org/android/apk/)），如有更新，推送下载链接和其校验码。（每日3次）

## Updates
- 新增 check-signalapp.sh
- 新增 run-ooni-probe.sh
- 新增 ：提供 IPFS 相关功能（如上）；代码仓库及部署方法见：[tiny matrix bot](https://github.com/mdrights/tiny-matrix-bot)

（最后更新时间：2019-07-28 )
