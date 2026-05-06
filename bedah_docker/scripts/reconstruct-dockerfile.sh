#!/bin/sh
set -eu

IMAGE="${1:-}"

if [ -z "$IMAGE" ]; then
  echo "Usage: ./scripts/reconstruct-dockerfile.sh <image:tag>"
  exit 1
fi

SLUG="$(printf '%s' "$IMAGE" | tr '/:' '__')"
OUT_DIR="output/$SLUG"
OUT_FILE="$OUT_DIR/reconstructed.Dockerfile"

mkdir -p "$OUT_DIR"

{
  echo "# Reconstructed from: $IMAGE"
  echo "# WARNING: ini rekonstruksi perkiraan dari docker history."
  echo "# Tidak selalu sama persis dengan Dockerfile asli."
  echo
  echo "# Base image asli tidak selalu bisa dipulihkan akurat dari image lokal."
  echo "# Isi FROM secara manual setelah Ayang review history / manifest."
  echo "FROM <base-image-manual>"
  echo
  docker history --no-trunc --format '{{.CreatedBy}}' "$IMAGE" | tac | while IFS= read -r line; do
    clean="$(printf '%s' "$line" | sed 's#^/bin/sh -c ##')"

    case "$clean" in
      *"#(nop)  CMD "*)
        val="$(printf '%s\n' "$clean" | awk '{sub(/^.*#\\(nop\\)  CMD /,""); print}')"
        printf 'CMD %s\n' "$val"
        ;;
      *"#(nop)  ENTRYPOINT "*)
        val="$(printf '%s\n' "$clean" | awk '{sub(/^.*#\\(nop\\)  ENTRYPOINT /,""); print}')"
        printf 'ENTRYPOINT %s\n' "$val"
        ;;
      *"#(nop)  ENV "*)
        val="$(printf '%s\n' "$clean" | awk '{sub(/^.*#\\(nop\\)  ENV /,""); print}')"
        printf 'ENV %s\n' "$val"
        ;;
      *"#(nop) WORKDIR "*)
        val="$(printf '%s\n' "$clean" | awk '{sub(/^.*#\\(nop\\) WORKDIR /,""); print}')"
        printf 'WORKDIR %s\n' "$val"
        ;;
      *"#(nop) COPY "*)
        echo "# COPY step ditemukan, tapi source aslinya tidak selalu bisa dipulihkan:"
        val="$(printf '%s\n' "$clean" | awk '{sub(/^.*#\\(nop\\) COPY /,""); print}')"
        printf '# COPY %s\n' "$val"
        ;;
      *"#(nop) ADD "*)
        echo "# ADD step ditemukan, tapi source aslinya tidak selalu bisa dipulihkan:"
        val="$(printf '%s\n' "$clean" | awk '{sub(/^.*#\\(nop\\) ADD /,""); print}')"
        printf '# ADD %s\n' "$val"
        ;;
      *"#(nop)  LABEL "*)
        val="$(printf '%s\n' "$clean" | awk '{sub(/^.*#\\(nop\\)  LABEL /,""); print}')"
        printf '# LABEL %s\n' "$val"
        ;;
      "")
        ;;
      *)
        printf 'RUN %s\n' "$clean"
        ;;
    esac
    echo
  done
} > "$OUT_FILE"

echo "Done: $OUT_FILE"
