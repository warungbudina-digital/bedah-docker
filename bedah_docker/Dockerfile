FROM alpine:3.22

RUN apk add --no-cache \
    docker-cli \
    jq \
    bash \
    coreutils \
    file \
    tar

WORKDIR /work

COPY scripts/ /work/scripts/

RUN chmod +x /work/scripts/inspect-image.sh

CMD ["sh"]
