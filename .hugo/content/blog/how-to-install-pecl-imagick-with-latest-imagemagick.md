+++
categories = ["Server"]
date = "2012-02-16T20:18:14+09:00"
draft = false
slug = "how-to-install-pecl-imagick-with-latest-imagemagick"
title = "ImageMagick 6.7 + PECL::imagickのインストール"
+++

ImageMagick 6.6 系のときはこんなことなかった気がするんだけど、 PECL::imagick のインストールがこける。こちらの記事を見つつも、微妙に環境が違うし、 /usr/bin/php-config とか編集したくないし、何か別の方法があるはずと思って探ってみた。

- [[PHP]Imagickのインストールエラーの対処法 - DQNEO起業日記](http://dqn.sakusakutto.jp/2010/08/phpimagick.html)
- [PHP 拡張モジュールImagickの導入時に遭遇したPECLのバグの回避策など - r_nobuホームページ ](http://nobuneko.com/blog/archives/2010/10/php_imagickpecl.html)

とりあえず現状
```bash
$ uname -orm
2.6.18-238.el5 x86_64 GNU/Linux

$ cat /etc/issue
CentOS release 5.7 (Final)
Kernel \r on an \m
```
ここから最新のsrcをDL。[ImageMagick: Downloads](http://www.imagemagick.org/script/download.php)
```bash
$ cd /usr/local/src/
$ wget ftp://ftp.kddlabs.co.jp/graphics/ImageMagick/ImageMagick-6.7.5-6.tar.bz2
$ tar vxjf ImageMagick-6.7.5-6.tar.bz2
$ cd ImageMagick-6.7.5-6

- perlで使うかもしれないので
$ ./configure --prefix=/usr/local/ImageMagick --with-perl

$ make && make install

$ cd /usr/local/bin
$ ln -s /usr/local/ImageMagick/bin/* .
```
ここまではいい。
```bash
$ pecl install imagick
```
すると
```bash
downloading imagick-3.0.1.tgz ...
Starting to download imagick-3.0.1.tgz (93,920 bytes)
.....................done: 93,920 bytes
13 source files, building
running: phpize
Configuring for:
PHP Api Version: 20090626
Zend Module Api No: 20090626
Zend Extension Api No: 220090626
Please provide the prefix of Imagemagick installation [autodetect] :
building in /var/tmp/pear-build-rootoxvYzf/imagick-3.0.1
running: /var/tmp/imagick/configure --with-imagick=/usr/local/ImageMagick
checking for egrep... grep -E
checking for a sed that does not truncate output... /bin/sed
checking for cc... cc
checking for C compiler default output file name... a.out
.
.
.
checking for gawk... gawk
checking whether to enable the imagick extension... yes, shared
checking whether to enable the imagick GraphicsMagick backend... no
checking ImageMagick MagickWand API configuration program... found in /usr/local/ImageMagick/bin/MagickWand-config
checking if ImageMagick version is at least 6.2.4... found version 6.7.5 Q16
checking for MagickWand.h header file... found in /usr/local/ImageMagick/include/ImageMagick/wand/MagickWand.h
checking PHP version is at least 5.1.3... yes. found 5.3.3
Package MagickWand was not found in the pkg-config search path.
Perhaps you should add the directory containing 'MagickWand.pc'
to the PKG_CONFIG_PATH environment variable
No package 'MagickWand' found
Package MagickWand was not found in the pkg-config search path.
Perhaps you should add the directory containing 'MagickWand.pc'
to the PKG_CONFIG_PATH environment variable
No package 'MagickWand' found</span>
.
.
.
checking if f95 supports -c -o file.o... yes
checking whether the f95 linker (/usr/bin/ld -m elf_x86_64) supports shared libraries... yes
checking dynamic linker characteristics... GNU/Linux ld.so
checking how to hardcode library paths into programs... immediate
configure: creating ./config.status
config.status: creating config.h
running: make
/bin/sh /var/tmp/pear-build-rootoxvYzf/imagick-3.0.1/libtool --mode=compile cc -I. -I/var/tmp/imagick -DPHP_ATOM_INC -I/var/tmp/pear-build-rootoxvYzf/imagick-3.0.1/include -I/var/tmp/pear-build-rootoxvYzf/imagick-3.0.1/main -I/var/tmp/imagick -I/usr/include/php -I/usr/include/php/main -I/usr/include/php/TSRM -I/usr/include/php/Zend -I/usr/include/php/ext -I/usr/include/php/ext/date/lib -DHAVE_CONFIG_H -g -O2 -c /var/tmp/imagick/imagick_class.c -o imagick_class.lo
mkdir .libs
cc -I. -I/var/tmp/imagick -DPHP_ATOM_INC -I/var/tmp/pear-build-rootoxvYzf/imagick-3.0.1/include -I/var/tmp/pear-build-rootoxvYzf/imagick-3.0.1/main -I/var/tmp/imagick -I/usr/include/php -I/usr/include/php/main -I/usr/include/php/TSRM -I/usr/include/php/Zend -I/usr/include/php/ext -I/usr/include/php/ext/date/lib -DHAVE_CONFIG_H -g -O2 -c /var/tmp/imagick/imagick_class.c -fPIC -DPIC -o .libs/imagick_class.o
In file included from /var/tmp/imagick/imagick_class.c:21:
/var/tmp/imagick/php_imagick.h:49:31: error: wand/MagickWand.h: No such file or directory</span>
In file included from /var/tmp/imagick/imagick_class.c:22:
/var/tmp/imagick/php_imagick_defs.h:72: error: expected specifier-qualifier-list before 'MagickWand'
/var/tmp/imagick/php_imagick_defs.h:80: error: expected specifier-qualifier-list before 'DrawingWand'
/var/tmp/imagick/php_imagick_defs.h:86: error: expected specifier-qualifier-list before 'PixelIterator'
/var/tmp/imagick/php_imagick_defs.h:98: error: expected specifier-qualifier-list before 'PixelWand'
.
.
.
```
あとはずっとエラーの嵐。しょうがないからメッセージを1行ずつ読んでいく。とりあえずエラーの嵐の直前で
```bash
/var/tmp/imagick/php_imagick.h:49:31: error: wand/MagickWand.h: No such file or directory
```
と言ってる。が、ちゃんとこれは
```bash
/usr/local/ImageMagick/include/ImageMagick/wand/MagickWand.h
```
にある。さらに上の方を見ると
```bash
Package MagickWand was not found in the pkg-config search path.
Perhaps you should add the directory containing `MagickWand.pc'
to the PKG_CONFIG_PATH environment variable
No package 'MagickWand' found
```
って言ってるので、MagickWand.pcがある場所にパスが通ってないらしい。
```bash
$ echo $PKG_CONFIG_PATH
```
たしかに空。 MagickWand.pcがあるディレクトリを探して
```bash
$ updatedb
$ locate MagickWand.pc
/usr/local/ImageMagick/lib/pkgconfig/MagickWand.pc
/usr/local/src/ImageMagick-6.7.5-6/wand/MagickWand.pc
/usr/local/src/ImageMagick-6.7.5-6/wand/MagickWand.pc.in
```
ってことで追加してみる。
```bash
$ export PKG_CONFIG_PATH=/usr/local/ImageMagick/lib/pkgconfig
$ pecl install imagick
```
入った。
```bash
$ ls -la /usr/lib64/php/modules/imagick.so
-rw-r--r-- 1 root root 1132254 Feb 16 00:00 /usr/lib64/php/modules/imagick.so

$ pecl list
INSTALLED PACKAGES, CHANNEL PECL.PHP.NET:
=========================================
PACKAGE VERSION STATE
imagick 3.0.1 stable
```
あとは反映、確認
```bash
$ echo extension=imagick.so > /etc/php.d/imagick.ini
$ /etc/init.d/httpd restart
$ php -i | grep imagick
imagick
imagick module => enabled
imagick module version => 3.0.1
imagick classes => Imagick, ImagickDraw, ImagickPixel, ImagickPixelIterator
imagick.locale_fix => 0 => 0
imagick.progress_monitor => 0 => 0
```
