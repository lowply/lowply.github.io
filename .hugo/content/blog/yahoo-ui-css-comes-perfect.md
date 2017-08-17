+++
categories = ["Tech"]
date = "2007-11-15T19:54:43+09:00"
draft = false
slug = "yahoo-ui-css-comes-perfect"
title = "Yahoo! UI CSSが2.3になってパーフェクトになりました"
+++

いつの間にか[Yahoo UI](http://developer.yahoo.com/yui/)が 2.3.0にバージョンアップしていて、CSSシリーズも今までで一番たくさんのアップデートが行われた模様。 その中で特に嬉しかったのがFonts CSSの以下のアップデート。

<blockquote class="blockquote">
  <p class="m-b-0">
	* Updated %-to-px conversion charted for increased accuracy across browsers<br />
	* Move body line-height away from * wildcard selector. Now it is part of the initial BODY rule set.<br />
	* Changed core lineheight from 1.22em to 1.231 (no units)<br />
	* Changed code,pre to not use font-property shorthand syntax<br />
	* Tweaked the sizing fix for monospace font size (pre,code...)<br />
	* Added "kbd,samp,tt" as new selectors for monospaced font stuff<br />
	* Added line-height:99% to keep monospaced font the right height<br />
  </p>
  <footer class="blockquote-footer"><cite title="">[Yahoo! UI Library: Fonts CSS](http://developer.yahoo.com/yui/fonts/)</cite></footer>
</blockquote>

2, 3が特に熱い！わけなんですが、内容としては「bodyのline-heigtにつけていた全称セレクタを取ったよ」、「基本line-heightを1.22emから1.231にして、単位（em）を取ったよ」ということ。以前「[YUI Library CSS toolsがバージョンアップ](/blog/2006/12/yui-library-css-tools-update/)」って記事で書いた不満点2点をやっと解消してくれました。Yahoo UI万歳！

なんか今までのReset、Fonts、Gridに加えて[Base](http://developer.yahoo.com/yui/base/)っていうシリーズも追加されたようです。良く見ていないけど、これも便利そう。一回リセットを適用したあとに、マージンとフォント関係を統一させる感じかな？
