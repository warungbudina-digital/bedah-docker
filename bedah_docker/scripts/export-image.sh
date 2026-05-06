#!/bin/sh
set -eu

IMAGE="${1:-}"

if [ -z "$IMAGE" ]; then
  echo "Usage: ./scripts/export-image.sh <image:tag>"
  exit 1
fi

SLUG="$(printf '%s' "$IMAGE" | tr '/:' '__')"
OUT_DIR="output/$SLUG"
EXTRACT_DIR="$OUT_DIR/extracted"

mkdir -p "$EXTRACT_DIR"

echo "[1/3] Saving image to tar..."
docker save "$IMAGE" -o "$OUT_DIR/image.tar"

echo "[2/3] Extracting image tar..."
tar -xf "$OUT_DIR/image.tar" -C "$EXTRACT_DIR"

echo "[3/3] Writing inspect metadata..."
docker image inspect "$IMAGE" > "$OUT_DIR/inspect.json"
docker history --no-trunc "$IMAGE" > "$OUT_DIR/history.txt"

echo "Done: $OUT_DIR"
