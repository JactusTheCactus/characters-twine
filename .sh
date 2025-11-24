#!/usr/bin/env bash
set -euo pipefail
shopt -s expand_aliases
test() {
	echo "=========="
}
flag() {
	for f in "$@"; do
		if [[ "$f" = "new" ]]; then
			continue
		fi
		if [[ ! -e ".flags/$f" ]]; then
			return 1
		fi
	done
}
if flag local; then
	alias tweego=~/Apps/tweego-2.1.1-linux-x64/tweego
else
	npm ci
	alias sass="npx sass"
	alias tsc="npx tsc"
	alias prettier="npx prettier"
fi
mkdir -p dist
rm dist/*
YML="$(cat src/data.yml)"
JSON="$(echo "$YML" | yq -o=json ".")"
#if ! flag local; then
	#JSON="$(echo "$JSON" | jq "del(.characters._)")"
#fi
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
mkdir -p characters
for c in "${CHAR[@]}"; do
	echo -e ":: $c [character]\n<<char \"$c\">>" > "dist/characters/$c.tw"
	echo "# [[${c^}|$c]]" >> dist/main.tw
done
cp src/*.tw dist
tweego dist -o index.html
prettier src --write