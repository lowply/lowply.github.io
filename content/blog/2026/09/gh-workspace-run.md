---
title: Running local code in GitHub Codespaces with gh workspace-run
date: 2026-09-14T21:20:52+09:00
description: Edit code locally while running tests in a GitHub Codespace with gh workspace-run.
draft: false
---

I made a small GitHub CLI extension called [gh workspace-run](https://github.com/lowply/gh-workspace-run). It lets you edit a Git repository locally while running commands in that repository's GitHub Codespace.

My preferred workflow for coding agents has been moving back toward local tools: one application with multiple tabs or agents, plus notifications when an agent needs attention. My main work environment has been shifted from VS Code to [Herdr](https://herdr.dev/) + [GitHub Copilot CLI](https://github.com/github/copilot-cli). It is much easier to keep track of parallel work when the agents share the same local environment instead of being spread across several remote workspaces.

The problem comes when an agent needs to run tests.

Some projects are designed primarily for development in GitHub Codespaces. They may use Docker-based test environments that are difficult or inefficient to reproduce on an Apple Silicon Mac. A project might depend on an AMD64-only base image or binary, requiring Docker Desktop to emulate `linux/amd64` containers on Arm64. Emulation is slower, uses more memory, and is not always equivalent to native execution.

Agents need to run tests frequently to verify their changes, so I wanted them to use the project's intended Linux environment without moving the entire editing and Git workflow into separate Codespaces.

## Using a Codespace as the execution environment

`gh workspace-run` runs a command in an existing Codespace over SSH. With the optional `--sync` flag, it first synchronizes the local working-tree files to the Codespace with `rsync`. The source editing, Git operations, and agent orchestration remain local.

Install the extension:

```console
$ gh extension install lowply/gh-workspace-run
```

See the repository's README for the Codespace prerequisites and setup instructions.

Create the configuration file:

```console
$ gh workspace-run config
```

Then map the repository to its Codespace name in `~/.config/gh-workspace-run/config.yml`:

```yaml
repositories:
  octocat/hello-world: example-codespace
```

This mapping will be set automatically if there's only one matching Codespace.

Now an agent can synchronize its local changes and run the test command remotely:

```console
$ gh workspace-run --sync -- ./script/test
Synchronizing local files...
Running: ./script/test
...
```

Synchronization treats the local files as authoritative. It sends tracked files and untracked, non-ignored files, removes remote Git-visible files that no longer exist locally, and leaves the remote `.git` directory and ignored files untouched.

If the files are already synchronized, the command can be run without `--sync`:

```console
$ gh workspace-run -- ./script/test test/jobs/example_test.rb
```

## Fast enough for repeated commands

The first invocation establishes a Codespaces SSH tunnel. `gh workspace-run` enables OpenSSH connection multiplexing with `ControlMaster` and keeps the connection available with `ControlPersist`.

Later SSH and `rsync` processes reuse that connection instead of establishing a new connection every time. Command execution is responsive with very little overhead, and syncing local changes with `--sync` is fast as well. This makes repeated test commands practical for an agent's edit-test loop.

## Give it a try

I have been using this extension at work for the past few weeks and have been very satisfied with how well it connects my local agent workflow to projects developed in GitHub Codespaces.

If you work on a project that already uses GitHub Codespaces, visit the [gh workspace-run repository](https://github.com/lowply/gh-workspace-run) and give it a try: edit and manage agents locally, then validate changes in the expected remote environment.
