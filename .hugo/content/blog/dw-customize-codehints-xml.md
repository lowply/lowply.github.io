+++
categories = ["Tech"]
date = "2006-05-15T22:54:35+09:00"
draft = false
slug = "dw-customize-codehints-xml"
title = "DWカスタマイズ：CodeHints.xml"
+++

Dreamweaver8でCSSを書いていると、誰でも一度は「width」を入力しようとして、コードヒントのせいで「widows」プロパティというわけわかんないやつを出してしまうものです。この「コードヒント」の設定ファイルが、CodeHint.xmlで、Windowsなら `C:\Program Files\Macromedia\Dreamweaver 8\configuration\CodeHints` 内にあります。

で、これをカスタマイズしちゃって、あんまり使わないプロパティ（アジマスとか）をごっそりコメントアウト＆マージンとかの左右上下を時計回りに並べ替えたりしてしまった方を発見。さっそく使ってみたところものすごく便利。DWのコードヒントはいろいろなソフトの中でも特に秀逸なのに、さらにパワーアップです。

5/10には[DW8.0.2Update](http://www.adobe.com/jp/support/dreamweaver/downloads_updaters.html)も出ていて、こちらはIEのActiveX - Flash問題に対応していないHTMLを自動的に修正（JavaScriptを加える）してくれたりします。

- [カラクリエイト:widowsプロパティの誤入力を防ぐCodeHints.xml](http://www.extype.com/karakuri/archives/2006/03/dreamweaver.html)  
- [Dreamweaver 8.0.2 Update](http://www.adobe.com/jp/support/dreamweaver/downloads_updaters.html#dw8)
