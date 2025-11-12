#!/usr/bin/env bash

function delete_branches() {
	git branch |
		grep --invert-match '\*' |
		cut -c 3- |
		fzf --multi --preview="git log --decorate --color=always --pretty=format:'%C(cyan)%h %C(white)- %C(red)%an%C(white), %C(blue)%ar %C(white)%s' {}" |
		xargs --no-run-if-empty git branch --delete --force
}
