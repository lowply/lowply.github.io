+++
categories = ["Server"]
date = "2012-02-17T23:25:47+09:00"
draft = false
slug = "switching-to-neobundle"
title = "neobundleでvimプラグイン管理"
+++

#### vundleとgithub

[vundleでvimプラグイン管理](http://fixture.jp/blog/2012/02/manage-vim-plugin-with-vundle/)を書いた後、git cloneするときに困ったことがあった。

- vundleをsubmoduleとして導入する
- vundleでインストールしたvimプラグインたちは.vim/bundle内に入る
- その状態でgit commit -> git pushする
- .vim/bundle/以下のファイルがgithub上に上がる
- 他の環境でgit pullすると、vundle以外のプラグインはsubmodule扱いにならない
- .gitmodulesにもvundle以外のプラグインの記述はされない

特にこれでも支障はないんだけど、なんか気持ち悪いので、.vim/bundle以下に.gitignoreを置いて、vundle以外はgithub管理から外した。vimプラグインはvundleに任せる感じ。面倒だけどgit cloneしたら、最初にviを開いて:BundleInstallを実行する必要がある。入れたいプラグインは.vimrcに書いてあるからいきなり実行してもOK。しかし、dotfilesをgithubで管理してて、同時にvimプラグイン管理ツールを使う時って何がベストなんだろう？

#### neobundle

それとは別の経緯で、いろいろ調べてる時に知ったのが[neobundle](https://github.com/Shougo/neobundle.vim)。[neocomplcache](https://github.com/Shougo/neocomplcache)とか[unite.vim](https://github.com/Shougo/unite.vim)の作者の[Shougo](https://github.com/Shougo)氏がvundleをリメイクし、昨年9月にリリースされたもの。一番のポイントは、「unite.vimインターフェイスの実装」とのことで、とても良さそうだったので切り替えてみた。

[ Hack #238: neobundle.vim で plugin をモダンに管理する](http://vim-users.jp/2011/10/hack238/)

依存関係とかもあって、今の.vimrcのNeoBundle部分はこんな感じになった。

```vim
NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc'
NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'tomasr/molokai'
```

unite.vimも勉強したいなー。
