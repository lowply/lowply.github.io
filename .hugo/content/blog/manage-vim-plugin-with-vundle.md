+++
categories = ["Server"]
date = "2012-02-12T06:39:26+09:00"
draft = false
slug = "manage-vim-plugin-with-vundle"
title = "vundleでvimプラグイン管理"
+++

調べれば調べるほど、vundleが良いと聞くので試してみたら本当に良かった。

[gmarik/vundle - GitHub](https://github.com/gmarik/vundle)

120217 追記：[結局neobundleにしました。](http://fixture.jp/blog/2012/02/switching-to-neobundle/)

個人的には

- ~/.vim/bundle 内にまとまってくれる
- 使うときは~/.vimrcに1行書くだけ。GitHubで公開されてるものはパスを書く
- GitHubで公開されているものは自動的にsubmoduleになってくれる
- vi画面内で管理できる。:BundleInstall! で自動アップデートやばい

dotfilesをGitHubで管理しているので、submoduleとしてインストール。

```bash
$ cd ~/dotfiles
$ git submodule add https://github.com/gmarik/vundle.git .vim/bundle/vundle
```
こんな感じでbundleディレクトリ内に置いてvundle自体をvundleで管理できます。

参考サイト：

- [Hack #215: Vundle で plugin をモダンに管理する](http://vim-users.jp/2011/04/hack215/)
- [Vundle入れたら、Vimのプラグイン管理が楽になった](http://shanon-tech.blogspot.com/2011/08/vundlevim.html)
- [Vimプラグインの管理をVundleにしてみた](http://blog.cloudrider.net/2011/05/vimvundle.html)

