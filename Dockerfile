FROM alpine:3.9

LABEL maintainer="Alpine docker maintainers <storezhang@gmail.com>"
LABEL architecture="AMD64/x86_64" version="latest" build="2019-07-26"
LABEL Description="Alpine镜像。"

ENV LANG="zh_CN.UTF-8"
ENV TIMEZONE=/Asia/Chongqing

RUN set -x \
    && echo 'https://mirrors.ustc.edu.cn/alpine/v3.9/main'>/etc/apk/repositories \
    && echo 'https://mirrors.ustc.edu.cn/alpine/v3.9/community'>>/etc/apk/repositories \
    && apk update \
    && apk --no-cache add tzdata \
    && cp "/usr/share/zoneinfo/${TIMEZONE}" /etc/localtime \
    && echo "${TIMEZONE}" > /etc/timezone \
    && echo "export LC_ALL=${LANG}" >> /etc/profile \
    && rm -rf /var/cache/apk/*
