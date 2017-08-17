+++
categories = ["Server"]
date = "2012-07-06T14:13:46+09:00"
draft = false
slug = "block-spam-with-procmail"
title = "NGワードを元にスパムメールを処理するprocmailレシピ"
+++

久々に癖のある.procmailレシピを書いたのでメモ。

やりたいこと：**NGワードファイルを参照して、SubjectかFromにマッチする単語があれば捨てる**

```asciidoc
NGWORD=$HOME/.ngwords

:0
* ^Subject:\/.*
* ? test -s $NGWORD
* ? echo "$MATCH" | /usr/bin/nkf -wZ2 | /bin/sed 's/[[:space:][:punct:]]//g' | /bin/fgrep -iqf $NGWORD
.Trash/

:0 E
* ^From:\/.*
* ? test -s $NGWORD
* ? echo "$MATCH" | /usr/bin/nkf -wZ2 | /bin/sed 's/[[:space:][:punct:]]//g' | /bin/fgrep -iqf $NGWORD
.Trash/
```

以下、一部解説。パイプ部分は一個ずつ書いた。

- `* ^Subject:\/.*` メールの件名を対象
- `* ? test -s $NGWORD` .ngwordsファイルの存在確認
- `* ? echo "$MATCH"` 対象（件名）をecho
- `nkf -wZ2` iso-9022-jpの文字列をUTF-8にし（-w）全角スペースを半角スペース二つに変換（-Z2）
- `/bin/sed 's/[[:space:][:punct:]]//g'` 空白スペース([:space:]) と「`!@#$%*,.`」などの英字記号 ([:punct:]) を削除
- `/bin/fgrep -iqf $NGWORD` 大文字小文字の区別をせず（-i）標準出力に出さず（-q）改行区切りのパターンファイルを指定（-f）
- `.Trash/` Trashフォルダに移動

あとは .ngwords ファイルに改行区切りで単語を書いていけば良い。日本語もOK。むかつく単語だらけでこの作業が一番イラっとした。。。.Trash に移動じゃなくて /dev/null に捨てるのもあり。

参考：[PROCMAIL](http://www.jaist.ac.jp/~fjt/procmail.html#NGWORD)
