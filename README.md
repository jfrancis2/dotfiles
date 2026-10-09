# dotfiles

Shell, git and tmux config, managed with [chezmoi](https://www.chezmoi.io/). Applied automatically by cloud-init on the `devbox` VM

## Use

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin init --apply --promptDefaults <repo-url>
```

Later changes: `chezmoi update` (pull and apply), or edit with `chezmoi edit ~/.bashrc` and commit from `chezmoi cd`.

## What's here

| File | Notes |
|---|---|
| `.chezmoi.toml.tmpl` | Git name/email (defaults apply unattended) and the `agent` flag, true for users named `agent*`. |
| `dot_bashrc.tmpl` | History, PATH, completion, git-aware prompt (magenta for agents), aliases, `t` = attach-or-create tmux session. |
| `dot_profile` | Login shells source `.bashrc`. |
| `dot_gitconfig.tmpl` | Agents commit as `<name> (agent: <user>)` so their commits are easy to tell apart. |
| `dot_config/git/ignore` | Global ignore, including `.env` files. |
| `dot_tmux.conf` | Mouse, 100k scrollback, 1-based windows, splits in current dir, activity flags. |
| `dot_inputrc` | Prefix history search on Up/Down. |

Not managed: `~/.bashrc.local` for machine-specific settings. **No secrets in this repo.**
