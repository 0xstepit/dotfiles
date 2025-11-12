#!/usr/bin/env bash

# CD to receint dir using fzf UI.
d() {
	local dir
	dir=$(dirs -l -p | fzf)
	if [ -n "$dir" ]; then
		cd "$dir"
	fi
}
