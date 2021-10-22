FROM alpine:3.14


LABEL maintainer="Alpine的Docker镜像 <storezhang@gmail.com>"
LABEL architecture="AMD64/x86_64" version="3.14" build="2021-10-14"
LABEL Description="Alpine镜像，增加时间配置以及守护进程"


ENV LANG="zh_CN.UTF-8"
ENV TIMEZONE=/Asia/Chongqing

# 延迟启动
ENV DELAY 1s


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
    # 链接X64库，不然无法运行64位程序 \
    && mkdir /lib64 \
    && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2 \
    \
    \
    \
    && rm -rf /var/cache/apk/*
