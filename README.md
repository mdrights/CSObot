# CSObot (beta)

- A bot serving the civil society organisations in China.
- 一個幫助中國的公民社會組織的機器人(bot)。

## Features

- 推送平台：
	- #csobot:matrix.org （Matrix 平台的房间）
	- https://t.me/csobotcn (Telegram bridged from Matrix)
	- #aqi-data-share (IRC at OFTC) 

- `IPFS 转换器`：把单一网页上传到 IPFS 并返回相应 IPFS gateway 网址，可以免翻墙访问该网页（返回约15个 IPFS 网址，可任选其一，大部分经墙内测试可通）。  
	- 在以上平台里输入：  
	```
		ipfs-add 要转换的网页

		或

		ipfs-add-all 要转换的网页
	``` 
	> 注1：第一条命令只抓取网页文字和一些简单的元素；第二条命令会抓取站内文字、部分图片和 js/css 等元素（更接近原网页但反应较慢——约2～5分钟）。   

	> 注2: 使用第二条命令时`要转换的网页`网址需要带上`https://` 或 `http://`，且末尾不能带`/`。


- 检查`[Signal](https://signal.org)`Android 无谷歌框架版的更新（[官方发布网站](https://signal.org/android/apk/)），如有更新，推送下载链接和其校验码。（每日2次）

- ~~`OONI probe` 探测可能被墙的华文新闻媒体网站（采用 Citizen Lab 的[cn 列表](https://github.com/citizenlab/test-lists/blob/master/lists/cn.csv), [hk 列表](https://github.com/citizenlab/test-lists/blob/master/lists/hk.csv), [tw 列表](https://github.com/citizenlab/test-lists/blob/master/lists/tw.csv)中的`NEWS`类别的url），每日执行一次。生成报告并发送到 [OONI API](https://api.ooni.io), 报告编号和被墙网站数量推送到以上平台。~~  

## Structure
- 兩部分：
	- IRC bot （即最外層目錄下的腳本）
	> 只提供發送消息到 IRC 平臺的功能（通常要在系統上設置定時任務）。 
	- Matrix bot （在`matrix-bot`目錄下，改造自`tiny-matrix-bot`）
	> 只發送消息到 Matrix 平臺（房間如上），可在其配置文件設置定時任務時間。
	- Matrix bot（外部）
	> 可以在 Matrix 平臺接收指令並返回結果。代碼在: [tiny matrix bot](https://github.com/mdrights/tiny-matrix-bot)。如需使用，請記得 clone（或下載）它。  

- 部署方法：
	- IRC bot 無需額外操作，直接運行；  
	- Matrix bot：
	```
	   > 依賴組件
		# apt install python3 python3-requests curl jq
	    $ pip3 install --user schedule              （必須以普通用戶執行）

	   ( 如果腳本需要`IPFS`則需另單獨下載解壓即可, default path: `~/bin/go-ipfs/ipfs`)

	   git clone https://github.com/mdrights/csobot
	   git clone https://github.com/matrix-org/matrix-python-sdk   (依賴庫)

	   cd csobot/matrix-bot
	   ln -s ../../matrix-python-sdk/matrix_client

	   > 修改配置文件
	   cp csobot-matrix.cfg.sample csobot-matrix.cfg
	   vi csobot-matrix.cfg

	   > 設置到系統服務
		# cp csobot-matrix.service /etc/systemd/system
	    $ vi /etc/systemd/system/csobot-matrix.service

	   systemctl enable csobot-matrix
	   systemctl start csobot-matrix
	```

## Updates
- 2020.02.26	新增：matrix-bot，直接發送消息到 Matrix 平臺。  
- 2019.11.19	新增：ipfs-add-all 命令，抓取更多网页元素。  
- 2019.08.31	新增：check-ipfs-gateway.sh（位于墙内节点）。`ipfs-add`生成网页的 ipfs hash 时使用该脚本生成的 gateway 列表里的网址。
- 2019.07.21	新增：check-signalapp.sh（位于墙内节点）。  
- 2019.07.20	新增：提供 IPFS 相关功能
- 2019.06.09	新增 run-ooni-probe.sh


## TODO
- [x] `IPFS 转换器`：会抓取该网页站内文字、部分图片和 js/css 等元素。但不抓取站外、第三方资源。
- [ ] 查询墙内可用的 IPFS gateway 服务（可用服务列表来自：[public gateway list](https://github.com/ipfs/public-gateway-checker/blob/master/gateways.json)）。

<hr />

## 什么是 Matrix 房间？

[Matrix](https://matrix.org) 是一种新型去中心化通讯标准，它让互相通讯的客户端可以不再依赖唯一的中心化的服务器，实现的是多中心的自选或自建的服务器作为服务端。目前在这个标准上实现的客户端最流行的是 [Riot.im](https://about.riot.im/)，各平台均有。 Riot.im 也有網頁版: https://riot.im/app   

### 注册一个账号

由于服务端可以自选/自建，就不必一定用官方的 matrix.org 注册账号了。目前有这些公开的他人运营的 Matrix 服务端：https://www.hello-matrix.net/public_servers.php   

启动 app 或桌面版时应该都可见注册的入口，旁边可自行选择 `home server` 作为自己帐号的所在服务器。  

### 加入一个房间
手机版点击「+」，桌面/网页版点击「Explore」，搜索关键词如`csobot` 应该能见到该房间，点击进入。

