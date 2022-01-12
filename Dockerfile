FROM storezhang/alpine AS chinese

WORKDIR /opt/chinese

RUN apk --no-cache add ca-certificates wget
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
RUN wget https://ghproxy.com/https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.30-r0/glibc-2.30-r0.apk
RUN wget https://ghproxy.com/https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.30-r0/glibc-bin-2.30-r0.apk
RUN wget https://ghproxy.com/https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.30-r0/glibc-i18n-2.30-r0.apk





FROM alpine:3.15


LABEL author="storezhang<华寅>"
LABEL email="storezhang@gmail.com"
LABEL architecture="AMD64/x86_64" version="3.14" build="2022-01-11"
LABEL description="Alpine镜像，增加时间配置以及守护进程"


# 定义时区
ENV TIMEZONE Asia/Chongqing

# 增加中文支持，不然命令行执行程序会报错
ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8

# 设置运行用户及组
ENV UMASK 022
ENV USERNAME storezhang
ENV UID 1000
ENV GID 1000

# 延迟启动
ENV DELAY 1s


# 定义公共配置卷
VOLUME /config
WORKDIR /config


# 复制文件
COPY --from=chinese /opt/chinese /opt/chinese
COPY --from=chinese /etc/apk/keys/sgerrand.rsa.pub /etc/apk/keys/sgerrand.rsa.pub
COPY docker /


RUN set -ex \
    \
    \
    \
    # 创建用户及用户组，后续所有操作都以该用户为执行者，修复在Docker中创建的文件不能被外界用户所操作
    && addgroup -g ${GID} -S ${USERNAME} \
    && adduser -u ${UID} -g ${GID} -S ${USERNAME} \
    \
    \
    \
    && sed -i "s/dl-cdn\.alpinelinux\.org/mirrors.ustc.edu.cn/" /etc/apk/repositories \
    && apk update \
    && apk --no-cache add tzdata su-exec bash s6 \
    \
    \
    \
    # 增加中文支持以及64位程序库支持
    && apk add /opt/chinese/glibc-bin-2.30-r0.apk /opt/chinese/glibc-i18n-2.30-r0.apk /opt/chinese/glibc-2.30-r0.apk \
    && cat /usr/local/locale.md | xargs -i /usr/glibc-compat/bin/localedef -i {} -f UTF-8 {}.UTF-8 \
    && rm -rf /opt/chinese \
    && rm -rf /usr/local/locale.md \
    && rm -f /etc/apk/keys/sgerrand.rsa.pub \
    \
    \
    \
    # 增加执行权限
    && chmod +x /usr/bin/entrypoint \
    && chmod +x /usr/bin/property \
    && chmod +x /etc/s6/.s6-svscan/* \
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


ENTRYPOINT ["/usr/bin/entrypoint"]
CMD ["/bin/s6-svscan", "/etc/s6"]
