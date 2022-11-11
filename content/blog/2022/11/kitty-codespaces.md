---
title: Kitty and GitHub Codespaces - The terminfo issue
date: 2022-11-11T12:39:37+09:00
draft: false
---

[Kitty](https://sw.kovidgoyal.net/kitty/) has been my main terminal software for quite a while. One unique thing about it is that it has its own terminfo, `xterm-kitty`. Without having the terminfo file on the server, you may encounter the following error when running commands such as `less`.

```console
WARNING: terminal is not fully functional
```

There are some well-written solutions for this in [Frequently Asked Questions - kitty](https://sw.kovidgoyal.net/kitty/faq/), but I started to notice that none of the solutions work well when I'm on a [GitHub Codespaces](https://github.com/features/codespaces) instance.

The solution for this is simple. Create the `~/.terminfo/x` directory first and copy the `xterm-kitty` terminfo file over there. With the [GitHub CLI](https://github.com/cli/cli) that's even easier:

```console
$ gh cs ssh -- mkdir -p .terminfo/x
$ gh cs cp /Applications/kitty.app/Contents/Resources/kitty/terminfo/78/xterm-kitty remote:.terminfo/x/xterm-kitty
```
