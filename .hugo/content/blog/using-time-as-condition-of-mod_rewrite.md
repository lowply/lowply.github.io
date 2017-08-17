+++
categories = ["Server"]
date = "2012-02-29T16:54:59+09:00"
draft = false
slug = "using-time-as-condition-of-mod_rewrite"
title = "mod_rewriteで時間・期間指定のリダイレクト"
+++

これは知らなかった。

<blockquote class="blockquote">
  <p class="m-b-0">
	TIME_YEAR<br>
	TIME_MON<br>
	TIME_DAY<br>
	TIME_HOUR<br>
	TIME_MIN<br>
	TIME_SEC<br>
	TIME_WDAY<br>
	TIME<br>
  </p>
  <footer class="blockquote-footer"><cite title=""><a href="http://httpd.apache.org/docs/2.2/mod/mod_rewrite.html">mod_rewrite - Apache HTTP Server</a></cite></footer>
</blockquote>

RewriteCondにTIMEで始まる時間・期間指定変数があって、秒単位の細かい指定でURLのリライトができる。例えば午前3時から4時半の間は毎日バッチを走らせるのでメンテ画面に飛ばしたい、とかいう場合は

```apache
ErrorDocument 503 /maintenance.html

RewriteEngine on
RewriteCond %{REQUEST_URI} !/maintenance.html
RewriteCond %{TIME_HOUR}%{TIME_MIN} > 0300
RewriteCond %{TIME_HOUR}%{TIME_MIN} < 0430
RewriteRule ^.*$ - [R=503,L]
```
とか書ける。[1]

今までcronで行なっていたサイトのオープン、クローズ、メンテなどなど、全部これでいいじゃん！なんという[スイスアーミーナイフ](http://net-newbie.com/trans/mod_rewrite.html)。

ただ、詳細までまとめたドキュメントが見当たらず、いろいろ見た感じだと

- TIMEの後がそれぞれ年月日時分秒曜日のものは、その数字を返す（月は0-11になるので注意）
- TIME単体だと曜日以外をまとめた数字が返る
- 比較演算子 <, >, = を使って条件を作れる

こういうことらしい。

[1] メンテ画面を503で出すのも勉強になった。via [mod_rewrite (.htaccess) で簡単メンテナンスモード @ php-tips](http://php-tips.com/server/2011/05/mod_rewrite-htaccess-maintenance)

see also

- [Mod_Rewrite Variables Cheatsheet / TIME](http://www.askapache.com/htaccess/mod_rewrite-variables-cheatsheet.html#TIME)
- [Advanced Techniques with mod_rewrite - Apache HTTP Server / Time-Dependent Rewriting](http://httpd.apache.org/docs/2.3/rewrite/advanced.html#time-dependent)
- [mod_rewriteで期間指定のリダイレクト » gmt-24.net](http://gmt-24.net/archives/348)
