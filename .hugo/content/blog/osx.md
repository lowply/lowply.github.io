+++
categories = ["Daily"]
date = "2012-08-01T19:02:49+09:00"
draft = false
slug = "osx"
title = ".osx"
+++

ここ数日、何台かのMacに山ライオンを入れていて、何度も同じOSの初期設定をするのに疲れていたら、タイムリーにも.osxなるものが流行っていた。

[dotfiles/.osx at master · mathiasbynens/dotfiles · GitHub](https://github.com/mathiasbynens/dotfiles/blob/master/.osx)

要はdefaultsコマンドで大概の設定、例えばDockのサイズとか、Trackpadの設定とかをGUIを通さずにできるので、これをまとめてスクリプトにしたということで。これを叩けば一発で自分好みのFinderになるよ、と。でFinderだけではなくSafariやTerminal, TimeMachineなども設定できる。

それと、GUIではできない設定、例えば ~/Library を表示させたり、Dashboardを無効化したりするのも含めて何入れてもいいので、じっくり自分の.osxを作ると良い。とりあえず今のところ、こんな感じの簡単な設定を入れて、dotfilesの仲間に加えた。

[dotfiles/.osx at master · lowply/dotfiles · GitHub](https://github.com/lowply/dotfiles/blob/master/.osx)

```bash
#
# ~/.osx
#

# disable dashboard
defaults write com.apple.dashboard mcx-disabled -boolean YES

# I like overlay scrollbars
defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling"

# make ~/Library visible
chflags nohidden ~/Library

#
# Killall Apps
#
for app in Finder Dock SystemUIServer
do
  killall "$app" > /dev/null 2>&1
done
```

NEXTSTEP/OSXのこういうところが本当にすごいと思う。

[mathiasbynensさんのdotfiles](https://github.com/mathiasbynens/dotfiles)に[.brew](https://github.com/mathiasbynens/dotfiles/blob/master/.brew)ってのがあって、これもいいなと思った。あと[bootstrap.sh](https://github.com/mathiasbynens/dotfiles/blob/master/bootstrap.sh)が参考になりそう。
