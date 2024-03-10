# Source aliases and env
source "$DOTFILES/.env"
source "$DOTFILES/.aliases"

# File to store history.
export HISTFILE="$XDG_CONFIG_HOME/zsh/.zhistory"
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

# Load and run completion.
autoload -U compinit; compinit
# Plugins.
source $ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
source $ZDOTDIR/plugins/completion.zsh
source $ZDOTDIR/plugins/cursor_mode.zsh

# Creates an alias for the cd command.
# ref: https://thevaluable.dev/zsh-install-configure-mouseless/
alias d='dirs -v | head -n 10'
for index ({0..9}) alias "$index"="cd +${index}"; unset index

# Activate vim mode with ESC.
bindkey -v
# Vim keybinding for completion. complist give access to the menuselct keymap.
zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# Add Homebrew to the PATH.
eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"

# Activate starship PS1 to define the primary prompt string.
eval "$(starship init zsh)"
