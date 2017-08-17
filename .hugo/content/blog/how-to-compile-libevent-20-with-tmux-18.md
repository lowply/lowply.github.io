+++
categories = ["Server"]
date = "2013-03-30T05:40:00+09:00"
draft = false
slug = "how-to-compile-libevent-20-with-tmux-18"
title = "tmux1.8が出たのでlibevent2.0系を1.4系と共存させつつコンパイルするメモ"
+++

いつの間にか[tmux1.8](http://tmux.sourceforge.net/)が出てた。

で、CentOS使い恒例のlibevent2.0系問題。epelやrpmforgeなどのレポジトリにもまだ2.0のrpmは出てないのでいろいろな手法がポストされてますね。

libevent1.4系は`yum remove`するとmemcachedが消えたりして依存関係がきついので、消さずに2.0をソースから（prefix切って）入れて共存させたいなー、と思ってたらすごくシンプルな方法を見つけたのでメモ。

まずlibeventをprefix付きでコンパイル

```bash
$ ./configure --prefix=/usr/local/libevent2
$ make
$ make install
$ echo "/usr/local/libevent2/lib" >> /etc/ld.so.conf.d/libevent2.conf
$ ldconfig
```

tmuxをconfigureするときにCFLAGSとLDFLAGSを指定

```bash
$ ./configure --prefix=/usr/local/tmux CFLAGS="-I/usr/local/libevent2/include" LDFLAGS="-L/usr/local/libevent2/lib"
$ make
$ make install
```

これだけでOK。

[参考にしたstack exchangeのフォーラム](http://unix.stackexchange.com/questions/17907/why-cant-gcc-find-libevent-when-building-tmux-from-source)には、本来なら --with-libevent=dir みたいなconfigure optionがあるべきだよね、というコメントがあるので今後のtmuxに期待したい。

他には、こんな感じでldconfigとpkg-configを設定してやる方法もある。

[tmux のインストール | ja.528p.com](http://ja.528p.com/linux/centos6/B012-tmux.html)

### 130523 追記

`./configure --help` をよく見たら `LIBEVENT_CFLAGS` と `LIBEVENT_LIBS` という環境変数が指定できると書いてあった。しかも1.7の時にはすでにあった。。。こちらの方が良さげだ、というわけで下記を試してみたらうまくいった。

```bash
$ ./configure --prefix=/usr/local/tmux LIBEVENT_LIBS="-L/usr/local/libevent2/lib -levent" LIBEVENT_CFLAGS="-I/usr/local/libevent2/include"
$ make
$ make install
```

### 160401 追記
[tmux2.1をコンパイルするスクリプトを書いた](/blog/2016/04/tmux-21-install-script/)
