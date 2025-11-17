#!/usr/bin/env bash
set -euo pipefail
flag() {
	for f in "$@"; do
		[[ -e ".flags/$f" ]] || return 1
	done
}
if flag local; then
	rm -r dist
	tsc
	sass src/_.scss dist/_.css --no-source-map
	perl -0777 -pe 's/^[\S\s]+\/\/ BODY\n//g' dist/_.js > dist/_.js.tmp
	mv dist/_.js.tmp dist/_.js
	cp ../Characters.html dist/index.html
fi