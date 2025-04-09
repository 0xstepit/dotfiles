# Source aliases and env
source "$HOME/.env"
source "$HOME/.aliases"
source "$HOME/.cargo/env"

# File to store history.

export HISTFILE="$XDG_CACHE_HOME/zsh/.zhistory"
# Maximum events for internal history buffer in memory.
export HISTSIZE=10000
# Maximum events for internal history saved in the history file. 
export SAVEHIST=10000
# History options.
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS

# Directory stack options. setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt share_history

# Load and run completion.
autoload -U compinit; compinit
# Plugins.
source $ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
source $ZDOTDIR/plugins/completion.zsh
source $ZDOTDIR/plugins/cursor_mode.zsh
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

 # # Activate NIX.
 # if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
 #    . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
 # fi

# fzf configuration.
eval "$(fzf --zsh)"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git --exclude plugins/'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
bindkey '^E' fzf-cd-widget
source "$HOME/.config/zsh/fzf-flow-eclipse.sh"

# Bun completions
[ -s "/Users/stepit/.bun/_bun" ] && source "/Users/stepit/.bun/_bun"

# Docker completions
fpath=(/Users/stepit/.docker/completions $fpath)
autoload -Uz compinit
compinit
