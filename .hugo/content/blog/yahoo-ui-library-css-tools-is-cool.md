+++
categories = ["Tech"]
date = "2006-06-06T22:20:47+09:00"
draft = false
slug = "yahoo-ui-library-css-tools-is-cool"
title = "「Yahoo! UI Library CSS Tools」が良い"
+++

Yahoo!（US）が提供しているJavaScriptのライブラリ「[Yahoo! User Interface Library](http://com1.devnet.scd.yahoo.com/yui/index.html)」。Flashチックなアニメーションやフォルダ等の階層ツリー表示を簡単に作成できるってことで使ったことは無いけどすごいなあと思っていたところ、5/8にバージョン「0.10.0」となってCSSのライブラリも登場。こちらは簡単で、項目も3つだけ。

1. [CSS Page Grids](http://com1.devnet.scd.yahoo.com/yui/grids/)：一番作業効率に寄与してくれるであろう、段組レイアウト用CSS。大急ぎで段組レイアウトやろうとするときはかなり助かるはず。grids.cssを外部CSSとして読み込んで(X)HTMLソースもコピペですばやく段組が作れます。ただし互換モードだと崩れるとのこと。doctype宣言に注意。それと、
<blockquote class="blockquote">
  <p class="m-b-0">
	Grids rely on the width of an &quot;em&quot; provided by [Fonts CSS](http://com1.devnet.scd.yahoo.com/yui/fonts/index.html); that file must be included. For the sake of this document, the convenience declarations within [Reset CSS](http://com1.devnet.scd.yahoo.com/yui/reset/index.html) are also assumed.
  </p>
  <footer class="blockquote-footer"><cite title="3ping.org">3ping.org</cite></footer>
</blockquote>
上記のように残り2つのCSSも同時に読み込んで使うことが推奨されています。

2. [CSS Fonts](http://com1.devnet.scd.yahoo.com/yui/fonts/)：これはCSSファイル自体も便利ですが、一番素敵なのは、「フォントを&quot;X&quot;pxの大きさにしたかったら&quot;Y&quot;%を指定しなさい」という絶対指定⇔相対指定変換表。ちなみに同じ相対サイズでもem指定より%指定の方が正確性が高いとのこと。

3. [CSS Reset](http://com1.devnet.scd.yahoo.com/yui/reset/)：全要素のマージン・パディングを0にしてフォントサイズを100%にしてリスト要素を…　というやつ。これはブラウザ個別にもっているdefault CSSの微妙な差を一度リセットする常套手段ですが、人（サイト）それぞれなので参考という感じで。

Yahoo!謹製PDF版カンニングペーパーもあるようです。
