+++
categories = ["Server"]
date = "2015-08-10T16:18:52+09:00"
description = "やっとこのブログをWordPressからHugoに移動したのでその過程をメモしておく。この後にテーマ作成編が続く（予定）。"
draft = false
slug = "moved-to-hugo-s3-install"
title = "Hugo + S3環境に移行した（インストール編）"

+++

<p class="text-xs-center" style="margin-bottom: 60px;"><a href="https://gohugo.io/"><img src="/images/2015/08/hugo.png" style="width: 300px"></a></p>

やっとこのブログをWordPressから[Hugo](https://gohugo.io/)に移動したのでその過程をメモしておく。この後にテーマ作成編が続く（予定）。

### Hugo

Hugoは高速なビルドが特徴の、Go製スタティックサイトジェネレータ。いろいろなところで紹介されているので説明は省略。今回は生成したサイトをAmazon S3でホストする。

### 環境

Hugoは安定版を[バイナリ](https://github.com/spf13/hugo/releases)でリリースしているが、開発版をソースからビルドしたいのでGoの環境を入れておく。デプロイはS3にするのでawscliが必要。また、プレビュー用のVirtual Hostを作るのでNginxを入れておく。これは別にApacheでもいい。

```bash
$ cat /etc/redhat-release
CentOS Linux release 7.1.1503 (Core)

$ go version
go version go1.4.2 linux/amd64

$ git version
git version 1.8.3.1

$ pyenv versions
  system
* 2.7.10 (set by /root/.pyenv/version)
  3.4.3

$ pip list | grep aws
awscli (1.7.42)

$ aws --version
aws-cli/1.7.42 Python/2.7.10 Linux/3.10.0-229.7.2.el7.x86_64

$ nginx -v
nginx version: nginx/1.9.3
```

### Hugoインストール

[ドキュメント](http://gohugo.io/overview/installing/)通り。

```bash
$ go get -v github.com/spf13/hugo
$ hugo version
Hugo Static Site Generator v0.15-DEV BuildDate: 2015-07-06T00:25:59+09:00
```

### 新しいHugoサイトを作る

```bash
$ hugo new site fixture.jp
$ cd fixture.jp
$ git clone --recursive https://github.com/spf13/hugoThemes themes
```

`theme.toml` はこんな感じ。

```toml
baseurl = "http://fixture.jp"
languageCode = "en-us"
title = "fixture.jp"
theme = "furniture"

[permalinks]
    blog = "/blog/:year/:month/:slug/"

[taxonomies]
    category = "categories"

[author]
    name = "Sho Mizutani"

[params]
    twitter = "lowply"
    github = "lowply"
```

### Nginxでプレビュー用のVHを作る

Mac上ではなくVPS上で開発するので、ブラウザから localhost:1313 を開いてチェック、というHugoが想定している使い方ができない。しょうがないので80番で待ち受けて 127.0.0.1:1313 にリバースプロキシするVirtual Hostを適当に作っておく。

`./run.sh` で走らせるようにしておくと便利。

```bash
#!/bin/bash

hugo server -Dw --baseUrl="test.fixture.jp" --appendPort=false --disableLiveReload=true

# -D: publish draft
# -w: watch file change and rebuild automatically
# --baseURL: change base URL from localhost
# --appendPort: don't append :1313 at the end of the base URL
# --disableLiveReload: don't use live reload because it works only on local environment
```

詳細は`hugo server --help`にて。

### テスト記事を投稿して確認

```bash
$ hugo new blog/about.md
$ vim content/blog/about.md
$ ./run.sh
```

ブラウザから [http://test.fixture.jp/](http://test.fixture.jp/) を開いて見えていればOK。

### S3 Static Website Hosting

S3でのStatic Website Hostingについてはこのスライドがわかりやすい。

[Amazon S3による静的Webサイトホスティング](http://www.slideshare.net/horiyasu/amazon-s3web-27138902)

この手順を参考に

- FQDNと同名のバケットを作る
- Static Website HostingをEnableにしたりBucket Policyを設定しておく
- Route53 にてAレコードをAliasにし、S3 Website Endpointsからバケット名を選択して登録
- Route53 を使っていない場合は普通にエンドポイントに対してCNAMEを設定

とやっておく。その後適当なファイルをバケットに置いて確認。

### S3にデプロイ

デプロイには下記のようなスクリプトを作っておくと便利。`./sync.sh`でビルドしてsyncしてくれる。

```bash
#/usr/bin/env bash

# for multibyte filenames
export LANG=en_US.UTF-8

LOGDIR="./log"
PUBDIR="./public"
LOGFILE="${LOGDIR}/$(date +%y%m%d_%H%M%S).log"
OPTS="--profile default --no-follow-symlinks --delete"
BUCKET="s3://fixture.jp"

logger(){
	echo "$(date): [Info] ${1}" | tee -a ${LOGFILE}
}

error(){
	echo "$(date): [Error] ${1}" | tee -a ${LOGFILE} 1>&2 
	exit 1
}

main(){
	type aws > /dev/null 2>&1 || error "aws cli is not installed"
	type hugo > /dev/null 2>&1 || error "hugo is not installed"
	hugo
	[ -d ${LOGDIR} ] || mkdir ${LOGDIR}
 	logger "Sync starts"
	aws s3 ${OPTS} sync \
		--exclude "assets/.sass-cache/*" \
		${PUBDIR} ${BUCKET} | tee -a ${LOGFILE}
 	logger "Sync complete"
}

main "$@"
```

ブラウザで確認して見れていたらOK。

### 記事のインポート

WordPressからエクスポートしたxmlを元に適当にインポートする。HTMLはMarkdownにする。探すといろいろツールもあるし、正規表現と格闘するのもよい。

この記事がすごく参考になった。[WordPress から Hugo に乗り換えました - rakuishi.com](http://rakuishi.com/archives/wordpress-to-hugo/)

### Feed URL

最後にフィードのURLを変更する。WordPressの場合 `/blog/feed/` だったのでこれを `/index.xml` にリダイレクトさせたい。S3のコンソール画面、Bucket Property -> Static Website Hosting -> Edit Redirection Rules にて

```xml
<RoutingRules>
    ...
    <RoutingRule>
        <Condition>
            <KeyPrefixEquals>blog/feed/</KeyPrefixEquals>
        </Condition>
        <Redirect>
            <ReplaceKeyWith>index.xml</ReplaceKeyWith>
            <HttpRedirectCode>301</HttpRedirectCode>
        </Redirect>
    </RoutingRule>
	...
</RoutingRules>
```

`ReplaceKeyWith` と `ReplaceKeyPrefixWith` があって一瞬はまったので注意。ちゃんとドキュメント読もう。。。

[バケットをウェブサイトホスティング用に設定 - Amazon Simple Storage Service](http://docs.aws.amazon.com/ja_jp/AmazonS3/latest/dev/HowDoIWebsiteConfiguration.html)

次はテーマ作成について書く。

