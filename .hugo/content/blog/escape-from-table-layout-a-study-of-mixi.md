+++
categories = ["Tech"]
date = "2006-05-26T04:52:29+09:00"
draft = false
slug = "escape-from-table-layout-a-study-of-mixi"
title = "mixiを脱テーブル化するスタディ"
+++

ためになるエントリーが多い[3ping.org](http://3ping.org/)から[mixiをXHTML+CSSで組みなおす](http://3ping.org/2006/05/16/0529)というエントリー。

<blockquote class="blockquote">
  <p class="m-b-0">
	- テーブルで組まれたmixiのhtmlファイル容量が48KB (自分のページ調べ)<br />
	- XHTML+CSSで構成されたhtmlファイル容量が16KB<br />
	<br />
	この軽量化率が他のページにも当てはまるとすれば、mixiをXHTML+CSSで書き直すだけでhtmlファイルのトラフィックを3分の1にする事が出来る。mixiの１日のPVは1000万と聞いたけど、削減される転送量は月で何テラだろう。サーバー管理費にするといくらだろう。
  </p>
  <footer class="blockquote-footer"><cite title="3ping.org">3ping.org</cite></footer>
</blockquote>

3分の1というのは素晴らしい。CSSのソースも非常に洗練されていて、「一通りプロパティを覚えてCSSを使えるようになった」という人は絶対目を通したほうが良いと思います。一意のdiv要素内のタグに対して、極力クラス名を割り当てないでスタイルを適用するという、「カスケーディング」の理解が深まるはず。これがCSSの本当の魅力なんだと思います。
XHTMLとCSSの詳細な構造をグラフィカルにたどれるFirefoxの拡張[FireBug](https://addons.mozilla.org/firefox/1843/)を使うと、より勉強になります。最新バージョンにはJSのデバッガも付いて、かなり強力なコーディングツールになってます。

<blockquote class="blockquote">
  <p class="m-b-0">
	- JavaScript debugger for stepping through code one line at a time<br />
	- Status bar icon shows you when there is an error in a web page<br />
	- A console that shows errors from JavaScript and CSS<br />
	- Log messages from JavaScript in your web page to the console (bye bye &quot;alert debugging&quot;)<br />
	- An JavaScript command line (no more &quot;javascript:&quot; in the URL bar)<br />
	- Spy on XMLHttpRequest traffic<br />
	- Inspect HTML source, computed style, events, layout and the DOM
  </p>
  <footer class="blockquote-footer"><cite title="">from Mozilla Add-ons</cite></footer>
</blockquote>


##### 2006/05/28追記
[東京webデザイナー日記：日経平均銘柄225社サイトの脱テーブル率調査](http://tokyo.fun.cx/web/2006/05/post_18.html)
興味深い資料です。
