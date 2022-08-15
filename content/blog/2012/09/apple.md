---
title: "要約: Apple iPhone5のページのJPEGとJSとcanvasタグによるビデオの実装がやばいという話"
aliases:
 - /blog/2012/09/how-apple-compresses-video-in-iphone5-website/
date: 2012-09-19T21:29:43+09:00
draft: false
---

2012 年 9 月 26 日 追記しました。

要約エントリー。

元記事 : [iPhone 5 website teardown: How Apple compresses video using JPEG, JSON, and &lt;canvas&gt;](https://docs.google.com/document/pub?id=1GWTMLjqQsQS45FWwqNG9ztQTdGF48hQYpjQHR_d1WsI)

[アップルのサイトの iPhone5 のページにある「スライドしてアンロック」のアニメーション](http://www.apple.com/iphone/design/#animation-unlock)が、信じられない実装になっている、という話。簡単に要約してみた。（ミスなどの指摘は [@lowply](https://twitter.com/lowply/) までお願いします）

もともと h.264 と WebM の動画フォーマット戦争でブラウザ互換性の問題がまだ残っている上、iPhone などは「再生ボタン」を押さないと再生できなかったりするので、こうした短いアニメーションに video タグを使うことは最適解ではなかったらしい。

そこで発想の転換をして、[Retina MBP のページ](http://www.apple.com/macbook-pro/features/#seq)では、蓋が開くたった 2 秒間のアニメーションに 60 枚の JPG をぶん回すという荒業を使っていた。これは実に 5MB もの画像を使っていることになる（そのかわり Retina ディスプレイに対応した画像サイズにはなっていない）↓ これ。

{{< img name="open_060.jpg" >}}

で、今回の iPhone5 のアンロックアニメーションは更に手法を更に進化させて、2MB に収まる 2 枚の JPG 画像を JS で高速に差し替えて canvas タグ内に描画している。各フレームごとの JPG の位置は JSON で記述されていて、全体的な制御は ac_flow.js が行なっていると。圧縮された JPG 画像はこんな感じ。注：バグってるわけではありません。元画像は[こちら](http://www.apple.com/iphone/design/images/unlock/unlock_001.jpg)

{{< img name="unlock_001.jpg" >}}

ここまで来ると誰にも真似できないというか、驚きを通り越して恐怖。昔から思ってたけど、Apple のウェブサイトって本当に一つの目指すべき姿だと思う。

元記事にはより技術的な詳細や、EarPods の QTVR 的な動きの実装についても言及されているので、すべての UI/UX デザインに関わる人にとって一読の価値ありかと。

## 2012 年 9 月 26 日 追記

昨夜、この記事が FICC の[@akirafukuoka](https://twitter.com/akirafukuoka)さんに紹介され、さらに尊敬する[@fladdict](https://twitter.com/fladdict)さんに RT された形で一気に拡散し、[ホットエントリー入り](http://b.hatena.ne.jp/hotentry)しました。まさか自分の VPS が最大瞬間 7.5Mbps のトラフィックを出すとは思ってもいなかったです。

{{< img name="if_eth0-day.png" >}}

感動して勢いで書いた部分もあり、読み返して表現が間違ってるなーと思う部分もあったので訂正しつつ追記。

## 各方面のコメント

- [はてブ](http://b.hatena.ne.jp/entry/fixture.jp/blog/2012/09/how-apple-compresses-video-in-iphone5-website/)
- [Twitter](https://twitter.com/search?q=fixture.jp%20lang%3Aja&src=typed_query#!/search/?q=fixture.jp)

一番見かけたのが「こんなん目指すべき姿じゃない」というご意見。

> アホ言え! 一番真似しちゃアカンタイプのバッドノウハウの塊やないかい!!
> こんなん目指してどうするんだよ。こういう事やらなくて良い世界目指す方でおねがいします。
> まず Safari でインライン再生できるようにするのが先じゃないのか

バッドかどうかは後述するとして、このノウハウそのものが「目指すべき姿」だとは思っていないのですが、言葉足らずでした。スミマセン。

ここで書きたかったことは、この 10 年 Apple のサイトを見てきて一度も「大規模リニューアル」とかをせず、新製品が登場するごとに部分的に変化し、HTML5, JS, CSS を使って新しい技術を積極的に取り入れながら、まるで生き物のように成長していく全体的なサイト運営手法が、大規模オフィシャルサイトのひとつの「目指すべき姿」だと感じたということです。これは昔から思っていたことです。

[Apple サイトに見るグローバルメニューの画像置換手法 \| fixture.jp](/blog/2007/08/how-apple-uses-css-ir-on-their-globalmenu/)

ウェブ上での表現、特にモーションがあるものに関しては Flash から JS への過渡期であったり、まだまだ模索段階だと思います。だから、一つの技法を編み出して、それを大規模サイトに躊躇なく投入していく実験的な姿勢が、次の時代の流れを作っていくのではないかと思っています。そういう意味で、今はバッドノウハウでも、やがて最適化されて未来の標準技術になっていく可能性は大いにあると思います。AJAX のように。

> これがバッドノウハウを使わないと実装できないのなら、間違ってるのは仕様の方です。実装は結果のためにあるのであって、逆ではありません。

MotionJPEG が普及しなかったように、実装と仕様には常にタイミングの問題が絡みついてきますね。

あと次に見かけて驚いたのが、実は昔からある技法ということ。

> ぜんぜん違うけど何となく MSX 時代の裏ページに置く展開前の超圧縮画像を思い出した
> 変態というか、8 ビット時代のプログラミングって感じだな。
> 昔ながらのビデオプログラミングのやり方を HTML5 流で。
> 古典的な技術の昇華がすごい。

リソースが少なかった頃のレトロゲーム時代によくこういう実装をしていた、ということ。なるほど先人の知恵が細い 3G 回線とモバイルデバイスの環境でまた生きてくるわけですねー。ダブルバッファリングという単語も見かけましたが、ちょっと詳しくは調べきれていません。

> 技術的にはすごいんだろうけど開いたら CPU 使用率 MAX になったので結果的にはイケてないサイトになってる

これはスゴイ嫌ですね。昔の Flash サイトはこういうことよくありました。ただ今回の例では、自分の環境では CPU は一瞬上がるだけで特に問題ないように思いました。

あと、いま話題の[Branch](http://branch.com/)にて、僕も大好きなエディタ「Sublime Text」のサイトでも同じ事やってるよ、という記事。by ONO TAKEHIKO 氏。

[「Apple iPhone5 のページの JPEG と JS と canvas タグによるビデオの実装」の実装方法](http://branch.com/b/apple-iphone5-jpeg-js-canvas)

> アップルがやっていることを、実は Sublime Text のサイトでもやっていて、解説と共に圧縮画像とタイムライン JS ファイルの書き出し用エンコーダが公開されています。

そうだったんですねー。エンコーダも公開されているし。

最後に、今回の元記事を見つけたのは、元 Tumblr の開発者で[Instapaper](http://www.instapaper.com/)の作者でスーパーテックオタクの Marco のブログの[この記事](http://www.marco.org/2012/09/18/apple-json-video-compression)。いつも最先端のネタをポストしてくれるので要チェックです。
