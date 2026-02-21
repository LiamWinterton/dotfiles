# =======================================
# Shell Integrations
# =======================================
eval "$(starship init zsh)"
eval "$(fzf --zsh)"

# =======================================
# PLUGIN MANAGER
# =======================================
ANTIDOTE="${ZDOTDIR:-${HOME}}/.antidote"

# Download antidote if it's not there yet
if [ ! -d "$ANTIDOTE" ]; then
	git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTIDOTE"
fi

# Source and load
source "${ANTIDOTE}/antidote.zsh"
antidote load

# =======================================
# TMUX
# =======================================
TMUX_DIR="${HOME}/.tmux/plugins/tpm"
TMS_PATH="${HOME}/.local/bin/tmux-sessionizer"

# Download TPM if it's not there yet
if [ ! -d "$TMUX_DIR" ]; then
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Download Tmux Sessionizer if it's not there yet
if [[ ! -f "$TMS_PATH" ]]; then
    echo "tmux-sessionizer not found. Downloading from GitHub..."
    
    # Ensure the target directory exists
    mkdir -p "$HOME/.local/bin"
    
    # Download the raw script directly from the master branch
    if curl -fsSL "https://raw.githubusercontent.com/ThePrimeagen/tmux-sessionizer/master/tmux-sessionizer" -o "$TMS_PATH"; then
        # Make it executable
        chmod +x "$TMS_PATH"
        echo "Successfully installed tmux-sessionizer to $TMS_PATH!"
    else
        echo "Error: Failed to download tmux-sessionizer."
        # Clean up the file if curl failed but still created an empty destination file
        rm -f "$TMS_PATH"
    fi
fi

bindkey -s ^f "tmux-sessionizer\n"

# =======================================
# ALIASES
# =======================================
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias glog="git log --oneline --graph --parents --all"

# =======================================
# KEYBINDS
# =======================================
# Enable emacs mode because we're 80 years old apparently
bindkey -e
# Makes autosuggestions search command sensitive
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# =======================================
# ZSTYLE
# =======================================
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# Enable ls style colors for completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# Disable default completion menu in favour of fzf
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color=force $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color=force $realpath'

# Opts
HISTSIZE=5000 # Enables suggestions to have more context
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# ========================================
# PATH EXPORTS
# ========================================
# fnm
FNM_PATH="/home/liam/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "`fnm env`"
fi

# ~/.local/bin/
eval "$(fnm env --use-on-cd --shell zsh)"
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# ========================================
# ANNOYING THINGS THAT HAVE TO LOAD LAST
# ========================================
ZOXIDE_PATH="/home/liam/.local/bin"
if [ -d "$ZOXIDE_PATH" ]; then
  export PATH="$ZOXIDE_PATH:$PATH"
fi
eval "$(zoxide init --cmd cd zsh)"
