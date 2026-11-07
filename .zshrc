# Managed by kkz6/dotfiles. Keep private or machine-specific settings in ~/.zshrc.local.
export ZSH="${ZSH:-$HOME/.oh-my-zsh}"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git macos colored-man-pages z zsh-autosuggestions)
ZSH_COMPDUMP="$ZSH/cache/.zcompdump-$ZSH_VERSION"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=245'
[[ -r "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_REDUCE_BLANKS HIST_IGNORE_SPACE
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
[[ -r "${ZDOTDIR:-$HOME}/.p10k.zsh" ]] && source "${ZDOTDIR:-$HOME}/.p10k.zsh"

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
[[ -r "${ZDOTDIR:-$HOME}/.zshrc.local" ]] && source "${ZDOTDIR:-$HOME}/.zshrc.local"

# Keep fzf optional and respect settings in .zshrc.local.
if [[ -o zle ]] && (( $+commands[fzf] )) && _kk_fzf_init=$(fzf --zsh 2>/dev/null); then
    if [[ -z ${FZF_DEFAULT_OPTS+x} && -z ${FZF_DEFAULT_OPTS_FILE+x} ]]; then
        export FZF_DEFAULT_OPTS='--height=45% --layout=reverse --border=rounded --color=bg+:#313244,fg:#cdd6f4,fg+:#cdd6f4,hl:#f38ba8,hl+:#f38ba8,info:#cba6f7,prompt:#89b4fa,pointer:#f5e0dc,marker:#a6e3a1'
    fi
    eval "$_kk_fzf_init"
fi
unset _kk_fzf_init

# Highlighting must load after shell widgets and integrations.
_kk_highlighting="${ZSH_CUSTOM:-$ZSH/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[[ -r "$_kk_highlighting" ]] && source "$_kk_highlighting"
unset _kk_highlighting
