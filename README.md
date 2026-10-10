# dotfiles

My bash, git, tmux and Ghostty config, managed with [chezmoi](https://www.chezmoi.io/). It targets these machines, with the same setup on each:

- **devbox**, a personal Ubuntu dev VM. cloud-init applies this repo there unattended. Any Debian/Ubuntu machine works the same way.
- **macOS** (my MacBook), with Homebrew bash, Ghostty and VS Code.

## Install

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin init --apply jfrancis2
```

chezmoi asks for a git author name and email, which are stored in `~/.config/chezmoi/chezmoi.toml`. To skip the prompts and use the defaults, add `--promptDefaults` (cloud-init does this).

To preview the changes before applying them:

```sh
chezmoi init jfrancis2
chezmoi diff
chezmoi apply
```

Day to day:

- `chezmoi update` pulls and applies the latest changes.
- `chezmoi edit ~/.bashrc` edits a file in the source repo, not the deployed copy.
- `chezmoi cd` opens a shell in the repo so you can commit and push.

### Requirements

You need bash 4+, git, tmux 3.2+ and vim. `bash-completion` and `uv` are optional; if they're installed they're picked up automatically. The git-aware prompt looks for `git-prompt.sh` where Debian/Ubuntu, Homebrew and Apple's Command Line Tools install it. If it can't find it, the prompt still works but leaves out the branch.

### macOS setup

macOS comes with bash 3.2 and uses zsh as its default shell. Before running the install command, set up a current bash from [Homebrew](https://brew.sh/) as your login shell. On an Intel Mac, use `/usr/local/bin/bash` instead of `/opt/homebrew/bin/bash`.

```sh
brew install bash bash-completion@2 git tmux
echo /opt/homebrew/bin/bash | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/bash
```

Then open a new terminal and run the install command above. A few things to know:

- **Existing files:** chezmoi replaces `~/.gitconfig` and your Ghostty config. Run `chezmoi diff` first and copy anything you want to keep into the repo or into a `.local` file (see below).
- **Ghostty:** the config needs Ghostty 1.2 or later. Its shell integration only works with a current bash, which is one more reason to use the Homebrew one.
- **VS Code:** the integrated terminal picks up your login shell. In it, `$EDITOR` is `code --wait`, so `git commit` and similar commands open in VS Code. This also applies over Remote-SSH to the devbox. Everywhere else, the editor is vim.

## What's here

| Source file | Becomes | Notes |
|---|---|---|
| `.chezmoi.toml.tmpl` | chezmoi config | Holds the git name and email, plus the `agent` flag (see below). |
| `dot_bashrc.tmpl` | `~/.bashrc` | Large shared history, PATH, completion, a git-aware prompt, aliases, and `t [name]` to attach to or create a tmux session. |
| `dot_profile` | `~/.profile` | Login shell setup: loads Homebrew if it's installed, then sources `~/.bashrc`. |
| `dot_bash_profile` | `~/.bash_profile` | Just sources `~/.profile`, so a stray `.bash_profile` can't stop it being read. |
| `dot_gitconfig.tmpl` | `~/.gitconfig` | Fast-forward-only pulls, zdiff3 conflicts, rerere, histogram diffs, and a few aliases (`st`, `lg`, `amend`, ...). |
| `dot_config/git/ignore` | `~/.config/git/ignore` | Global ignore list. It blocks `.env` files from every repo. |
| `dot_tmux.conf` | `~/.tmux.conf` | Mouse on, 100k lines of scrollback, windows numbered from 1, splits that open in the current directory, activity flags. `C-b r` reloads it. |
| `dot_inputrc` | `~/.inputrc` | Up/Down searches history for lines starting with what you've typed. |
| `dot_config/ghostty/config` | `~/.config/ghostty/config` | macOS only. Installs Ghostty's terminfo on SSH hosts, and makes left Option act as Alt. |

### Agent accounts

The devbox runs AI coding agents under their own Unix users, named `agent`, `agent2` and so on. If the username starts with `agent`, chezmoi sets `agent = true`, which changes two things:

- The prompt is magenta instead of green, so you can tell which shell you're in.
- Commits are authored as `Name (agent: <user>)`, so agent commits stand out in `git log`.

On any other username, nothing changes.

## Machine-specific settings

These files are sourced if they exist. They aren't managed by chezmoi, so local settings and secrets stay out of the repo:

- `~/.bashrc.local`: environment variables, tokens, extra aliases.
- `~/.gitconfig.local`: signing key, a work email, credential helpers.

**This repo is public and holds no secrets.** Keep it that way.

## Using it yourself

Licensed under [MIT](LICENSE). You're welcome to fork it or copy pieces. Before you run it as-is, change the default name and email in `.chezmoi.toml.tmpl`, or answer the prompts during install. Otherwise your commits will be authored as me.
