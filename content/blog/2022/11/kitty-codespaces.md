---
title: Kitty and GitHub Codespaces - The terminfo issue
date: 2022-11-11T12:39:37+09:00
draft: false
---

### Update on 2023-08-15

I realized that the result of the `infocmp -a xterm-kitty` command that run on macOS can be incompatible with terminfo on a Linux host.

On Codespace instances (and other Linux machines too) just downloading the terminfo file from the GitHub repository and passing it to the `tic` command is easier and more reliable.

```shell
gh api \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    /repos/kovidgoyal/kitty/contents/terminfo/kitty.terminfo \
    -q '.content' \
    | base64 -d \
    | tic -x -o ~/.terminfo -
```

_END OF UPDATE_

[Kitty](https://sw.kovidgoyal.net/kitty/) has been my main terminal software for quite a while. One unique thing about it is that it has its own terminfo, `xterm-kitty`. Without having the terminfo file on the server, you may encounter the following warning when running commands such as `less`, and the terminal actually isn't functional at all.

```shell
WARNING: terminal is not fully functional
```

There are some well-written solutions for this in [Frequently Asked Questions - kitty](https://sw.kovidgoyal.net/kitty/faq/). On [GitHub Codespaces](https://github.com/features/codespaces) instance, with the [GitHub CLI](https://github.com/cli/cli) you can apply this:

```shell
infocmp -a xterm-kitty | gh cs ssh -c [name of the codespace] -- tic -x -o \~/.terminfo /dev/stdin
```

You might see the following warning, but this can be ignored.

```shell
"/dev/stdin", line 2, col 22, terminal 'xterm-kitty': older tic versions may treat the description field as an alias
```

