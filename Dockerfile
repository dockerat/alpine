FROM alpine:3.23.4


LABEL author="storezhang<华寅>" \
    email="storezhang@gmail.com" \
    qq="160290688" \
    wechat="storezhang" \
    description="Alpine镜像，增加时间配置以及守护进程"


ENV TIMEZONE=Asia/Chongqing \ # 定义时区
    LANG=zh_CN.UTF-8 \ # 增加中文支持，不然命令行执行程序会报错
    LANGUAGE=zh_CN:zh \
    UMASK=022 \ # 设置运行用户及组
    USER=storezhang \
    UID=1000 \
    GID=1000 \
    DELAY=1s \ # # 延迟启动
    USER_HOME=/config # 定义公共配置卷


VOLUME ${USER_HOME}
WORKDIR ${USER_HOME}


# 复制文件
COPY docker /


ARG TARGETARCH=amd64
RUN set -ex \
    \
    \
    \
    # 创建用户及用户组，后续所有操作都以该用户为执行者，修复在Docker中创建的文件不能被外界用户所操作
    && addgroup -g ${GID} -S ${USER} \
    && adduser -u ${UID} -g ${GID} -S ${USER} -h ${USER_HOME} \
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
