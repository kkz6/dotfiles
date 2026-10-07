# Managed by kkz6/dotfiles. Keep private or machine-specific settings in ~/.zshrc.local.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git macos colored-man-pages z zsh-autosuggestions)
ZSH_COMPDUMP="$ZSH/cache/.zcompdump-$ZSH_VERSION"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=245'
source "$ZSH/oh-my-zsh.sh"

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS HIST_REDUCE_BLANKS
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

typeset -U path
path=("$HOME/.local/bin" $path)
if command -v mise >/dev/null; then
    eval "$(mise activate zsh)"
fi

# Herd is optional; keep its PHP and Node integration when installed.
if [[ -d "$HOME/Library/Application Support/Herd" ]]; then
    export HERD_PHP_84_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/84"
    export NVM_DIR="$HOME/Library/Application Support/Herd/config/nvm"
    [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
    [[ -f /Applications/Herd.app/Contents/Resources/config/shell/zshrc.zsh ]] && source /Applications/Herd.app/Contents/Resources/config/shell/zshrc.zsh
    path=("$HOME/Library/Application Support/Herd/bin" $path)
fi
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
# Highlighting must load after shell widgets and integrations.
source "$ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
