#!/usr/bin/env bash

function cd-work() {
	local selected # used to avoid selected to be global
	selected=$(ls -d "$WORK"/*/ | xargs -n1 basename | fzf --preview="git -C $WORK/{} log --oneline --color=always")
	if [ -n "$selected" ]; then
		cd "$WORK/$selected" || exit 1
	fi
}
