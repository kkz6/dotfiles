#!/bin/bash
# Link managed files with timestamped backups; install no extra applications.
set -euo pipefail
repo=$(cd "$(dirname "$0")" && pwd)
skip_deps=false
skip_terminal=false
for arg in "$@"; do
    case "$arg" in
        --skip-deps) skip_deps=true ;;
        --skip-terminal) skip_terminal=true ;;
        *) echo "Usage: $0 [--skip-deps] [--skip-terminal]" >&2; exit 2 ;;
    esac
done
if [[ $(uname -s) != Darwin ]] && ! $skip_terminal; then
    echo 'Use --skip-terminal outside macOS.' >&2; exit 1
fi
backup=$(mktemp -d "$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)-XXXXXX")
echo "Backups: $backup"
if ! $skip_deps; then bash "$repo/scripts/dependencies.sh"; fi
link_file() {
    local source="$repo/$1" target="$HOME/$2"
    mkdir -p "$(dirname "$target")"
    if [[ -L "$target" ]] && [[ $(readlink "$target") == "$source" ]]; then
        echo "Already linked: $target"; return
    fi
    if [[ -e "$target" || -L "$target" ]]; then
        mkdir -p "$backup/$(dirname "$2")"
        mv "$target" "$backup/$2"
    fi
    ln -s "$source" "$target"
    echo "Linked: $target"
}
link_file .zshrc .zshrc
link_file .zprofile .zprofile
link_file .p10k.zsh .p10k.zsh
link_file config/mise/config.toml .config/mise/config.toml
mkdir -p "$HOME/.local/bin"
if ! $skip_terminal; then
    python3 "$repo/scripts/terminal.py" "$repo/settings/Mocha.terminal" "$backup"
fi
echo 'Done. Start a new shell with: exec zsh'
