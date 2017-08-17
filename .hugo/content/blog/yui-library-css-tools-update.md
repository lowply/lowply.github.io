+++
categories = ["Tech"]
date = "2006-12-08T03:50:47+09:00"
draft = false
slug = "yui-library-css-tools-update"
title = "YUI Library CSS toolsがバージョンアップ"
+++

Yahoo UI Libraryが 0.12.0にバージョンアップしてCSS関連も若干修正された様子。

##### CSS Reset
- hn要素にfont-weight:normal;が追加
- abbr,acronym要素に border:0;が追加

##### CSS Fonts
- font:x-  と smallの間の[不要な改行](http://blog.33rpm.jp/fonts-css.html)の修正

##### CSS Grid
- 大幅に変更

##### その他
- CSS reset-fonts-grids というお手軽3パックが追加。

という感じで、まあ良くなってます。ただ個人的には以前から、Fontsの一番最後、

```css
body * {line-height:1.22em;}
```

という指定が理解できません。line-heightは単位なし指定が基本じゃなかったっけ。。。しかも全称セレクタを使われると継承がうまく効かなくて厄介なんですが。。。　というわけでここだけ

```css
body {line-height:1.5;} 
```

とかにして使っています。詳細なドキュメントがほしいところ。

[Yahoo! User Interface Library](http://developer.yahoo.com/yui/)
