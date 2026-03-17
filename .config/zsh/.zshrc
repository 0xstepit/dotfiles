# Source aliases and env
source "$HOME/.env"
source "$HOME/.aliases"
source "$HOME/.cargo/env"

# Source functions
# source "$HOME/.config/scripts/main.sh"

SCRIPT_DIR="$HOME/.config/scripts"
if [[ -d "$SCRIPT_DIR" ]]; then
	for script in $SCRIPT_DIR/*.sh; do
		[[ -f "$script" ]] && source "$script"
	done
fi

# source "$HOME/.config/scripts/vim-fuzzy.sh"
# source "$HOME/.config/scripts/cd-old-dirs.sh"
# source "$HOME/.config/scripts/delete-branches.sh"
# source "$HOME/.config/scripts/cd-work.sh"
# source "$HOME/.config/scripts/pr-checkout.sh"

# File to store history.

export HISTFILE="$XDG_CACHE_HOME/zsh/.zhistory"
# Maximum events for internal history buffer in memory.
export HISTSIZE=10000
# Maximum events for internal history saved in the history file. 
export SAVEHIST=10000
# History options.
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS

# Directory stack options.
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt share_history

# Docker completions
fpath=(/Users/stepit/.docker/completions $fpath)

# Load and run completion.
autoload -U compinit; compinit
# Plugins.
source "$ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh"
source "$ZDOTDIR/plugins/completion.zsh"
source "$ZDOTDIR/plugins/cursor_mode.zsh"
# source $ZDOTDIR/plugins/poetry

zmodload zsh/complist

# Activate vim mode with ESC.
bindkey -v
bindkey -M viins 'jk' vi-cmd-mode # remap exit to jj

# Vim keybinding for completion. complist give access to the menuselct keymap.
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# Required to have backspace working in vim
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^?' backward-delete-char

# Yank to the system clipboard
function vi-yank-xclip {
   zle vi-yank
   echo "$CUTBUFFER" | pbcopy -i
}
zle -N vi-yank-xclip
bindkey -M vicmd 'y' vi-yank-xclip

# Activate starship PS1 to define the primary prompt string.
eval "$(starship init zsh)"

# pipx configuration.
eval "$(register-python-argcomplete pipx)"

# fzf configuration.
eval "$(fzf --zsh)"
export FZF_DEFAULT_COMMAND="fd \
--type file \
--follow \
--hidden \
--exclude .git"
# --exclude plugins"
export FZF_DEFAULT_OPTS="--height=40% \
--layout=reverse \
--pointer='' \
--marker='┃' \
--border=rounded \
--prompt='  '"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
bindkey '^E' fzf-cd-widget
source "$HOME/.config/zsh/fzf-flow-eclipse.sh"

bindkey -M emacs '\ec' fzf-cd-widget
bindkey -M vicmd '\ec' fzf-cd-widget
bindkey -M viins '\ec' fzf-cd-widget

# Bun completions
[ -s "/Users/stepit/.bun/_bun" ] && source "/Users/stepit/.bun/_bun"

# pnpm
export PNPM_HOME="/Users/stepit/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# gpg
GPG_TTY=$(tty)
export GPG_TTY
# gpg end

# Here we do some optimization in zsh starting time by lazy loading
# nvm. I need this becuase the starting time arrived to be ~2s :S
export NVM_DIR="$HOME/.config/nvm"
nvm() {
    # Better to avoid infinite recursion loop.
    unfunction nvm node npm npx 2>/dev/null
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    nvm "$@"
}
node() {
    nvm use default >/dev/null; node "$@" 
}
npm() {
    nvm use default >/dev/null; npm "$@" 
}
npx() {
    nvm use default >/dev/null; npx "$@" 
}

export PATH="$PATH:/Users/stepit/.sp1/bin"

eval "$(zoxide init zsh)"

# !! Contents within this block are managed by 'conda init' !!
conda() {
    unfunction conda 2>/dev/null
    __conda_setup="$('/Users/stepit/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/Users/stepit/miniforge3/etc/profile.d/conda.sh" ]; then
            . "/Users/stepit/miniforge3/etc/profile.d/conda.sh"
        else
            export PATH="/Users/stepit/miniforge3/bin:$PATH"
        fi
    fi
unset __conda_setup
}

# For the path $(brew --prefix llvm)
export CC=/opt/homebrew/opt/llvm/bin/clang
export CXX=/opt/homebrew/opt/llvm/bin/clang++
export LDFLAGS="-L/opt/homebrew/opt/libomp/lib"
export CPPFLAGS="-I/opt/homebrew/opt/libomp/include"
