---
title: DotfilesをGitHubで管理する
aliases:
 - /blog/2012/02/how-to-manage-dotfiles-on-github/
date: 2012-02-07T04:13:14+09:00
draft: false
---

最後の更新が 1 年以上前とは。。。気を取り直して、WordPress のバージョンも最新版に上げ、[Nilmini](http://www.elmastudio.de/wordpress-themes/nilmini/)という良い Theme も見つけ、技術メインで再びいろいろ発信しようということで更新してみます。

最初はライトなものから。メインのテキストエディタを[Jedit](http://www.artman21.com/jp/jedit_x/)から[MacVim](http://code.google.com/p/macvim-kaoriya/)へ移行しようか検討していて、その過程で.vimrc を複数環境で同期するために GitHub（[github.com/lowply](https://github.com/lowply/)）を使い始めました。その時のメモ。

## vim 本体

~~まず vim 用の.vimrc、MacVim 用の.gvimrc。それから、プラグインを[pathogen](https://github.com/tpope/vim-pathogen)で管理することにしたので.vim ディレクトリを。プラグイン管理に[vundle](https://github.com/gmarik/vundle)も使ってみたけど複雑になりすぎるので好きじゃないです。使いこなせてないだけなのかもしれないけど。~~

2012/2/12 追記：vundle をしっかり調べてみたらかなり良かったので[使い始めました](/blog/2012/02/manage-vim-plugin-with-vundle/)。すごいですこれ。

pathogen での管理をやめるので、autoload、bundle/ を rm ではなく git rm で削除しておきました。

## カラースキーマ

Color Scheme には史上最も洗練された（と思っている）[SOLARIZED](http://ethanschoonover.com/solarized)を一度検討したものの、紺背景に馴染めず、vim.org で高ランキングを叩き出している[molokai.vim](https://github.com/tomasr/molokai)を選択。派手な感じで良いです。もともと TextMate 用の[Monokai](http://www.monokai.nl/blog/2006/07/15/textmate-color-theme/)っていうのがベースらしいです。

## ターミナル

インフラエンジニアという仕事柄、[tmux](http://tmux.sourceforge.net/)がなくては仕事にならないので.tmux.conf も。Lion から Terminal が 256color 対応したので、ステータスバーをカラフルにしてます。[screen](http://www.gnu.org/software/screen/)は使ってません。

ちなみにコンソール上の色出力は[256colors2.pl](http://frexx.de/xterm-256-notes/)が有名ですけど、tmux の colour number をつけたバージョンを作成している方を発見。かなりテンション上がりました。[256 colors with tmux's colour numbers. - What's Goin' On Out There?](http://ytaniike.posterous.com/256-colors-with-tmuxs-colour-numbers)  実際に、これで色合わせしました。

それから、Terminal.app のオリジナルテーマを Fixture.terminal として書き出して追加。これは単なる xml で、Mac 上でダブルクリックすればインポートできる形式になってます。便利。

## github に置く

全体的な管理方法としては、~/dotfiles というディレクトリを作り、その中を git リポジトリとして、~/.vimrc などはシンボリックリンクにする方法にしました。いろんな人の dotfile を見てると、どうもこれが一般的らしい。

```bash
~/
├── dotfiles
│    ├── Fixture.terminal
│    ├── .git
│    ├── .gitignore
│    ├── .gvimrc
│    ├── README.md
│    ├── symlink.sh
│    ├── .tmux.conf
│    ├── .vim
│    └── .vimrc
├── .gvimrc -&gt; /root/dotfiles/.gvimrc
├── .tmux.conf -&gt; /root/dotfiles/.tmux.conf
├── .vim -&gt; /root/dotfiles/.vim
└── .vimrc -&gt; /root/dotfiles/.vimrc
```

あとは普通に

```bash
$ git add .
$ git commit -m "first commit"
$ git push origin master
```

あと、git pull した後に叩くだけで symlink を分散配置してくれるシェルスクリプトを書いてる人もいたので、これもいろいろ参考にしつつこんな感じで書いて追加。

```bash
#!/bin/sh
cd $(dirname $0)
for dotfile in .?*
do
    if [ $dotfile != '..' ] && [ $dotfile != '.git' ]
    then
        ln -Fis "$PWD/$dotfile" $HOME
    fi
done
```

最後に markdown 形式で README 書いて完了。という感じです。

[lowply/dotfiles - GitHub](https://github.com/lowply/dotfiles)

- 実は GitHub は初ではなく、昔作った[Google-English](https://github.com/lowply/Google-English)という bookmarklet が置いてあった。英単語を検索するとき地味に便利。
- git について何も書かなかったけど、ググればこういう良い記事がたくさんある。[git - 簡単ガイド](http://rogerdudler.github.com/git-guide/index.ja.html)
- 新しい WordPress のフルスクリーンエディットモード超いい。
