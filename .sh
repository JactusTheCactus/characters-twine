#!/usr/bin/env bash
set -euo pipefail
flag() {
	for f in "$@"; do
		[[ -e ".flags/$f" ]] || return 1
	done
}
if flag local; then
	tweego="/home/devin/Apps/tweego-2.1.1-linux-x64/tweego"
	rm index.html
	echo ":: StoryStylesheet [stylesheet]" > src/StoryStylesheet.tw
	sass src/.scss --no-source-map >> src/StoryStylesheet.tw
	$tweego src -o index.html
fi