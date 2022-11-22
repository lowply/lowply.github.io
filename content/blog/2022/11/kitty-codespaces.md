---
title: Kitty and GitHub Codespaces - The terminfo issue
date: 2022-11-11T12:39:37+09:00
draft: false
---

[Kitty](https://sw.kovidgoyal.net/kitty/) has been my main terminal software for quite a while. One unique thing about it is that it has its own terminfo, `xterm-kitty`. Without having the terminfo file on the server, you may encounter the following warning when running commands such as `less`, and the terminal actually isn't functional at all.

```console
WARNING: terminal is not fully functional
```

There are some well-written solutions for this in [Frequently Asked Questions - kitty](https://sw.kovidgoyal.net/kitty/faq/). On [GitHub Codespaces](https://github.com/features/codespaces) instance, with the [GitHub CLI](https://github.com/cli/cli) you can apply this:

```console
$ infocmp -a xterm-kitty | gh cs ssh -c [name of the codespace] -- tic -x -o \~/.terminfo /dev/stdin
```

You might see the following warning, but this can be ignored.

```console
"/dev/stdin", line 2, col 22, terminal 'xterm-kitty': older tic versions may treat the description field as an alias
```
