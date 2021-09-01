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

## 什么是 Matrix ？以及 Element？  

[Matrix](https://matrix.org) 是一种新型去中心化通讯网络，它让互相通讯的客户端可以不再依赖唯一的中心化的服务器，实现的是多中心的自选或自建的服务器作为服务端。目前在这个网络上的客户端软件有很多，其中最流行的是 [Element](https://element.io/)，在各操作系统平台均有版本，也有PC桌面和網頁版: https://app.element.io   

用最最简单的（人）话来说，就是 Matrix 这玩意其实借鉴了 Email 的连结方式。大家可曾记得每人的电子邮件地址：`abc@xyz.com` —— xyz.com 就是自己可以选择的邮件服务商，不同人可以选择不同的服务商，互相之间都可以通信。这就是古老但有效的去中心化的方式（只是到了现代，很多通讯软件都只允许用户使用官方的服务了，不能选择别人的，因为都不可能自己搭建该软件的服务器～呵呵）  

因此，在使用和注册 Matrix 的时候，请大家不要怕麻烦，选择其中一家服务者的服务器进行注册和登录，之后的互相通讯就没什么特别的了（服务器列表在下文的链接李）。顺便说一句，只有这样，才能抵抗无论是政府的封锁和软件服务商自己的原因拒绝提供服务了。  

那么如果你还想问 Matrix 和 Element 的关系时，可以拿 Email 来帮忙理解：Email vs Gmail vs Outlook 客户端。 小明想使用 Email，于是她去 Gmail 注册了一个邮箱，然后她再在自己的电脑上打开了 Outlook 客户端，登录自己的 Gmail 账号，愉快地接收邮件了。所以 Matrix 好比 Email，下面的众多服务器（home server）就相当于 Gmail，Protonmail，Element 就好比邮件客户端（如 Outlook，Apple Mail，Thunderbird，QQ），三种东西基本都可以互相组合使用不会有什么例外。    

### 注册一个账号

那么由于服务端可以自选/自建，就不必一定用官方的 matrix.org 注册账号了（而且也被墙了）。  
目前有这些公开的他人运营的 Matrix 服务端（其实大多都是非营利组织的）：    
```  
https://www.hello-matrix.net/public_servers.php   
```  

启动 app 或桌面/网页版时应该都可见注册的入口，旁边可自行选择 `Other homeserver` 然后输入上面其中一个服务器地址作为自己帐号的所在服务器。  

![element-register](https://shitpost.to/i/wakknbccvu31kpez.png?key=ZJCyyeA8v7CVKJ7SHczPm0xxtXQflsSY)

### 加入一个房间

手机版点击「+」，桌面/网页版点击 Filter 输入框旁边的小指南针图标（看到了吗？是的我承认这UI的设计……），搜索关键词如`csobot` 应该能见到该房间，点击进入。 注意：只有公开的房间才能搜索到，不开放的房间可以通过邀请直接进入。  

![enter and find](https://shitpost.to/i/2uptfkqeln7vyiug.png?key=lilubSYvNhJWGWuSXdvcH3RPLp1HcVvj)

![join a room（样式略有差异）](https://assets.matters.news/processed/1080w/embed/57b482de-fcf5-401c-9ebd-f63e954651d4/screenshot-2019-7-29-riot.webp)

### 创建一个房间

也和加入房间差不多，只是在进入之后的输入框上方点击文字超链接：`create a new room`。  

（由于 Matrix 和 Element 还在不断开发中，因此此文对应的是 2021年初的版本）  
