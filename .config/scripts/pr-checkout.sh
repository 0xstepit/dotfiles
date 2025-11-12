#!/usr/bin/env bash

function pr-checkout() {
	set -u # treat undef variables as errors

	# Check if git repo by searching for the .git file.
	if ! git rev-parse --git-dir &>/dev/null; then
		echo "Error: not a git repository" >&2
		return 1
	fi

	local origin
	origin=$(git config --get remote.origin.url)
	if [ -z "$origin" ]; then
		echo "origin branch for git repository not found" && return 1
	fi

	local owner_and_repo
	owner_and_repo=$(echo "$origin" | sed 's/.*github\.com[:/]\(.*\)\.git/\1/')

	local owner
	owner=$(echo "$owner_and_repo" | cut -d'/' -f1)

	local repo
	repo=$(echo "$owner_and_repo" | cut -d'/' -f2)

	local pr_number
	pr_number=$(
		gh api 'repos/:owner/:repo/pulls' |
			jq --raw-output '.[] | "#\(.number) \(.title) (@\(.user.login))"' |
			fzf --prompt="Select PR: " \
				--preview='gh pr view {1} | sed "s/^#//"' | # {1} refer to the first element of the provided string split at whitespaces refer to the first element of the provided string split at whitespaces
			sed -E 's/^#([0-9]+).*/\1/'
	)

	if [ -n "$pr_number" ]; then
		gh pr checkout "$pr_number"
	fi
}
