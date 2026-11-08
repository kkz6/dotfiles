#!/bin/bash
set -euo pipefail
clone_missing() {
    if [[ ! -d "$2" ]]; then
        git clone --depth=1 "$1" "$2"
    fi
}
clone_missing https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
clone_missing https://github.com/romkatv/powerlevel10k.git "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
clone_missing https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
clone_missing https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
mkdir -p "$HOME/Library/Fonts"
for style in Regular Bold Italic 'Bold Italic'; do
    target="$HOME/Library/Fonts/MesloLGS NF $style.ttf"
    if [[ ! -f "$target" ]]; then
        encoded="${style// /%20}"
        temp=$(mktemp)
        trap 'rm -f "$temp"' EXIT
        curl -fL --retry 2 "https://raw.githubusercontent.com/romkatv/powerlevel10k-media/master/MesloLGS%20NF%20$encoded.ttf" -o "$temp"
        mv "$temp" "$target"
        trap - EXIT
    fi
done
