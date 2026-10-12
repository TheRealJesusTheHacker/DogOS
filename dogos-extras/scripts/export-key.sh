#!/bin/bash
# Export the repo's public key for clients and verify repo integrity.
set -euo pipefail
REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
# grep finds nothing -> KEYID empty -> without this check gpg would die
# on a cryptic error under set -e instead of telling you what to fix.
# `|| true`: with set -o pipefail a missing SignWith line would make the
# pipeline fail and exit the script BEFORE the friendly check below runs.
KEYID="$(grep '^SignWith:' "$REPO_DIR/conf/distributions" | awk '{print $2}' || true)"
case "$KEYID" in
  ''|FILL-IN-SIGNING-KEY-ID)
    echo "set SignWith in conf/distributions first"; exit 1 ;;
esac
gpg --armor --export "$KEYID" > "$REPO_DIR/dogos-extras.asc"
reprepro -b "$REPO_DIR" check dogos
echo "public key -> $REPO_DIR/dogos-extras.asc"
