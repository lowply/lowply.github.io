+++
categories = ["Server"]
date = "2012-03-16T12:53:43+09:00"
draft = false
slug = "how-to-revert-dev-name-to-eth-on-centos6-dell-machine"
title = "DELL筐体でCentOS6系のネットワークデバイス名をethXに戻して使う"
+++

根幹部分の変更のせいで多方面での迷惑が予想されるRHEL6系OSのネットワークデバイス名問題、例えば「em1ではなくeth0を使いたい」という場合、下記のマニュアルが参考になる。注：DELLマシンの場合。

<blockquote class="blockquote">
  <p class="m-b-0">
	To disable the use of the new naming scheme, during installation (attended or automated), pass the kernel command line parameter biosdevname=0 on the boot command line.
  </p>
  <footer class="blockquote-footer"><cite title=""><a href="http://linux.dell.com/files/whitepapers/consistent_network_device_naming_in_linux.pdf">Consistent Network Device Naming in Linux [PDF]</a></cite></footer>
</blockquote>

上記の「カーネルコマンドラインパラメータに渡す」ということをPXE Boot環境で実行したかったので、pxelinux.cfg/defaultに

```apache
default CL6.2_64

label CL6.2_64
kernel vmlinuz
append ks=http://[IPADDR]/CL6.2_64.cfg ksdevice=eth0 load initrd=initrd.img devfs=nomount biosdevname=0
```

と書いておいてPXE→起動すると何事も無かったかのようにeth0, eth1...という感じで使えた。。。あまりないと思うけど稼働中のOSに対して設定する方法も書いてあるので、詳細はPDFの参照を。
