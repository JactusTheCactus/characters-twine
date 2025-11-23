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
mkdir -p dist
rm dist/*
YML="$(cat src/data.yml)"
JSON="$(echo "$YML" | yq -o=json ".")"
if ! flag local; then
	JSON="$(echo "$JSON" | jq "del(.characters._)")"
fi
echo "$JSON" > "src/data.json"
{
	echo ":: StoryStylesheet [stylesheet]"
	sass src/.scss --no-source-map
} > "dist/css.tw"
{
	tmp="$(mktemp)"
	echo ":: StoryScript [script]"
	tsc src/_.ts --outFile "$tmp" --lib esnext,dom
	cat "$tmp"
	rm "$tmp"
} > "dist/js.tw"
{
	echo ":: StoryTitle"
	cat src/data.json | jq -r ".title"
	echo ":: StoryData"
	cat src/data.json | jq ".init"
} > "dist/.tw"
readarray -t CHAR < <(cat src/data.json | jq -r ".characters | keys[]")
LEN="$(cat src/data.json | jq ".characters | length")"
{
	echo ":: Main"
	echo "Please choose one of these ''$LEN'' characters:"
} > "dist/main.tw"
for c in "${CHAR[@]}"; do
	echo -e ":: $c [character]\n<<char \"$c\">>" > "dist/$c.tw"
	echo "# [[${c^}|$c]]" >> dist/main.tw
done
cp src/*.tw dist
tweego dist -o index.html