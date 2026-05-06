# Layer Explanations: openclaw-image-lab:latest

Penjelasan otomatis tiap layer supaya lebih gampang dipelajari.

## Layer 1

- **Layer ID:** `sha256:d956b57abd87f7155931cb2753893c2d318893f44556846bacb588c2d169adad`
- **Size:** `0B`
- **CreatedBy:** `#(nop)  LABEL com.docker.compose.image.builder=classic`
- **Penjelasan:** Layer ini hanya menambah metadata image, bukan logika runtime utama.

## Layer 2

- **Layer ID:** `sha256:b9764f4d041be865d58e9f01f7c768d682d0b09e5ff0ae5622777781948be118`
- **Size:** `0B`
- **CreatedBy:** `#(nop)  CMD ["sh"]`
- **Penjelasan:** Layer ini menetapkan command default saat container dijalankan.

## Layer 3

- **Layer ID:** `sha256:4cb39d879d3f0738868938a392bdaaca6ffb0271ca92c07233ac82b0225aa645`
- **Size:** `548B`
- **CreatedBy:** `chmod +x /work/scripts/inspect-image.sh`
- **Penjelasan:** Layer ini mengubah permission file, biasanya supaya script/binary bisa dieksekusi.

## Layer 4

- **Layer ID:** `sha256:b30ebd5e99c8066de8b91e4d8eb0489f570897e63281c1d50433bdc1a268fa0f`
- **Size:** `12.4kB`
- **CreatedBy:** `#(nop) COPY dir:8aa71b59f623cb36d0bb61927cfdcf77f38f559b77be4489929ae59c03a7e1cd in /work/scripts/ `
- **Penjelasan:** Layer ini menyalin file atau folder dari build context ke dalam image.

## Layer 5

- **Layer ID:** `sha256:921e0981ddb5064b2d64abeb9cc15ab6386ce411c7acf2a6dba95bdf6ff5706d`
- **Size:** `0B`
- **CreatedBy:** `#(nop) WORKDIR /work`
- **Penjelasan:** Layer ini menetapkan direktori kerja default di image.

## Layer 6

- **Layer ID:** `sha256:e1a13b5d881eb677055041e4ccc2c6e965c42ac0363cee352c438c3379827501`
- **Size:** `48.1MB`
- **CreatedBy:** `apk add --no-cache     docker-cli     jq     bash     coreutils     file     tar`
- **Penjelasan:** Layer ini menginstall package ke image. Biasanya ikut menambah ukuran image cukup besar.

## Layer 7

- **Layer ID:** `sha256:9292219a28ffaeaa2dc461905c5c2d773bf49671f9c927c338c6f28ce08ac61b`
- **Size:** `0B`
- **CreatedBy:** `CMD ["/bin/sh"]`
- **Penjelasan:** Layer umum / perubahan filesystem.

## Layer 8

- **Layer ID:** `<missing>`
- **Size:** `8.32MB`
- **CreatedBy:** `ADD alpine-minirootfs-3.22.4-x86_64.tar.gz / # buildkit`
- **Penjelasan:** Layer ini kemungkinan berasal dari base filesystem image dasar.

