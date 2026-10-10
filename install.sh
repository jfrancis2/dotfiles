#!/bin/sh
# Entry point for VS Code Dev Containers and Codespaces, which clone a dotfiles repo into each
# new container and run install.sh. Installs chezmoi if needed and applies this clone in place.
# Not used on the devbox or the Mac (see README).
set -eu

if ! chezmoi=$(command -v chezmoi); then
    bin_dir="$HOME/.local/bin"
    chezmoi="$bin_dir/chezmoi"
    if command -v curl >/dev/null; then
        sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$bin_dir"
    else
        sh -c "$(wget -qO- get.chezmoi.io)" -- -b "$bin_dir"
    fi
fi

# --promptDefaults: containers are created unattended, so take the defaults without asking.
script_dir=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
exec "$chezmoi" init --apply --promptDefaults --source="$script_dir"
