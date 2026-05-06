#!/bin/sh
set -eu

IMAGE="${1:-}"

if [ -z "$IMAGE" ]; then
  echo "Usage: ./scripts/explain-layers.sh <image:tag>"
  exit 1
fi

SLUG="$(printf '%s' "$IMAGE" | tr '/:' '__')"
OUT_DIR="output/$SLUG"
OUT_FILE="$OUT_DIR/layer-explanations.md"

mkdir -p "$OUT_DIR"

{
  echo "# Layer Explanations: $IMAGE"
  echo
  echo "Penjelasan otomatis tiap layer supaya lebih gampang dipelajari."
  echo

  i=0
  docker history --no-trunc --format '{{.ID}}|{{.Size}}|{{.CreatedBy}}' "$IMAGE" | while IFS='|' read -r id size created_by; do
    i=$((i+1))
    clean="$(printf '%s' "$created_by" | sed 's#^/bin/sh -c ##')"
    note="Layer umum / perubahan filesystem."

    case "$clean" in
      *"apk add "*)
        note="Layer ini menginstall package ke image. Biasanya ikut menambah ukuran image cukup besar."
        ;;
      *"#(nop) COPY "*)
        note="Layer ini menyalin file atau folder dari build context ke dalam image."
        ;;
      *"#(nop) ADD "*)
        note="Layer ini menambahkan file ke image. Kadang dipakai untuk ekstraksi tar atau file tambahan."
        ;;
      *"#(nop)  ENV "*)
        note="Layer ini menetapkan environment variable untuk build lanjutan atau runtime container."
        ;;
      *"#(nop) WORKDIR "*)
        note="Layer ini menetapkan direktori kerja default di image."
        ;;
      *"#(nop)  CMD "*)
        note="Layer ini menetapkan command default saat container dijalankan."
        ;;
      *"#(nop)  ENTRYPOINT "*)
        note="Layer ini menetapkan entrypoint utama container."
        ;;
      *"#(nop)  LABEL "*)
        note="Layer ini hanya menambah metadata image, bukan logika runtime utama."
        ;;
      *"chmod "*)
        note="Layer ini mengubah permission file, biasanya supaya script/binary bisa dieksekusi."
        ;;
      *"ADD "*rootfs*|*"ADD "*buildkit*)
        note="Layer ini kemungkinan berasal dari base filesystem image dasar."
        ;;
    esac

    echo "## Layer $i"
    echo
    echo "- **Layer ID:** \`$id\`"
    echo "- **Size:** \`$size\`"
    echo "- **CreatedBy:** \`$clean\`"
    echo "- **Penjelasan:** $note"
    echo
  done
} > "$OUT_FILE"

echo "Done: $OUT_FILE"
