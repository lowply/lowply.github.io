+++
categories = ["Server"]
date = "2012-03-30T04:32:47+09:00"
draft = false
slug = "new-sakura-vps-cent62-getting-started"
title = "新さくらのVPS + CentOS 6.2 で最初にやったことメモ"
+++

[さくらのVPS v3 2Gプラン](http://vps.sakura.ad.jp/)を借りたので、最初にやったことをメモ。

#### 環境確認

契約後メールで送られてきたパスワードでログイン。まずはrootパスワード変更。

```bash
$ passwd
```

3コア。

```bash
$ cat /proc/cpuinfo | grep "model name"
model name : Intel(R) Xeon(R) CPU E5645
model name : Intel(R) Xeon(R) CPU E5645
model name : Intel(R) Xeon(R) CPU E5645
```

メモリ2GB。

```bash
$ cat /proc/meminfo | grep Mem
MemTotal: 2054804 kB
MemFree: 1482476 kB

$ free -m
 total used free shared buffers cached
Mem: 2006 558 1447 0 50 393
-/+ buffers/cache: 115 1891
Swap: 4031 0 4031
```

驚愕の200GB。ざっくり言うと / → 50GB /home → 150GB という割り当てっぽい。

```bash
$ df -h
Filesystem                         Size  Used Avail Use% Mounted on
/dev/mapper/vg_www1343uf-lv_root   50G   1.4G   46G   3% /
tmpfs                              1004M    0 1004M   0% /dev/shm
/dev/vda1                          485M   32M  428M   7% /boot
/dev/mapper/vg_www1343uf-lv_home   144G  188M  136G   1% /home
```

CentOS 6.2 64bit。

```bash
$ cat /etc/issue
CentOS release 6.2 (Final)
Kernel \r on an \m

$ uname -a
Linux xxx.sakura.ne.jp 2.6.32-220.7.1.el6.x86_64 #1 SMP Wed Mar 7 00:52:02 GMT 2012 x86_64 x86_64 x86_64 GNU/Linux
```

リッスンポート。最初は22番と25番が上がってる。

```bash
$ netstat -tanp | grep LISTEN
tcp 0 0 127.0.0.1:25 0.0.0.0:* LISTEN 1260/master
tcp 0 0 0.0.0.0:22 0.0.0.0:* LISTEN 22726/sshd
tcp 0 0 ::1:25 :::* LISTEN 1260/master
tcp 0 0 :::22 :::* LISTEN 22726/sshd
```

IPアドレス。

```bash
$ ifconfig -a | grep -w inet
inet addr:xxx.xxx.xxx.xxx Bcast:xxx.xxx.xxx.xxx Mask:255.255.254.0
inet addr:127.0.0.1 Mask:255.0.0.0
```

OSアップデートは最新版なので変化なし。

```bash
$ yum update
```

#### SSHとユーザー周り

SSH設定変更。ポートを変えて、パスワード認証を切る。rootログインはそのうちオフにする。

```bash
$ cd /etc/ssh/
$ cp -ip sshd_config{,.120329}
$ vi sshd_config
$ diff sshd_config.120329 sshd_config
13c13
< #Port 22
---
> Port XXXXXX # <---- As you like
66c66
< PasswordAuthentication yes
---
> PasswordAuthentication no

```

wheelで一般ユーザー作る。

```bash
$ useradd sho -g wheel
$ passwd sho
```

rootと一般ユーザー用に.ssh作って、公開鍵を登録。

```bash
$ cd /home/sho
$ mkdir .ssh
$ chmod 700 .ssh
$ vi .ssh/authorized_keys
$ chmod 600 .ssh/authorized_keys
$ chown -R sho:wheel .ssh
```

```bash
$ cd /root
$ mkdir .ssh
$ chmod 700 .ssh
$ vi .ssh/authorized_keys
$ chmod 600 .ssh/authorized_keys
```

wheelグループにはパスワードなしでsudoさせる。

```bash
$ cd /etc
$ cp -ip sudors{,.120329}
$ visudo
$ diff sudoers.120329 sudoers
105c105
< # %wheel ALL=(ALL) NOPASSWD: ALL
---
> %wheel ALL=(ALL) NOPASSWD: ALL
```

#### ロケールとBash

日本語やなのでロケールを変える。

```bash
$ cd /etc/sysconfig
$ cp -ip i18n{,.120329}
$ vi i18n
$ diff i18n.120329 i18n
1,2c1
< LANG="C"
< SYSFONT="latarcyrheb-sun16"
---
> LANG="en_US.UTF-8"

```

.bashrcを編集。あんまり良くないけどとりあえずUbuntu使ってた時のそのまま持ってきた。

```bash
$ cd
$ mv .bashrc{,.120329}
$ vi .bashrc
```

エイリアスは好みで。tmuxのショートカットと、viをvimに張ったぐらい。

```bash
$ vi .bash_aliases
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias vi='vim'
alias tm='tmux -2 a || tmux -2'
```

lessをカスタム。

```bash
$ cp -ip .bash_profile{,.120329}
$ vi .bash_profile
$ diff .bash_profile.120329 .bash_profile
12a13
> export LESS='-X -i -P ?f%f:(stdin).  ?lb%lb?L/%L..  [?eEOF:?pb%pb\%..]'
```

#### tmuxとdotfilesとvim

なにはともあれ[tmux](http://tmux.sourceforge.net/)入れる（ここからダウンロード：[http://tmux.sourceforge.net/](http://tmux.sourceforge.net/)）

```bash
$ yum install libevent libevent-devel ncurses ncurses-devel
$ cd /usr/local/src
$ wget http://downloads.sourceforge.net/project/tmux/tmux/tmux-1.6/tmux-1.6.tar.gz
$ tar vxzf tmux-1.6.tar.gz
$ cd tmux-1.6
$ ./configure --prefix=/usr/local/tmux
$ make
$ make install
```

おお、ここ空っぽなんだ。

```bash
$ cd /usr/local/bin/
$ ls -la
```

リンク張る。

```bash
$ ln -s /usr/local/tmux/bin/tmux .
```

いよいよ[dotfiles](http://fixture.jp/blog/2012/02/how-to-manage-dotfiles-on-github/)。gitは最初から入ってる。

```bash
$ cd
$ git clone --recursive git://github.com/lowply/dotfiles.git
$ cd dotfiles
$ sh symlink.sh
$ vi
```

一回vim立ち上げる時にエラー出るけど気にしない。

```bash
:NeoBundleInstall
:q
```

ここで入るプラグインは「[neobundleでvimプラグイン管理](http://fixture.jp/blog/2012/02/switching-to-neobundle/)」を参照。

vim抜けたらvimprocをmakeしておく。

```bash
$ cd .vim/bundle/vimproc
$ make -f make_unix.mak
```

#### 所感
とりあえず今回はユーザー作成、SSH設定、dotfiles、tmux、vimあたりまで。作業してて、yumとかmakeとかの体感速度が上がった気がした。それにOSの起動も速い。さくらさんスゴイっす。

抜けとかオススメの設定あったらツッコミお願いします。
