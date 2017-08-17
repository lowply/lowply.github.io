+++
categories = ["Tech"]
date = "2007-02-14T04:43:38+09:00"
draft = false
slug = "why-overflow-is-better-than-clearfix"
title = "clearfixよりoverflowの方が良い理由"
+++

雑誌にも登場していたし、最近ブーム？のclearfixというCSSハック。clearfixっていうのは最初の人が考えた単なるクラス名なので変えてもいいんですが、肝心なのは中身。どういうものかというと、

```css
.clearfix:after {
    content: &quot;.&quot;;
    display: block;
    height: 0;
    clear: both;
    visibility: hidden;
}
.clearfix {display: inline-table;}    /* Hides from IE-mac */
* html .clearfix {height: 1%;}
.clearfix {display: block;}  /* End hide from IE-mac */
```

みたいなハックだらけの長いCSSを書いて、フロートさせている要素のみを内包した要素に適用して、HTMLに一切変更を加えずclearと同様の効果を得るというもの。詳細は[clearfixでGoogle検索](http://www.google.co.jp/search?q=clearfix&amp;lr=lang_ja)すればいろいろわかります。
で、これと同じ効果は

```css
overflow:hidden;
```

で再現できるので、僕はいつもこちらを使ってwrapperとか名前付けたdivの高さを確保しています。（Mac IEは検証すらせず無視しています）

clearfixはハックだらけな上に、要素にクラス名をひとつ増やさなきゃいけないので。。。一方、`overflow:hidden;` を使う場合、完全にMac IEとNetscape7の表示はあきらめなきゃいけないんですが、いまどきそんなものは無視！というスタンスの場合、おすすめです。というより、そういうスタンス自体がおすすめです。
さらに、`overflow:hidden;` は、モダンブラウザで要素A内にある要素Bのmargin-topが要素Aのmargin-topになってしまう表示（仕様？）や、IE6でdivがある一定以下の高さになってくれないときなどにも使えます。正しい使い方なのか不明ですが。。。　このへんの詳細についてはまたいつか書きたいと思ってます。
