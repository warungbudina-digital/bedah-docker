#!/bin/sh
set -eu

IMAGE="${1:-}"
WRAPPER_IMAGE="openclaw-dive-wrapper:latest"

if [ -z "$IMAGE" ]; then
  echo "Usage: ./scripts/dive-ci.sh <image:tag>"
  exit 1
fi

if ! docker image inspect "$WRAPPER_IMAGE" >/dev/null 2>&1; then
  docker build -f Dockerfile.dive -t "$WRAPPER_IMAGE" .
fi

exec docker run --rm \
  -e CI=true \
  -v /var/run/docker.sock:/var/run/docker.sock \
  "$WRAPPER_IMAGE" "$IMAGE" --ci-config /root/.dive-ci
