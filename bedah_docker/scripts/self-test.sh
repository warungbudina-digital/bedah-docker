#!/bin/sh
set -eu

IMAGE="openclaw-image-lab:latest"

echo "[1/5] Build helper image..."
docker compose build >/tmp/openclaw-image-lab-build.log 2>&1

echo "[2/5] Test inspect dasar..."
docker compose run --rm image-lab sh /work/scripts/inspect-image.sh "$IMAGE" >/tmp/openclaw-image-lab-inspect.log 2>&1

echo "[3/5] Test dive CI..."
./scripts/dive-ci.sh "$IMAGE" >/tmp/openclaw-image-lab-dive-ci.log 2>&1

echo "[4/5] Test mode PRO..."
./scripts/full-analysis.sh "$IMAGE" >/tmp/openclaw-image-lab-full-analysis.log 2>&1

echo "[5/5] Verifikasi output..."
SLUG="openclaw-image-lab_latest"
test -f "output/$SLUG/LEARN-ME.md"
test -f "output/$SLUG/layer-explanations.md"
test -f "output/$SLUG/BUILD-STORY.md"
test -f "output/$SLUG/reconstructed.Dockerfile"

echo "PASS"
echo "Logs:"
echo "- /tmp/openclaw-image-lab-build.log"
echo "- /tmp/openclaw-image-lab-inspect.log"
echo "- /tmp/openclaw-image-lab-dive-ci.log"
echo "- /tmp/openclaw-image-lab-full-analysis.log"
