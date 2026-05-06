#!/bin/sh
set -eu

TAG="${1:-}"
BUILD_DIR="${2:-.}"
WRAPPER_IMAGE="openclaw-dive-wrapper:latest"

if [ -z "$TAG" ]; then
  echo "Usage: ./scripts/dive-build.sh <image:tag> [build-dir]"
  exit 1
fi

ABS_DIR="$(cd "$BUILD_DIR" && pwd)"

if ! docker image inspect "$WRAPPER_IMAGE" >/dev/null 2>&1; then
  docker build -f Dockerfile.dive -t "$WRAPPER_IMAGE" .
fi

exec docker run --rm -it \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$ABS_DIR:$ABS_DIR" \
  -w "$ABS_DIR" \
  "$WRAPPER_IMAGE" build -t "$TAG" .
