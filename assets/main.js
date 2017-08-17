hljs.initHighlightingOnLoad();

$(function(){
	var path = "fixture.jp" + $(".hb-button.http a").attr("href")
	var hb_url = "http://b.hatena.ne.jp/entry/" + path
	var hb_count_img = "https://b.hatena.ne.jp/entry/image/http://" + path
	$(".hb-button.http small a").attr("href", hb_url)
	$(".hb-button.http small a").append('<img src="' + hb_count_img + '" />')
})
