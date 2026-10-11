#!/bin/bash
# fetch-seclists.sh — pull the full SecLists corpus (MIT licensed) on demand.
# The ISO ships starter lists only; run this on a live system or at build
# time when you want the complete wordlists.
# Usage: fetch-seclists.sh [destination]   (default: /usr/share/dogos/osint/wordlists/seclists)
set -euo pipefail
# Pinned to a specific upstream commit: GitHub serves immutable tarballs for
# commit SHAs, so the fetched corpus can't silently drift or be swapped.
# Bump deliberately — check the commit, then update SECLISTS_COMMIT.
SECLISTS_COMMIT="cae9eab995852c183fbe5e03fc92471fcac82f0e"  # master as of 2026-10-10
DEST="${1:-/usr/share/dogos/osint/wordlists/seclists}"
URL="https://github.com/danielmiessler/SecLists/archive/${SECLISTS_COMMIT}.tar.gz"

echo "downloading SecLists ($SECLISTS_COMMIT) to $DEST ..."
mkdir -p "$DEST"
archive="$(mktemp /tmp/seclists.XXXXXX.tar.gz)"
trap 'rm -f "$archive"' EXIT
curl -fsSL "$URL" -o "$archive"
tar -xz -f "$archive" -C "$DEST" --strip-components=1
echo "done. Corpus lives in $DEST (Discovery/, Usernames/, Passwords/, ...)"
echo "Starter lists remain alongside it; point your tools at either."
