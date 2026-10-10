#!/bin/bash
# fetch-seclists.sh — pull the full SecLists corpus (MIT licensed) on demand.
# The ISO ships starter lists only; run this on a live system or at build
# time when you want the complete wordlists.
# Usage: fetch-seclists.sh [destination]   (default: /usr/share/dogos/osint/wordlists/seclists)
set -euo pipefail
DEST="${1:-/usr/share/dogos/osint/wordlists/seclists}"
URL="https://github.com/danielmiessler/SecLists/archive/refs/heads/master.tar.gz"

echo "downloading SecLists to $DEST ..."
mkdir -p "$DEST"
curl -fsSL "$URL" | tar -xz -C "$DEST" --strip-components=1
echo "done. Corpus lives in $DEST (Discovery/, Usernames/, Passwords/, ...)"
echo "Starter lists remain alongside it; point your tools at either."
