+++
categories = ["Server"]
date = "2013-02-11T02:06:31+09:00"
draft = false
slug = "solarized-termtrans-option"
title = "tmux+vim+solarizedの人はsolarized_termtransオプションを使おう"
+++

[vim + molokaiを使っていて背景がおかしいというエントリー](http://fixture.jp/blog/2012/08/patch-to-disable-molokai-bgcolor/)を書いた後、これが再現するのはtmuxを使っている時だけということがわかった。具体的には

- Terminal.app on Mountain Lion
- declare -x TERM="xterm-256color"
- tmux 1.7
- vim + molokai

という環境の時。

で、ある日何気なく[solarizedのreadme](https://github.com/altercation/vim-colors-solarized)を読んでいたらこんな記述が。

<blockquote class="blockquote">
  <p class="m-b-0">
	g:solarized_termtrans<br>
	If you use a terminal emulator with a transparent background and Solarized isn't displaying the background color transparently, set this to 1 and Solarized will use the default (transparent) background of the terminal emulator. urxvt required this in my testing; iTerm2 did not.<br>
	Note that on Mac OS X Terminal.app, solarized_termtrans is set to 1 by default as this is almost always the best option. The only exception to this is if the working terminfo file supports 256 colors (xterm-256color).<br>
  </p>
  <footer class="blockquote-footer"><cite title=""></cite></footer>
</blockquote>
要約すると、

君がターミナルを透過背景に設定していて、Solarizedの時だけ透過にならないなら、これを1にするべし。そうすればSolarizedはしっかり透過になるよ。けどMac OS XのTerminal.appの場合はこれはデフォルトで1になってるよ。唯一、terminfoがxterm-256colorをサポートするときは例外だよ。
つまりどういうことだ？と思いつつ、とりあえずカラースキームをsolarizedに変えてまずはトライ。

![](/images/2013/02/solarized_termtrans_off.png)

やっぱり再現した。で、.vimrcにこれを追加。

```bash
let g:solarized_termtrans=1
```

![](/images/2013/02/solarized_termtrans_on.png)

うまくいった！こういう気づかいステキ。というわけでmolokaiから[solarized](http://ethanschoonover.com/solarized)に乗り換えました。solarizedのファイルサイズがmolokaiの約6倍ある理由がわかった気がする。

[dotfiles](https://github.com/lowply/dotfiles)も更新。
