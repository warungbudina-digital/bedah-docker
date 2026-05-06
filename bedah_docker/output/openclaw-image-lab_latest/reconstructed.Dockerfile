# Reconstructed from: openclaw-image-lab:latest
# WARNING: ini rekonstruksi perkiraan dari docker history.
# Tidak selalu sama persis dengan Dockerfile asli.

# Base image asli tidak selalu bisa dipulihkan akurat dari image lokal.
# Isi FROM secara manual setelah Ayang review history / manifest.
FROM <base-image-manual>

RUN ADD alpine-minirootfs-3.22.4-x86_64.tar.gz / # buildkit

RUN CMD ["/bin/sh"]

RUN apk add --no-cache     docker-cli     jq     bash     coreutils     file     tar

WORKDIR #(nop) WORKDIR /work

# COPY step ditemukan, tapi source aslinya tidak selalu bisa dipulihkan:
# COPY #(nop) COPY dir:8aa71b59f623cb36d0bb61927cfdcf77f38f559b77be4489929ae59c03a7e1cd in /work/scripts/ 

RUN chmod +x /work/scripts/inspect-image.sh

CMD #(nop)  CMD ["sh"]

# LABEL #(nop)  LABEL com.docker.compose.image.builder=classic

