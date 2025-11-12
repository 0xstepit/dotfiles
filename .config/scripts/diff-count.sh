#!/usr/bin/env bash

diff_count() {
	output=$(git diff --name-status main)
	m_count=$(echo "$output" | grep -E '^[[:space:]]*M' -c)
	a_count=$(echo "$output" | grep -E '^[[:space:]]*A' -c)
	d_count=$(echo "$output" | grep -E '^[[:space:]]*D' -c)
	echo "Changes M: $m_count, A: $a_count, D: $d_count"
}
