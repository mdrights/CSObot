## CSObot (alpha)

- A bot serving the civil society organisations in China.
- 一個幫助中國的公民社會組織的機器人(bot)。

## This bot will grab and push:  
- 目前推送：
	- 推送平台：
		- #csobot:matrix.org （Matrix 平台的房间）
		- #aqi-data-share (irc at OFTC) 

	- `IPFS 转换器`：把单一网页上传到 IPFS 并返回相应 IPFS gateway 网址，可以免翻墙访问该网页（返回约15个url，大部分经墙内测试可通）。  
		- 在以上平台里发送：  
		```
			ipfs-add url

			或

			ipfs-add-all url
		``` 
		> 注：第一条命令只抓取网页文字和一些简单的元素；第二条命令会抓取站内文字、部分图片和 js/css 等元素（更接近原网页但反应较前者慢）。   

	- 查询墙内可以的 IPFS gateway 服务（可用服务列表来自：[public gateway list](https://github.com/ipfs/public-gateway-checker/blob/master/gateways.json)）。
	```
		ipfs-gw
	```

	- `OONI probe` 探测可能被墙的华文新闻媒体网站（采用 Citizen Lab 的[cn 列表](https://github.com/citizenlab/test-lists/blob/master/lists/cn.csv), [hk 列表](https://github.com/citizenlab/test-lists/blob/master/lists/hk.csv), [tw 列表](https://github.com/citizenlab/test-lists/blob/master/lists/tw.csv)中的`NEWS`类别的url），每日执行一次。 
		- OONI probe 报告发送到 [OONI API](https://api.ooni.io), 报告编号和被墙网站数量推送到以上平台。  

	- 检查`Signal (signal.org)`无谷歌框架版的更新（[官方发布网站](https://signal.org/android/apk/)），如有更新，推送下载链接和其校验码。（每日2次）

## Updates
- 2019.11.19	新增：ipfs-add-all 命令，抓取更多网页元素。（代码在[tiny matrix bot](https://github.com/mdrights/tiny-matrix-bot)）  
- 2019.08.31	新增：check-ipfs-gateway.sh（位于墙内节点），及`ipfs-gw`（代码在[tiny matrix bot]）。`ipfs-add`生成网页的 ipfs hash 时可以使用该脚本生成的gateway列表里的网址。
- 2019.07.21	新增：check-signalapp.sh（位于墙内节点）。  
- 2019.07.20	新增：提供 IPFS 相关功能：[tiny matrix bot](https://github.com/mdrights/tiny-matrix-bot)，可见代码仓库及部署方法。
- 2019.06.09	新增 run-ooni-probe.sh

## TODO
- [x] `IPFS 转换器`：会抓取该网页站内文字、部分图片和 js/css 等元素。但不抓取站外、第三方资源。
