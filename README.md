## CSObot (alpha)

- A bot serving the civil society organisations in China.
- 一個幫助中國的公民社會組織的機器人(bot)。

## This bot will grab and push:  
- 目前推送：
	- 推送平台：
		- #csobot:matrix.org （Matrix 平台的房间）
		- #aqi-data-share (irc at OFTC) 

	- `OONI probe` 探测可能被墙网站（采用 Citizen Lab 的[cn 列表](https://github.com/citizenlab/test-lists/blob/master/lists/cn.csv)），每日执行一次。 
		- OONI probe 报告发送到 [OONI API](https://api.ooni.io), 报告编号和被墙网站数量推送到以上平台。  
	- 检查`Signal (Android)`无谷歌框架版的更新（[官方发布网站](https://signal.org/android/apk/)），如有更新，推送下载链接和其校验码。（每日3次）
	- `IPFS 转换器`：把单一网页上传到 IPFS 并返回相应 IPFS gateway 网址，这样可以从免翻墙访问该网页（返回5个url，大部分经墙内测试可用）。  
		- 在以上平台里发送： 
		```
			ipfs-add <url>
		``` 
		稍等片刻即可得到 IPFS gateway 网址。
	- 查询墙内可以的 IPFS gateway 服务（可用服务列表来自：[public gateway list](https://github.com/ipfs/public-gateway-checker/blob/master/gateways.json)）。
	```
		ipfs-gw
	```

## Updates
- 2019.08.31	新增：check-ipfs-gateway.sh（位于墙内节点，设定时任务），及`ipfs-gw`（墙内节点）。`ipfs-add`生成网页的 ipfs hash 时可以使用该脚本生成的gateway列表里的网址（当前采用生成的列表的最后5个url）。
- 2019.07.21	新增：check-signalapp.sh
- 2019.07.20	新增：提供 IPFS 相关功能（如上）：[tiny matrix bot](https://github.com/mdrights/tiny-matrix-bot)，可见代码仓库及部署方法。
- 2019.06.09	新增 run-ooni-probe.sh

## TODO
- `IPFS 转换器`：目前只能转换网页自身的内容，不转第三方内容，也无法解析 javascript 内容。
