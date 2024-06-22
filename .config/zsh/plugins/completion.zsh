#!/bin/zsh

zstyle ':completion:*' completer _extensions _complete _approximate

# Cache completion.
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"

# Add menu with possible completions.
zstyle ':completion:*' menu select

# Format style.
zstyle ':completion:*:descriptions' format '%F{green}%d%f'
zstyle ':completion:*:corrections' format '%F{red}!- %d (errors: %e) -!%f'

# Group completions.
zstyle ':completion:*' group-name ''
zstyle ':completion:*:-command-:*' group-order alias builtins functions commands
# Colors used by the ls command: directories, symbolic links, pipes, executables, matched.
LS_COLORS=${LS_COLORS:-'di=34:ln=35:pi=33:ex=31'}
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} "ma=48;5;244;1"

# List completion ordered by last change time.
zstyle ':completion:*' file-sort change
