#!/usr/bin/env bash

vf() {
	local dir
	dir=$(fzf)
	[[ -n "$dir" ]] && eval NVIM_APPNAME=nvim-new nvim "$dir"
}
