+++
categories = ["Server"]
date = "2012-02-07T04:13:14+09:00"
draft = false
slug = "how-to-manage-dotfiles-on-github"
title = "DotfilesをGitHubで管理する"
+++

最後の更新が1年以上前とは。。。気を取り直して、WordPressのバージョンも最新版に上げ、[Nilmini](http://www.elmastudio.de/wordpress-themes/nilmini/)という良いThemeも見つけ、技術メインで再びいろいろ発信しようということで更新してみます。

最初はライトなものから。メインのテキストエディタを[Jedit](http://www.artman21.com/jp/jedit_x/)から[MacVim](http://code.google.com/p/macvim-kaoriya/)へ移行しようか検討していて、その過程で.vimrcを複数環境で同期するためにGitHub（[github.com/lowply](https://github.com/lowply/)）を使い始めました。その時のメモ。

#####  vim本体
~~まずvim用の.vimrc、MacVim用の.gvimrc。それから、プラグインを[pathogen](https://github.com/tpope/vim-pathogen)で管理することにしたので.vimディレクトリを。プラグイン管理に[vundle](https://github.com/gmarik/vundle)も使ってみたけど複雑になりすぎるので好きじゃないです。使いこなせてないだけなのかもしれないけど。~~

2012/2/12 追記：vundleをしっかり調べてみたらかなり良かったので[使い始めました](/blog/2012/02/manage-vim-plugin-with-vundle/)。すごいですこれ。

pathogenでの管理をやめるので、autoload、bundle/ をrmではなくgit rmで削除しておきました。

##### カラースキーマ
Color Schemeには史上最も洗練された（と思っている）[SOLARIZED](http://ethanschoonover.com/solarized)を一度検討したものの、紺背景に馴染めず、vim.orgで高ランキングを叩き出している[molokai.vim](https://github.com/tomasr/molokai)を選択。派手な感じで良いです。もともとTextMate用の[Monokai](http://www.monokai.nl/blog/2006/07/15/textmate-color-theme/)っていうのがベースらしいです。

##### ターミナル
インフラエンジニアという仕事柄、[tmux](http://tmux.sourceforge.net/)がなくては仕事にならないので.tmux.confも。LionからTerminalが256color対応したので、ステータスバーをカラフルにしてます。[screen](http://www.gnu.org/software/screen/)は使ってません。

ちなみにコンソール上の色出力は[256colors2.pl](http://frexx.de/xterm-256-notes/)が有名ですけど、tmuxのcolour numberをつけたバージョンを作成している方を発見。かなりテンション上がりました。[256 colors with tmux's colour numbers. - What's Goin' On Out There?](http://ytaniike.posterous.com/256-colors-with-tmuxs-colour-numbers) 実際に、これで色合わせしました。

それから、Terminal.appのオリジナルテーマをFixture.terminalとして書き出して追加。これは単なるxmlで、Mac上でダブルクリックすればインポートできる形式になってます。便利。

##### githubに置く
全体的な管理方法としては、~/dotfilesというディレクトリを作り、その中をgitリポジトリとして、~/.vimrcなどはシンボリックリンクにする方法にしました。いろんな人のdotfileを見てると、どうもこれが一般的らしい。

```css
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

あと、git pullした後に叩くだけでsymlinkを分散配置してくれるシェルスクリプトを書いてる人もいたので、これもいろいろ参考にしつつこんな感じで書いて追加。

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
最後にmarkdown形式でREADME書いて完了。という感じです。

[lowply/dotfiles - GitHub](https://github.com/lowply/dotfiles)

- 実はGitHubは初ではなく、昔作った[Google-English](https://github.com/lowply/Google-English)というbookmarkletが置いてあった。英単語を検索するとき地味に便利。
- gitについて何も書かなかったけど、ググればこういう良い記事がたくさんある。[git - 簡単ガイド](http://rogerdudler.github.com/git-guide/index.ja.html)
- 新しいWordPressのフルスクリーンエディットモード超いい。
