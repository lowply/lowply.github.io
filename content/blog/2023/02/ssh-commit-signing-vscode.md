---
title: SSH commit signing with GitHub Codespaces + VS Code
date: 2023-02-03T20:33:45+09:00
draft: false
---

GitHub Codespaces [supports GPG commit signing](https://docs.github.com/en/codespaces/managing-your-codespaces/managing-gpg-verification-for-github-codespaces). Of course, by [SSHing to the Codespaces instance](https://docs.github.com/en/codespaces/developing-in-codespaces/using-github-codespaces-with-github-cli#ssh-into-a-codespace) using any terminal software with [SSH agent forwarding](https://docs.github.com/en/developers/overview/using-ssh-agent-forwarding), you can [sign your commits with your SSH key](https://docs.github.com/en/authentication/managing-commit-signature-verification/about-commit-signature-verification#ssh-commit-signature-verification) as well.

However, this isn't applicable to VS Code. Using VS Code and its terminal functionality means no SSH agent forwarding (because you're not SSHing), so there's no SSH private key to sign, unless you manually `scp` your SSH private key to the Codespaces instance (which is a terrible idea).

I prefer [SSH commit signing](https://github.blog/changelog/2022-08-23-ssh-commit-verification-now-supported/) over GPG as SSH keys are much easier to manage, so I wanted to solve this. Turns out, by re-using the `SSH_AUTH_SOCK` environment variable, SSH commit signing becomes possible on VS Code.

You'll first have to SSH into the Codespaces instance from your terminal software with SSH agent forwarding:

```console
$ gh cs ssh
```

Once you're in, the path to the SSH agent socket file is exported to the `SSH_AUTH_SOCK` variable:

```console
$ echo $SSH_AUTH_SOCK
/tmp/ssh-[random-string]/agent.[PID]
```

By assigning the same value to the same environment variable in VS Code's terminal, you'll be able to use the SSH key via the agent, as long as the original SSH connection is alive.

```console
$ export SSH_AUTH_SOCK=/tmp/ssh-[random-string]/agent.[PID]
```

Adding the following snippets to your `~/.bashrc` and using your [dotfiles](https://docs.github.com/en/codespaces/customizing-your-codespace/personalizing-github-codespaces-for-your-account#dotfiles) for Codespaces, all of this can be automated.

```bash
if [ "${CODESPACES}" == "true" ] && [ "${TERM_PROGRAM}" == "vscode" ]; then
    for x in $(find /tmp/ssh-* -type s 2>/dev/null); do
        if SSH_AUTH_SOCK=${x} ssh-add -l > /dev/null; then
            echo "Setting SSH_AUTH_SOCK to ${x}"
            export SSH_AUTH_SOCK=${x}
            break
        fi
    done
fi
```

To verify the agent forwarding, simply try SSH to github.com:

```console
$ ssh git@github.com
PTY allocation request failed on channel 0
Hi lowply! You've successfully authenticated, but GitHub does not provide shell access.
Connection to github.com closed.
```

Alternatively, you can also utilize [Codespaces secrets](https://docs.github.com/en/codespaces/managing-your-codespaces/managing-encrypted-secrets-for-your-codespaces) for SSH keys. But I decided to go with the agent forwarding way for now.

