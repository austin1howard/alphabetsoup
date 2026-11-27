#!/usr/bin/env bash
# Usage: run.sh <lang>
# Follows plugins/<lang>/skills/scaffold in a temp dir using the real templates, then runs
# `make fmt && make check`. DOCKER_BUILD=1 also builds the image; KEEP=1 keeps the temp dir.
set -euo pipefail
lang=$1
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
T=$ROOT/plugins/$lang/skills/scaffold/templates
F=$ROOT/tests/templates/$lang
W=$(mktemp -d "${TMPDIR:-/tmp}/alphabetsoup-$lang.XXXX")
[[ -n ${KEEP:-} ]] && echo "keeping $W" || trap 'rm -rf "$W"' EXIT

# fill <template> <dest>: copy a template with placeholders substituted
fill() { sed -e "s/{{name}}/demo/g" -e "s/{{pkg}}/demo/g" -e "s/{{go-version}}/${GO_MM:-}/g" "$T/$1" > "$2"; }

echo "▶ $lang: scaffold in $W"
cd "$W"
# shellcheck source=/dev/null
source "$F/scaffold.sh"   # may cd into the project dir
make fmt >/dev/null
make check
if [[ -n ${DOCKER_BUILD:-} ]]; then make docker-build IMAGE="alphabetsoup-test-$lang"; fi
echo "✔ $lang"
