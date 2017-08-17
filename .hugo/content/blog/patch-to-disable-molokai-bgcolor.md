+++
categories = ["Server"]
date = "2012-08-15T03:18:00+09:00"
draft = false
slug = "patch-to-disable-molokai-bgcolor"
title = "molokai.vimの背景色を消すpatchを書いた"
+++

**2013/02/11 追記**：[tmux+vim+solarizedの人はsolarized_termtransオプションを使おう](http://fixture.jp/blog/2013/02/solarized-termtrans-optio/)に続く。

vimのカラースキームに[molokai](https://github.com/tomasr/molokai)を使ってる人、少なくないんじゃないかと思う。[vim.orgのColor Scheme部門でRating 1位](http://www.vim.org/scripts/script_search_results.php?keywords=&amp;script_type=color+scheme&amp;order_by=rating&amp;direction=descending&amp;search=search)だし。僕もずっとこれ使ってますが、一つだけ、背景色の表示が気に入らない。これ、バグではないっぽいけど表示的に絶対おかしい気がする。

[<img class="alignnone size-full wp-image-1423" title="molokai" alt="" src="/images/2012/08/molokai.png" width="610" height="300" />](http://fixture.jp/blog/wp-content/uploads/2012/08/molokai.png)

.vimrcをvimで開いた例。左がmolokaiの初期状態で、テキストの背景だけ薄いグレーになっていて、それ以外は背景色がない。右が修正後。ハイフンが続いてるコメント部分とかわかりやすいと思う。それで、これがタブ文字やスペースにもかかってくるから、ネストが深いコードとかはいい感じに違和感たっぷりになってくれる。

で、これを無効にするために、vimのカラースキーム定義とかいう完全に未知の世界を必死にさまよって、やっと該当の行を発見したのでpatch化した。たった1行だけど。。。

「molokaiのこれは仕様です」とか、「このパッチはカラースキーム的におかしい」とかあったら教えて下さい。

**120817 UPDATE** :
パッチを当てるときはこんな感じで。（vim プラグインの位置は適宜変更）

```bash
$ cd /tmp
$ git clone git://gist.github.com/3351367.git
$ patch -u ~/dotfiles/.vim/bundle/molokai/colors/molokai.vim < /tmp/3351367/molokai.patch
```
