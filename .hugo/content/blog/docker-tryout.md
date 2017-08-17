+++
categories = ["Server"]
date = "2014-02-09T02:09:46+09:00"
draft = false
slug = "docker-tryout"
title = "Dockerが公式にOS Xに対応したので試してみた"
+++

### boot2docker

<blockquote class="blockquote">
  <p class="m-b-0">
	First, install the Docker binary which will forward all commands to a remote docker daemon
	Second, install Boot2Docker, which is a super-lightweight Linux VM capable of running a docker daemon on your Mac with the smallest possible overhead. Currently it occupies 24MB on disk and boots in less than 10 seconds.
  </p>
  <footer class="blockquote-footer"><cite title=""><a href="http://blog.docker.io/2014/02/docker-0-8-quality-new-builder-features-btrfs-storage-osx-support/">DOCKER 0.8: QUALITY, NEW BUILDER FEATURES, BTRFS, OSX SUPPORT</a></cite></footer>
</blockquote>

とのこと。まず[boot2docker](https://github.com/steeve/boot2docker)について。これはなんだ、と。

- これまでMacでDockerを使う場合はVirtualBoxなりVMware FusionなりでUbuntuとかを動かして、その中でDockerを使う必要があった
- しかしそれでは毎回最初の一歩が重くてDockerのメリットが活かせないし、ネイティブにDockerを使えたほうが何かと便利
- そこでboot2dockerというものが考案された
- これは厳密にはソフトウェアではなく、Dockerを動かすことに特化したTiny Core Linuxベースのisoイメージと、それをインストールしたVirtualBoxをコントロールするシェルスクリプトの組み合わせ
- boot2dockerが起動している状態であれば、OS XのターミナルからDockerを直接操作できる（Docker 0.8になって公式にOS Xをサポートした、というのはこの部分かと）
- これについてさらっとこのページの一番下（About the way Docker works on Mac OS X）に書いてある。MacにはLXCとかがないからねーということで。：[Requirements and Installation on Mac OS X 10.6 Snow Leopard - Docker Documentation](http://docs.docker.io/en/latest/installation/mac/)

という理解でいいのでしょうか？たぶん合ってる。要はboot2docker stopするとTerminalからdockerコマンド使えない。その関係性をdaemonとclientと言ってる。

### インストール手順
Oracle VirtualBox 必須。ここからDL & インストロール。[Downloads – Oracle VM VirtualBox](https://www.virtualbox.org/wiki/Downloads)

ドキュメントではgithubからcurlしてるけど、tapを追加すればhomebrewで入れられる。

```bash
$ brew tap homebrew/binary
$ brew install docker boot2docker
$ docker -v
Docker version 0.8.0, build cc3a8c8
```

これも必須（docker - VM間の通信用）

```bash
export DOCKER_HOST=tcp://
```

Tiny Core Linuxのisoを格納するディレクトリを適当に作って適当に移動

```bash
$ cd && mkdir docker && cd docker
```

VirtualBox上にディスクイメージを準備・起動。initでisoがDLされる。.vmdkも後でここにできる。

```bash
$ boot2docker init
$ boot2docker up
```

確認

```bash
$ boot2docker status
 [2014-02-09 00:39:35] boot2docker-vm is running.
```

これでTerminalからdockerが使える。CentOSをpullして

```bash
$ docker pull centos
```

コンテナに入る

```bash
$ docker run -i -t centos /bin/bash
```

あとは普通にdocker。なんていうか全体的にシンプルかつ最善を尽くした感じの良いソリューションで素敵。

それにしてもコンテナ型VMの速度にはびっくりする。昔OpenVZ好きじゃなかったけど、LXCはLinuxカーネルにも取り込まれたり、もうすぐ1.0も出たりと期待できる。今のところプロダクション環境より検証とかテストに向いてるイメージ。
