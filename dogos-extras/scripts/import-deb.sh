#!/bin/bash
# Import a .deb into the dogos-extras repo.
# Usage: ./scripts/import-deb.sh /path/to/package_1.0_amd64.deb
set -euo pipefail
REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
[ $# -eq 1 ] || { echo "usage: import-deb.sh <package.deb>"; exit 1; }
[ -f "$1" ] || { echo "error: no such file: $1"; exit 1; }
case "$1" in *.deb) ;; *) echo "error: not a .deb file: $1"; exit 1;; esac
reprepro -b "$REPO_DIR" includedeb dogos "$1"
echo "imported $1 — remember to re-export the public key after first import"
