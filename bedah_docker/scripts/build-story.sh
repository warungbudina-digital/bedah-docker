#!/bin/sh
set -eu

IMAGE="${1:-}"

if [ -z "$IMAGE" ]; then
  echo "Usage: ./scripts/build-story.sh <image:tag>"
  exit 1
fi

SLUG="$(printf '%s' "$IMAGE" | tr '/:' '__')"
OUT_DIR="output/$SLUG"
OUT_FILE="$OUT_DIR/BUILD-STORY.md"

mkdir -p "$OUT_DIR"

{
  echo "# Build Story: $IMAGE"
  echo
  echo "Ringkasan urutan build dari layer awal sampai akhir."
  echo

  idx=0
  docker history --no-trunc --format '{{.CreatedBy}}' "$IMAGE" | tac | while IFS= read -r line; do
    idx=$((idx+1))
    clean="$(printf '%s' "$line" | sed 's#^/bin/sh -c ##')"
    story="Langkah build umum."

    case "$clean" in
      *"ADD "*rootfs*|*"ADD "*buildkit*)
        story="Build dimulai dari base filesystem image dasar."
        ;;
      *"apk add "*)
        story="Tahap ini menginstall package/package penting ke image."
        ;;
      *"#(nop) COPY "*)
        story="Tahap ini menyalin source file atau script ke dalam image."
        ;;
      *"#(nop) ADD "*)
        story="Tahap ini menambahkan file tambahan ke image."
        ;;
      *"#(nop) WORKDIR "*)
        story="Tahap ini menetapkan direktori kerja default."
        ;;
      *"#(nop)  ENV "*)
        story="Tahap ini menetapkan environment variable."
        ;;
      *"chmod "*)
        story="Tahap ini menyesuaikan permission file supaya bisa dipakai saat runtime."
        ;;
      *"#(nop)  CMD "*)
        story="Tahap ini menetapkan command default saat container dijalankan."
        ;;
      *"#(nop)  ENTRYPOINT "*)
        story="Tahap ini menetapkan entrypoint utama container."
        ;;
      *"#(nop)  LABEL "*)
        story="Tahap ini menambahkan metadata di akhir build."
        ;;
    esac

    echo "## Langkah $idx"
    echo
    echo "- **Perintah layer:** \`$clean\`"
    echo "- **Makna:** $story"
    echo
  done
} > "$OUT_FILE"

echo "Done: $OUT_FILE"
