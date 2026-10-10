#!/bin/bash
# Export the repo's public key for clients and verify repo integrity.
set -euo pipefail
REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
KEYID="$(grep '^SignWith:' "$REPO_DIR/conf/distributions" | awk '{print $2}')"
[ "$KEYID" != "FILL-IN-SIGNING-KEY-ID" ] || { echo "set SignWith in conf/distributions first"; exit 1; }
gpg --armor --export "$KEYID" > "$REPO_DIR/dogos-extras.asc"
reprepro -b "$REPO_DIR" check dogos
echo "public key -> $REPO_DIR/dogos-extras.asc"
