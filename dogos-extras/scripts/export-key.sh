#!/bin/bash
# Export the repo's public key for clients and verify repo integrity.
set -euo pipefail
REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
# grep finds nothing -> KEYID empty -> without this check gpg would die
# on a cryptic error under set -e instead of telling you what to fix.
# `|| true`: with set -o pipefail a missing SignWith line would make the
# pipeline fail and exit the script BEFORE the friendly check below runs.
# NR==1: a duplicated SignWith line would otherwise make KEYID a
# two-line string and gpg would fail on the whole blob, not a key id.
KEYID="$(grep '^SignWith:' "$REPO_DIR/conf/distributions" | awk 'NR==1 {print $2}' || true)"
case "$KEYID" in
  ''|FILL-IN-SIGNING-KEY-ID)
    echo "set SignWith in conf/distributions first"; exit 1 ;;
esac
# Export to a temp file and rename: a failing gpg (key missing, agent
# error) used to truncate the published .asc in place, leaving an
# empty/corrupt key file that looked like a successful export.
tmp_asc="$(mktemp "$REPO_DIR/.dogos-extras.asc.XXXXXX")"
trap 'rm -f "$tmp_asc"' EXIT
gpg --armor --export "$KEYID" > "$tmp_asc"
mv -f "$tmp_asc" "$REPO_DIR/dogos-extras.asc"
trap - EXIT
reprepro -b "$REPO_DIR" check dogos
echo "public key -> $REPO_DIR/dogos-extras.asc"
