hljs.initHighlightingOnLoad();

$(function(){
	var path = "fixture.jp" + $(".hb-button.old a").attr("href")
	var hb_url = "http://b.hatena.ne.jp/entry/" + path
	var hb_count_img = "https://b.hatena.ne.jp/entry/image/http://" + path
	$(".hb-button.old small a").attr("href", hb_url)
	$(".hb-button.old small a").append('<img src="' + hb_count_img + '" />')
})
