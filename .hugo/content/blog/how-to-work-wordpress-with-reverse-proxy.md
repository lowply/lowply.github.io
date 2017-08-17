+++
categories = ["Server"]
date = "2012-02-22T00:04:31+09:00"
draft = false
slug = "how-to-work-wordpress-with-reverse-proxy"
title = "ReverseProxy配下でWordPressを動作させる"
+++

#### 環境

```bash
# uname -orm
2.6.9-67.ELsmp i686 GNU/Linux

# cat /etc/issue
CentOS release 4.9 (Final)
Kernel \r on an \m
NOTICE: Support for CentOS 4 ends on Feb 29th, 2012

# php -v
PHP 5.1.6 (cli) (built: Jul 31 2008 00:08:07)
Copyright (c) 1997-2006 The PHP Group
Zend Engine v2.1.0, Copyright (c) 1998-2006 Zend Technologies
```

WordPress3.3.1を入れたい = php5.3以上が必須。ということで更新がおそーいレポジトリを使ってるredhat系OSにとっては悩ましいところですね。特にCentOS4系。まあ、そもそも稼働中のシステムなのでphpのアップデートは避けたいという環境。

しょうがないので、Apache(2.2.22) + PHP(5.3.10)をソースから入れて、8080とかで上げてリバースプロキシで特定のリクエストを飛ばすことにした。具体的には

```bash
http://www.example.com/blog/ ---> http://www.example.com:8080/
```

ということがしたい。（コンパイル周りも少し手こずったのでそのうち書く）

#### リバースプロキシ

インストールできたら、VHなどなどを設定して8080とかのポートで上げる。WordPressもDocumentRootにDLして解凍しておく。ログにエラーが出ていないかなど、いろいろ確認して問題なければブラウザから接続。

```bash
http://www.example.com:8080/
```

これをhttp://www.example.com/blog/で見せたいので、稼働中の方のApacheにリバースプロキシの設定を入れる。

```bash
ProxyPass /blog/ http://www.example.com:8080/blog/
ProxyPassReverse /blog/ http://www.example.com:8080/blog/
```

ブラウザから確認、表示された。

```bash
http://www.example.com/blog/
```

#### WordPressの設定

DBを作って、WordPressのウィザードからインストールを実行して管理画面に入る。設定→一般→WordPress アドレス (URL)、サイトアドレス(URL)を見ると

```bash
http://www.example.com:8080/blog/
```

こうなってるので

```bash
http://www.example.com/blog/
```

と変える。そしてトップページにアクセス！すると残念なことに

```bash
http://www.example.com/
```

へリダイレクトされる。。。

#### 解決
やはりリバースプロキシ配下で動かすことは無理なのか、と諦めつつ「reverse proxy wordpress」とかでググるとこんな記事を発見。

[リバースプロキシ環境でのwordpressの設置 - position:absolute; | 株式会社スクイズ研究所](http://sqz.jp/blog/mae/2010/06/wordpress.html)

<blockquote class="blockquote">
  <p class="m-b-0">
	ブログのURLなどはHTTP_HOSTを参照して設定するため、アプリケーションサーバーのhost名がそのブログのHOST名になってしまいますし、他にもざっと見ですが8か所ほどHTTP_HOSTを参照している部分があるので、インストール時以外にもなんらかの対応を施す必要があります。
  </p>
  <footer class="blockquote-footer"><cite title=""></cite></footer>
</blockquote>

なるほどー。ということでwp-config.phpに下記を追加したところ、無事に動作した。

```bash
$_SERVER['HTTP_HOST'] = $_SERVER['HTTP_X_FORWARDED_HOST'];
$_SERVER['REMOTE_ADDR'] = $_SERVER['HTTP_X_FORWARDED_FOR'];
```
「クリティカルな影響がないとは言い切れません」という注意付きですが、ひと通り見てとりあえず問題はなさそう。とても助かりました。
