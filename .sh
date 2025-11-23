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
	alias tsc="npx tsc"
fi
(
	cd src
	YML="$(cat data.yml)"
	JSON="$(echo "$YML" | yq -o=json ".")"
	echo "$JSON" > data.json
	getData() {
		cat data.json | jq "$1"
	}
	{
		echo ":: StoryStylesheet [stylesheet]"
		sass .scss --no-source-map
	} > css.tw
	{
		tmp="$(mktemp)"
		echo ":: StoryScript [script]"
		tsc _.ts --outFile "$tmp" --lib esnext,dom
		cat "$tmp"
		rm "$tmp"
	} > js.tw
	{
		cat << EOF
:: StoryTitle
Characters

:: StoryData
EOF
		getData ".init"
	} > .tw
)
tweego src -o index.html