#!/bin/zsh

# ref: https://thevaluable.dev/zsh-install-configure-mouseless/
cursor_mode() {
    # ANSI escape sequences that are interpreted by the terminal
    # emulator to change the cursor style.
    cursor_block='\e[2 q'
    cursor_beam='\e[6 q'

    # Executed every time the keymap changes.
    function zle-keymap-select {
        if [[ ${KEYMAP} == vicmd ]] ||
            [[ $1 = 'block' ]]; then
            echo -ne $cursor_block
        elif [[ ${KEYMAP} == main ]] ||
            [[ ${KEYMAP} == viins ]] ||
            [[ ${KEYMAP} = '' ]] ||
            [[ $1 = 'beam' ]]; then
            echo -ne $cursor_beam
        fi
    }
    # Executed every time the line editor is started to read a new line of input.
    zle-line-init() {
        echo -ne $cursor_beam
    }
    # Register as widget for zle.
    zle -N zle-keymap-select
    zle -N zle-line-init
}

cursor_mode
