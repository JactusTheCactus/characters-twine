#!/usr/bin/env bash
set -euo pipefail
shopt -s expand_aliases
flag() {
	for f in "$@"; do
		[[ -e ".flags/$f" ]] || return 1
	done
}
if flag local; then
	alias tweego=~/Apps/tweego-2.1.1-linux-x64/tweego
else
	npm ci
	alias sass="npx sass"
fi
{
	echo ":: StoryStylesheet [stylesheet]"
	sass src/.scss --no-source-map
} > "src/StoryStylesheet.tw"
tweego src -o index.html