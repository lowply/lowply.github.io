+++
categories = ["Server"]
date = "2012-05-16T02:01:05+09:00"
draft = false
slug = "imagemagick67-imagick3-error"
title = "ImageMagick 6.7 + PECL::ImagickでlibWandエラー"
+++

[ImageMagick 6.7 + PECL::imagickのインストール | fixture.jp](/blog/2012/02/how-to-install-pecl-imagick-with-latest-imagemagick/)で書いた方法でImageMagickをセットアップしたサーバーで、こんなエラーが出るようになった。

```bash
$ php -v
PHP Warning:  PHP Startup: Unable to load dynamic library '/usr/lib64/php/modules/imagick.so' - libWand.so.10: cannot open shared object file: No such file or directory in Unknown on line 0
PHP 5.3.3 (cli) (built: Mar 30 2011 13:51:54) 
Copyright (c) 1997-2010 The PHP Group
Zend Engine v2.3.0, Copyright (c) 1998-2010 Zend Technologies
```

libWandがないという。。。少ししか調べてないが、libWand.soはlibMagickWand.soって名前に変わった疑いあり。ちらほら見かけたsymlinkを/usr/lib以下に張る方法も効果なし。

ImageMagickとPECL::Imagickはそれぞれ

```bash
$ convert --version
Version: ImageMagick 6.7.6-5 2012-04-16 Q16 http://www.imagemagick.org
Copyright: Copyright (C) 1999-2012 ImageMagick Studio LLC
Features: OpenMP

$ pecl list
Installed packages, channel pecl.php.net:
=========================================
Package Version State
imagick 3.0.1   stable
```

結局ImageMagick本体との間のバージョン的な相性問題らしく、imagick 2.3.0を持ってきてソースから入れ直したらうまくいった。（先輩ありがとうございます）やっぱ本体はyumで入れたほうがトラブル少なくていいのかなー。
