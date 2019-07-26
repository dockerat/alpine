FROM alpine:3.9

MAINTAINER storezhang "storezhang@gmail.com"
LABEL architecture="AMD64/x86_64" version="latest" build="2019-03-14"

ENV LANG="zh_CN.UTF-8"

RUN set -x \
    && apk update \
    && apk --no-cache add tzdata \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && echo "export LC_ALL=zh_CN.UTF-8" >> /etc/profile \
    && rm -rf /var/cache/apk/*