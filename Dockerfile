FROM alpine:3.10

LABEL maintainer="Alpine docker maintainers <storezhang@gmail.com>"
LABEL architecture="AMD64/x86_64" version="latest" build="2019-07-26"
LABEL Description="Alpine镜像。"

ENV LANG="zh_CN.UTF-8"
ENV TIMEZONE=/Asia/Chongqing

ENV GOSU_VERSION="1.11" \
    GOSU_DOWNLOAD_URL="https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64" \
    GOSU_DOWNLOAD_SIG="https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64.asc" \
    GOSU_DOWNLOAD_KEY="0x036A9C25BF357DD4"

RUN buildDeps='curl gnupg' HOME='/root' \
    && set -x \
    && echo 'https://mirrors.ustc.edu.cn/alpine/v3.10/main'>/etc/apk/repositories \
    && echo 'https://mirrors.ustc.edu.cn/alpine/v3.10/community'>>/etc/apk/repositories \
    && apk update \

    && apk --no-cache add --update $buildDeps \
    && gpg-agent --daemon \
    && gpg --keyserver pgp.mit.edu --recv-keys $GOSU_DOWNLOAD_KEY \
    && echo "trusted-key $GOSU_DOWNLOAD_KEY" >> /root/.gnupg/gpg.conf \
    && curl -sSL "$GOSU_DOWNLOAD_URL" > gosu-amd64 \
    && curl -sSL "$GOSU_DOWNLOAD_SIG" > gosu-amd64.asc \
    && gpg --verify gosu-amd64.asc \
    && rm -f gosu-amd64.asc \
    && mv gosu-amd64 /usr/bin/gosu \
    && chmod +x /usr/bin/gosu \
    && apk del --purge $buildDeps \
    && rm -rf /root/.gnupg \

    && apk --no-cache add tzdata \
    && cp "/usr/share/zoneinfo/${TIMEZONE}" /etc/localtime \
    && echo "${TIMEZONE}" > /etc/timezone \
    && echo "export LC_ALL=${LANG}" >> /etc/profile \
    && rm -rf /var/cache/apk/*
