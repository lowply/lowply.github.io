+++
categories = ["Tech"]
date = "2006-11-29T04:06:45+09:00"
draft = false
slug = "css-to-enable-bg-transparent-for-almost-browsers"
title = "ほとんどのブラウザで背景の半透明化を可能にするCSS指定"
+++



hoge 

**2012/2/22 追記：未だに結構アクセスあるのですが、2006年11月の記事になります。2012年現在はもっと良いソリューションがあるはずなので、それを踏まえて参考にして頂ければと思います。**リンクとか切れてるし。

前回のおさらい：

```css
#TB_overlay {
position: absolute;
z-index:100;
top: 0px;
left: 0px;
background-color:#000;
**filter:alpha(opacity=60);
-moz-opacity: 0.6;
opacity: 0.6;**
}
```

thickbox.css ですが、

1. IE独自拡張CSSの**filter:alpha**（正式にはActiveXらしい via [filter:alphaで大ハマり](http://lunatear.net/archives/000435.html)）を最初に指定
1. mozilla系独自プロパティ**-moz-opacity**で透明度を指定
1. [CSS3ドラフト](http://www.w3.org/TR/css3-roadmap/)段階のもまで先行実装していて最も正確にCSSをレンダリングするOperaとSafariに向けて**opacity**プロパティを指定

これで世の中の99%ぐらいのブラウザ上で、半透明効果をかけられるんじゃないでしょうか。肝心なのは指定の順番かな？Validではない順に記述していくことで、長期的に使えるように。

と思ったら、結構知られているテクニックなんですね。。

[IE・Firefox・Opera・Netscape・Safariで表示可能な半透明CSS/Opacityテクニック - WEBデザイン　BLOG](http://weblibrary.s224.xrea.com/weblog/css/cat15/iefirefoxoperanetscapesafarics.html)

ネタ元では3ページに渡って詳細に実験しています。

[Exploring Opacity - Mandarin Design](http://www.mandarindesign.com/opacity.html)

こちらを読むと、Firefoxではopacityプロパティを認識するようになったらしく、-moz-opacityは後方互換性のために残してあるだけのようです。

おまけ

[CSS3はこうなる - GIGAZINE](http://gigazine.net/index.php?/news/comments/20060522_css3/)
