---
title: GitHub CLI vs Git Credential Manager - Which is better as a credential manager?
date: 2022-08-16T21:05:33+09:00
draft: false
---

## TL;DR

[Git Credential Manager](https://github.com/GitCredentialManager/git-credential-manager), also known as `gcm`, is the most popular, multi-platform credential helper. [GitHub CLI](https://github.com/cli/cli), also known as the `gh` command, [can also be used as a credential manager](https://github.com/cli/cli/pull/2449). [These two are officially recommended by GitHub](https://docs.github.com/en/get-started/getting-started-with-git/caching-your-github-credentials-in-git), but which one should I pick?

After some trials and errors, I decided to use `gcm` over `gh` as it's more secure and straightforward. Note that you still have to run `gh auth login` to use `gh`, even if `gcm` is chosen as the credential helper for Git. And don't get me wrong, `gh` is an awesome cli tool. My main focus in this article is about the credential management functionality.

## 1. Two tokens and osxkeychain

Before diving into the details, let's talk about `osxkeychain` first.

On macOS, `osxkeychain` is set at the system level by default, in both default `git` and homebrew `git`.

Homebew Git

```text
$ /opt/homebrew/bin/git config --list --show-origin | grep credential.helper
file:/opt/homebrew/etc/gitconfig	credential.helper=osxkeychain
file:/Users/sho/.gitconfig	credential.helper=!git-credential-manager-core
```

```text
$ cat /opt/homebrew/etc/gitconfig
[credential]
	helper = osxkeychain
```

Xcode Git

```text
$ /usr/bin/git config --list --show-origin | grep credential.helper
file:/Applications/Xcode.app/Contents/Developer/usr/share/git-core/gitconfig	credential.helper=osxkeychain
file:/Users/sho/.gitconfig	credential.helper=!git-credential-manager-core
```

```text
$ cat /Applications/Xcode.app/Contents/Developer/usr/share/git-core/gitconfig
[credential]
	helper = osxkeychain
```

Due to this configuration, the first time you clone a repo after authenticating with `gh` or `gcm`, a new OAuth access token will be stored in the Keychain.app in addition to the one that's already generated for the OAuth app.

### gh

With `gh`, this is the reason why you can still clone a private repo after running `gh auth logout -h github.com` and can be really confusing. Also, with `gh`, the token in the `~/.config/gh/hosts.yml` file and the token in the Keychain.app (Internet password for github.com) are _different_ (unsure why).

### gcm

With `gcm`, there's no concept of logging out. To delete the authentication token you should manually remove it from the credential store. No confusion. Also, with `gcm`, these tokens (application password and the Internet password for github.com) are _the same_.

## 2. How to store credentials

### gh

I've briefly covered this topic in the previous section - With `gh`, after authenticating using `gh auth login`, the credential will be stored in the configuration file `~/.config/gh/hosts.yml` as a plain text format.

Note that this may change in the future, see [feat: Support for storing OAuth token in encrypted keychain](https://github.com/cli/cli/issues/449) for more info.

### gcm

On the other hand, `gcm` stores its credentials in the Keychain.app on macOS and Windows Credential Manager on Windows so it's much more secure.

There's no default credential store for Linux though. If your Linux machine is owned by you and there's no other users, `plaintext` can be an option - See [Credential stores](https://github.com/GitCredentialManager/git-credential-manager/blob/main/docs/credstores.md) for more details.

Do you want to use Keychain.app on macOS and plaintext on Linux? Use `[include]` directive in your `~/.gitconfig`. With this, you can load environment specific configuration files e.g. `~/.gitconfig.local`.

```text
$ tail -n 2 ~/.gitconfig
[include]
    path = ~/.gitconfig.local
```

Then only on your Linux machine, add `credentialStore = plaintext` to `~/.gitconfig.local`:

```text
$ cat ~/.gitconfig.local
[credential]
	credentialStore = plaintext
```

If you choose plaintext, your credential will be stored in `~/.gcm/store/git/https/github.com/[username].credential`.

## 3. The helper path

## gh

Due to the reason explained in https://github.com/cli/cli/blob/v2.14.3/pkg/cmdutil/factory.go#L42-L57, `gh auth setup-git` will add the absolute path to the `gh` binary in your local `~/.gitconfig`, for example:

```ini
[credential]
	helper = !/opt/homebrew/bin/gh auth git-credential
```

This can be a problem when you manage your dotfiles using GitHub and want to use a single `.gitconfig` across multiple environments.

Btw, the `!` at the beginning is explained in [Git - gitcredentials Documentation](https://git-scm.com/docs/gitcredentials):

> If the helper string begins with "!", it is considered a shell snippet, and everything after the "!" becomes the command.

### gcm

On the other hand, with `gcm`, the installation path is the same at least both on macOS and Linux. On macOS the `git-credential-manager-core` binary is installed in `/usr/local/share/gcm-core` and the symlink to the binary will be created in `/usr/local/bin`. On Linux the `git-credential-manager-core` binary is installed in `/usr/local/bin`, either using the tarball or the .deb package.

So your `~/.gitconfig` should be simple, just set the absolute path to the binary as the helper:

```ini
[credential]
    helper = /usr/local/bin/git-credential-manager-core
```

## Conclusion

As I said in the beginning, in my impression `gcm` is much more secure and straightforward as a credential store. Hope this helps!