+++
categories = ["Server"]
date = "2013-01-25T02:16:37+09:00"
draft = false
slug = "how-to-set-locale-to-english-with-terminal-app"
title = "Terminal.appでSSHするとlocaleを英語にできない"
+++

2013/02/01 追記: 結局 ssh_config を修正。

コンソールメッセージが日本語なのは嫌じゃないですか。でlocaleの設定変えようと思って

```bash
$ cat /etc/sysconfig/i18n
LANG="en_US.UTF-8"
```

こんな感じにしても、次回sshすると

```bash
$ echo $LANG
ja_JP.UTF-8
$ locale | grep LC_CTYPE
LC_CTYPE="ja_JP.UTF-8"
```

とか言われてイラッとする場合。

調べてみると[[計算機] Lion からの ssh ログイン先で locale がどうのこうの、といわれる。](http://d.hatena.ne.jp/boulevard/20120303)

<blockquote class="blockquote">
  <p class="m-b-0">
	どうやら Lion から ssh をするときに LC_* 環境変数を送っているのが問題らしい。
  </p>
  <footer class="blockquote-footer"><cite title=""></cite></footer>
</blockquote>

なるほど手元の10.8.2でも確かに /etc/ssh_config に

```bash
SendEnv LANG LC_*
```

という記述があった。ただ、これ編集したくないなあ。。。と思ってたら、Terminal.appにそれを制御する設定を見つけた。

![](/images/2013/01/ss_terminal_locale.png)

<del></del>
~~この「起動時にロケール環境変数を設定」をオフにして、Terminal.appを再起動すればOK。~~

**2013/02/01 追記**：これを行うことで、Terminalがローカル環境の日本語ファイル名を正しく表示してくれないことがわかったので、結局 /etc/ssh_config を修正した。~/.ssh/configでSendEnvをOverrideできないか調べてみたけど、UnSendEnvとか[各所から提案されつつも実現していない](http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=573316)らしい。

といってもOS Xの言語を英語にしている人には関係ないです。

ココにそれっぽいことは書いてあったのは見つけた。→ [Beginning OS X Lion/インフラ整備編](http://osx.miko.org/index.php/Beginning_OS_X_Lion/%E3%82%A4%E3%83%B3%E3%83%95%E3%83%A9%E6%95%B4%E5%82%99%E7%B7%A8#environment.plist)
