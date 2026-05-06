#!/bin/sh
set -eu

IMAGE="${1:-}"

if [ -z "$IMAGE" ]; then
  echo "Usage: ./scripts/full-analysis.sh <image:tag>"
  exit 1
fi

SLUG="$(printf '%s' "$IMAGE" | tr '/:' '__')"
OUT_DIR="output/$SLUG"
LEARN_FILE="$OUT_DIR/LEARN-ME.md"

mkdir -p "$OUT_DIR"

./scripts/export-image.sh "$IMAGE"
./scripts/reconstruct-dockerfile.sh "$IMAGE"
./scripts/explain-layers.sh "$IMAGE"
./scripts/build-story.sh "$IMAGE"

{
  echo "image=$IMAGE"
  docker image inspect "$IMAGE" --format 'repoTags={{json .RepoTags}}'
  docker image inspect "$IMAGE" --format 'created={{.Created}}'
  docker image inspect "$IMAGE" --format 'architecture={{.Architecture}}'
  docker image inspect "$IMAGE" --format 'os={{.Os}}'
  docker image inspect "$IMAGE" --format 'size={{.Size}}'
  docker image inspect "$IMAGE" --format 'workingDir={{.Config.WorkingDir}}'
  docker image inspect "$IMAGE" --format 'entrypoint={{json .Config.Entrypoint}}'
  docker image inspect "$IMAGE" --format 'cmd={{json .Config.Cmd}}'
  docker image inspect "$IMAGE" --format 'env={{json .Config.Env}}'
} > "$OUT_DIR/runtime-summary.txt"

{
  echo "# Learn Me: $IMAGE"
  echo
  echo "Panduan ini dibuat supaya image bisa dipelajari, bukan cuma diaudit."
  echo
  echo "## 1. Mulai dari runtime-summary.txt"
  echo "Lihat file ini dulu untuk memahami:"
  echo "- image ini jalan di OS/arsitektur apa"
  echo "- working directory-nya apa"
  echo "- entrypoint/cmd-nya apa"
  echo "- environment variable pentingnya apa"
  echo
  echo "## 2. Lanjut ke history.txt"
  echo "File ini menunjukkan urutan layer dan command build."
  echo "Dari sini Ayang bisa lihat:"
  echo "- kapan package diinstall"
  echo "- kapan file disalin"
  echo "- layer mana yang paling berat"
  echo
  echo "## 3. Lihat reconstructed.Dockerfile"
  echo "Ini kerangka Dockerfile hasil rekonstruksi."
  echo "Pakai ini sebagai titik awal kalau Ayang mau menulis ulang image."
  echo
  echo "## 4. Buka folder extracted/"
  echo "Di situ ada hasil extract image tar:"
  echo "- manifest.json"
  echo "- config image"
  echo "- layer tar per layer"
  echo
  echo "## 5. Tujuan akhir"
  echo "Setelah baca 4 file/folder di atas, Ayang biasanya bisa jawab:"
  echo "- image ini menjalankan apa?"
  echo "- image ini dibangun lewat urutan apa?"
  echo "- bagian mana yang paling penting untuk direplikasi?"
  echo "- bagaimana memulai membuat ulang image ini?"
  echo
  echo "## File utama"
  echo "- inspect.json"
  echo "- runtime-summary.txt"
  echo "- history.txt"
  echo "- reconstructed.Dockerfile"
  echo "- layer-explanations.md"
  echo "- BUILD-STORY.md"
  echo "- extracted/"
} > "$LEARN_FILE"

echo "Done: $OUT_DIR"
echo "Start here: $LEARN_FILE"
