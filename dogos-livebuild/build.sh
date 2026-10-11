#!/bin/bash
# Build a DogOS ISO flavor.
# Usage: ./build.sh [full|lite]   (default: full)
# Needs: live-build installed, root for `lb build`, ~25 GB free for full.
set -euo pipefail

FLAVOR="${1:-full}"
SRC="$(cd "$(dirname "$0")" && pwd)"
BUILD="/tmp/dogos-build-$FLAVOR"

[ "$FLAVOR" = "full" ] || [ "$FLAVOR" = "lite" ] || {
  echo "usage: build.sh [full|lite]"; exit 1; }

echo "assembling flavor '$FLAVOR' in $BUILD ..."
rm -rf "$BUILD" && mkdir -p "$BUILD"
tar -cf - --exclude='./flavors' -C "$SRC" . | tar -xf - -C "$BUILD"
if [ "$FLAVOR" = "lite" ]; then
  cp -r "$SRC/flavors/lite/." "$BUILD/"
fi

cd "$BUILD"
./auto/config
echo ""
echo "configured: flavor=$FLAVOR"
echo "next step:  cd $BUILD && sudo lb build"
echo "then rename the output ISO (3.x has no --image-name):"
echo "  mv live-image-*.iso dogos-$FLAVOR.iso"
