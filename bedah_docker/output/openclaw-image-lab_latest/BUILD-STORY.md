# Build Story: openclaw-image-lab:latest

Ringkasan urutan build dari layer awal sampai akhir.

## Langkah 1

- **Perintah layer:** `ADD alpine-minirootfs-3.22.4-x86_64.tar.gz / # buildkit`
- **Makna:** Build dimulai dari base filesystem image dasar.

## Langkah 2

- **Perintah layer:** `CMD ["/bin/sh"]`
- **Makna:** Langkah build umum.

## Langkah 3

- **Perintah layer:** `apk add --no-cache     docker-cli     jq     bash     coreutils     file     tar`
- **Makna:** Tahap ini menginstall package/package penting ke image.

## Langkah 4

- **Perintah layer:** `#(nop) WORKDIR /work`
- **Makna:** Tahap ini menetapkan direktori kerja default.

## Langkah 5

- **Perintah layer:** `#(nop) COPY dir:8aa71b59f623cb36d0bb61927cfdcf77f38f559b77be4489929ae59c03a7e1cd in /work/scripts/ `
- **Makna:** Tahap ini menyalin source file atau script ke dalam image.

## Langkah 6

- **Perintah layer:** `chmod +x /work/scripts/inspect-image.sh`
- **Makna:** Tahap ini menyesuaikan permission file supaya bisa dipakai saat runtime.

## Langkah 7

- **Perintah layer:** `#(nop)  CMD ["sh"]`
- **Makna:** Tahap ini menetapkan command default saat container dijalankan.

## Langkah 8

- **Perintah layer:** `#(nop)  LABEL com.docker.compose.image.builder=classic`
- **Makna:** Tahap ini menambahkan metadata di akhir build.

