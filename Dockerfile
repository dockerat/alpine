FROM alpine:3.20.0


LABEL author="storezhang<华寅>" \
    email="storezhang@gmail.com" \
    qq="160290688" \
    wechat="storezhang" \
    description="Alpine镜像，增加时间配置以及守护进程"


# 定义时区
ENV TIMEZONE Asia/Chongqing

# 增加中文支持，不然命令行执行程序会报错
ENV LANG zh_CN.UTF-8
ENV LANGUAGE zh_CN.UTF-8

# 设置运行用户及组
ENV UMASK 022
ENV USERNAME storezhang
ENV UID 1000
ENV GID 1000

# 延迟启动
ENV DELAY 1s


# 定义公共配置卷
ENV USER_HOME /config
VOLUME ${USER_HOME}
WORKDIR ${USER_HOME}


# 复制文件
COPY docker /


ARG TARGETARCH
RUN set -ex \
    \
    \
    \
    # 创建用户及用户组，后续所有操作都以该用户为执行者，修复在Docker中创建的文件不能被外界用户所操作
    && addgroup -g ${GID} -S ${USERNAME} \
    && adduser -u ${UID} -g ${GID} -S ${USERNAME} -h ${USER_HOME} \
    \
    \
    \
    && sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk update \
    && apk --no-cache add tzdata su-exec bash s6 \
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
    # 配置系统
    && chmod +x /tmp/setup/* \
    && ARCH=${TARGETARCH} /tmp/setup/arch \
    && rm -rf /tmp \
    \
    \
    \
    # 清理临时文件
    && rm -rf /var/cache/apk/*


ENTRYPOINT ["/usr/bin/entrypoint"]
CMD ["/bin/s6-svscan", "/etc/s6"]
