+++
categories = ["Server"]
date = "2013-02-11T04:13:15+09:00"
draft = false
slug = "how-to-install-dnsmasq-on-mountain-lion"
title = "Mountain Lionにdnsmasqをインストールするメモ"
+++

タイトル通りではあるけど、いろいろハマったのでメモ。

[dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html)というのは簡易DNS/DHCPサーバー。/etc/hostsを書き換えるよりもう少し低いレイヤーでレコードを書き換えてくれるイメージ（フォワーダーと呼ばれたりする）。なので、Aレコードだけではなくほとんどのレコード書き換えができたりします。詳細は[Wikipedia](http://ja.wikipedia.org/wiki/Dnsmasq)とかで。今回はMXレコードを書き換えたい事情があって導入してみた。

#### インストール

いつも通り、homebrew様。brew後に出てくるビールの絵文字がかわいい。

```bash
$ brew update && brew install dnsmasq
```

#### 設定

confを複製して編集

```bash
$ cp -a /usr/local/Cellar/dnsmasq/2.65/dnsmasq.conf.example /usr/local/etc/dnsmasq.conf
$ vim /usr/local/etc/dnsmasq.conf
```

以下を書き換え

```bash
resolv-file=/etc/resolv.dnsmasq.conf
listen-address=127.0.0.1
conf-dir=/usr/local/etc/dnsmasq.d
```

conf用ディレクトリを作成

```bash
$ mkdir /usr/local/etc/dnsmasq.d
```

plistを複製。Macの場合、launchctlがこのplistに書かれているオプションとかをつけてバイナリを実行する。

```bash
$ sudo cp /usr/local/Cellar/dnsmasq/2.65/homebrew.mxcl.dnsmasq.plist /Library/LaunchDaemons
```

現在のDNSキャッシュサーバーのIPを、dnsmasq用のresolv.confに書く。フィルタにマッチしなかった場合これに問い合わせることになる。

```bash
$ cat /etc/resolv.conf
$ sudo vim /etc/resolv.dnsmasq.conf
```

起動

```bash
$ sudo launchctl load -w /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
```

確認

```bash
$ scutil --dns
$ ps ax | grep [d]nsmasq
```

キャッシュサーバーをdnsmasqに変更（この時点でミスがあると名前が引けなくなる）

```bash
$ sudo networksetup -setdnsservers Wi-Fi 127.0.0.1
```

確認

```bash
$ dig apple.com A
;; ANSWER SECTION:
apple.com.		1715	IN	A	17.172.224.47
apple.com.		1715	IN	A	17.149.160.49
```

ためしに変更をかける。書式はこんな感じで、confにいろいろヘルプが書いてある。

```bash
$ echo "address=/apple.com/127.0.0.1" > /usr/local/etc/dnsmasq.d/apple.com
```

再起動

```bash
$ sudo launchctl unload -w /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
$ sudo launchctl load -w /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
$ sudo dscacheutil -flushcache
```

見てみる

```bash
$ dig apple.com
;; ANSWER SECTION:
apple.com.		0	IN	A	127.0.0.1
```

変わってる。ちなみにMXレコードの場合はこんな感じで書く。

```bash
$ cat /usr/local/etc/dnsmasq.d/fixture.jp
mx-host=fixture.jp,mail.example.com,10
```

#### 感想

はい、めんどくさいですね。けどレコードが自由自在に書き換えられて、ローカルで開発するときとか一つ世界が広がると思うのでオススメです。

#### 備考

バグなのかわからないけど、launchctl unload &amp;&amp; launchctl loadでうまくconfigを参照してくれないことがある。その場合はMacの環境設定側のDNSを一旦空にして（つまりルーターとかを見に行くようにして）もう一回127.0.0.1に設定してあげると直る。で、それを元に下記みたいな再起動スクリプトとかを書いておくと便利。

```bash
#!/bin/sh

ps ax | grep [d]nsmasq
sudo launchctl unload -w /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
sudo launchctl load -w /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
ps ax | grep [d]nsmasq
dscacheutil -flushcache
sudo networksetup -setdnsservers Wi-Fi empty
sudo networksetup -setdnsservers Wi-Fi 127.0.0.1
```

#### 余談
- `brew install zsh` で5.0.2が入ってびっくりした。[本家zsh.orgには今のところ5.0.0までしか出てない](http://zsh.sourceforge.net/Arc/source.html)し。[github](https://github.com/zsh-users/zsh)側には5.0.2まで上がってるけど。
- `brew install imagemagick` が速すぎてもう一回びっくりした。しかもほぼ最新の6.8.0。コンパイル済みbottole.tar.gzを落としてきてるだけだから当たり前なんだけど、改めてhomebrewやばい。
