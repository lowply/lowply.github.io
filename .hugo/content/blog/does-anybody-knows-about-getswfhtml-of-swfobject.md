+++
categories = ["Tech"]
date = "2006-11-27T00:42:06+09:00"
draft = false
slug = "does-anybody-knows-about-getswfhtml-of-swfobject"
title = "SWFObjectのgetSWFHTML() というメソッドが全く知られてない件"
+++

全ウェブデザイナー・フラッシャー必携といっても過言ではないSWFコンテンツ埋め込みライブラリ「[SWFObject](http://blog.deconcept.com/swfobject/)」ですが、更に便利に記述する方法が紹介されているエントリーを発見したのでまとめ。

まず、SWFObjectの利点：

1. IEの[Active Content Update 問題](http://blog.deconcept.com/2005/12/15/internet-explorer-eolas-changes-and-the-flash-plugin/)に対応済み
1. XHTML Validな記述ができる
1. Flashプラグインのバージョン検出が可能
1. Macromedia Flashがデフォルトで吐き出すタグよりシンプル

それで、欠点は一つもないです。Adobeのサイトでも使用されている様子。というかそれならAdobeは[AC_RunActiveContent](http://www.adobe.com/jp/devnet/activecontent/articles/devletter.html)とかやってる場合じゃないんですけどね。。。

そして、発見したのは下記のエントリー。

[BicRe: SWFObjectの便利なメソッド](http://www.echo-graphics.net/blog/archives/2006/11/swfobject.html)

本家SWFObjectドキュメントを日本語版に翻訳した超重要エントリー &quot; [SWFObjectのドキュメントを日本語に翻訳してみたよ](http://www.trick7.com/blog/2006/06/15-135235.php)&quot; にも見当たらなかったんですが、SWFObjectにはgetSWFHTML()ってメソッドがあるらしく、以下

```html
<script type="text/javascript">
var so = new SWFObject("hoge.swf", "text for movie", "320", "260", "8", "#FFFFFF");
document.write(so.getSWFHTML());
</script>
```

と記述すれば一行で書けてしまいます、ということ。代替テキストを表示できなくなるというリスクはあるものの、divを少しでも減らしたい人、早く書きたい人、オススメです。これ、Googleで検索しても7件ぐらいしか出てこないんですが、どうしてなんでしょうかね？（海外だともう少し出てきます）
また、setFlash() なる関数を作ってaddVariable()メソッドと組み合わせワザで、もっと便利なものも作ったりされてて感動。
