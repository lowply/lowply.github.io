+++
categories = ["Tech"]
date = "2017-08-17T19:56:26+09:00"
description = ""
draft = false
slug = "merge-github-pages"
title = "GitHub PagesとマージしてURLを変えた"

+++

2006年から使っていたfixture.jpというドメインをブログに使うのをやめて、これまでプロフィール的に使っていた[GitHub Pages](https://pages.github.com/)のドメインlowply.github.ioに統合しました。

2016年の6月にGitHubに入社して以来、Pagesをもう少し積極的に使っていきたいと思っていたのと、HTTPSを使いたいだけのためにCloudFrontを経由したS3でホストするのも大げさだなと思ってのアイデアです。

ちょっと困ったのは、lowply.github.ioのようなドメイン直下にPagesのサイトを置きたい場合、ソースの配置先は`master`ブランチのみで`/docs`が選べなかったこと。

> If your site is a User or Organization Page that has a repository named `<username>.github.io` or `<orgname>.github.io`, you cannot publish your site's source files from different locations. User and Organization Pages that have this type of repository name are only published from the `master` branch.

[Configuring a publishing source for GitHub Pages](https://help.github.com/articles/configuring-a-publishing-source-for-github-pages/)

Hugoで生成したファイル群をリポジトリの直下に置かないといけないので、ディレクトリの見通しが悪くなる。仕方がないからコンテンツやテーマといったHugo関連のファイル群を`.hugo`ディレクトリに置くことに。隠しディレクトリにしているのは、hugoコマンドに`--cleanDestinationDir`をつけても自分自身が消されないためです。

というわけで、書きたいネタは少しずつ浮かぶものの形にできず更新が止まっているブログですが、引き続き時間を見て書いていきます。[Photo Journal](https://lowply.github.io/photo/)もそのうち更新します。
