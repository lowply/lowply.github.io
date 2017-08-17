+++
categories = ["Server"]
date = "2016-04-01T15:09:00+09:00"
description = ""
draft = false
slug = "tmux-21-install-script"
title = "tmux2.1をコンパイルするスクリプトを書いた"

+++

[tmux1.8が出たのでlibevent2.0系を1.4系と共存させつつコンパイルするメモ](/blog/2013/03/how-to-compile-libevent-20-with-tmux-18/) で書いたとおりいつもめんどくさいので、インストールスクリプトを書きました。

{{< gist lowply 3ebdf81310a99e45f90bef1d3e07d82d >}}

`/tmp` でコンパイルするので最初の yum で依存関係をインストールするときだけ sudo が必要です。バイナリは `/usr/local/tmux` に入るので適当に `cd /usr/local/bin; ln -s /usr/local/tmux/bin/tmux .` とかしてください。

Hugo は gist を貼っつける shortcode があって良い。あと Twitter の shortcode もある。

{{< tweet 715783009891401728 >}}

