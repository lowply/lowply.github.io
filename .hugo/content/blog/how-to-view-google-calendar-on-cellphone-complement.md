+++
categories = ["Tech"]
date = "2006-09-20T13:37:08+09:00"
draft = false
slug = "how-to-view-google-calendar-on-cellphone-complement"
title = "Googleカレンダーを携帯で見る方法：補足"
+++

![](/images/old/060920_gcallogo.gif)

[たたみラボ: Googleカレンダーを携帯で見る方法](http://www.tatamilab.jp/rnd/archives/000281.html)

で紹介されている[Google Calendar](http://www.google.com/calendar/)の使い方がすごい！と思ったのですが、 カレンダーを公開にしなくても携帯から見ることができる方法を発見。

Gcalの設定画面で、携帯から見たいカレンダーの名前をクリックし、一番下に出てくる「Private Address:」の中の「HTML」ボタンをクリックします。（[※参考画像](http://www.fixture.jp/blog/wp-content/uploads/old/060920_gcal.gif)）
そして出てきたURLをクリック、移動後のカレンダーページの右上のタブから「Agenda」を選択。そのページのURLを携帯に送れば、見れます。

原理としては、「Calendar Address:」というのは公開しているカレンダーのための一元的なURLで、「Private Address:」の方はそこにランダムな文字列を付加して認証不要の参照ができるようにしたもの、ということかな。
 
<blockquote class="blockquote">
  <p class="m-b-0">
	This is the private address for this calendar. Don't share this address with others unless you want them to see all the events on this calendar.
  </p>
  <footer class="blockquote-footer"><cite title=""></cite></footer>
</blockquote>

設定項目の下には、上に引用したような記述もあるので、このURLは他人には公開しないことを前提として用意されているようです。また、リセットボタンを押すことによって任意のタイミングで文字列をランダムに変える手段を提供しているのがすごいです。
えーつまりまとめると、

http://www.google.com/calendar/embed?src=<span style="color:red">アカウント名</span>%40gmail.com&pvttk=<span style="color:red">ランダムな文字列</span>&mode=AGENDA

ということになります。スケジュールの参照だけなら特に認証する必要ない、というたたみラボの大井氏の意見にすごく賛成です。出先で「この日空いてる？」って聞かれたとき、単に見れれば良いわけですから。これはもう手放せないです。こういう手段もきっちり用意しているところが、やっぱりGoogleですね。

**2007/05/25 追記**

やっとというか、ついにというか、Google Calendarもモバイル版が正式に出ました。予定の追加ができるので、イイです。携帯電話から「calendar.google.com」へアクセスするだけですが、[モバイル版にPCからでもアクセス可](http://www.google.com/calendar/m)。
