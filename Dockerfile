FROM alpine:3.14


LABEL maintainer="Alpine的Docker镜像 <storezhang@gmail.com>"
LABEL architecture="AMD64/x86_64" version="3.14" build="2021-10-14"
LABEL Description="Alpine镜像，增加时间配置以及守护进程"


ENV LANG="zh_CN.UTF-8"
ENV TIMEZONE=/Asia/Chongqing


RUN set -ex \
    \
    \
    \
    && sed -i "s/dl-cdn\.alpinelinux\.org/mirrors.ustc.edu.cn/" /etc/apk/repositories \
    && apk update \
    && apk --no-cache add tzdata su-exec bash s6 \
    \
    \
    \
    && cp "/usr/share/zoneinfo/${TIMEZONE}" /etc/localtime \
    && echo "${TIMEZONE}" > /etc/timezone \
    && echo "export LC_ALL=${LANG}" >> /etc/profile \
    \
    \
    \
    && rm -rf /var/cache/apk/*
