FROM alpine


LABEL author="storezhang<华寅>"
LABEL email="storezhang@gmail.com"
LABEL qq="160290688"
LABEL wechat="storezhang"
LABEL description="Alpine镜像，增加时间配置以及守护进程"


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
    && sed -i "s/dl-cdn\.alpinelinux\.org/mirrors.ustc.edu.cn/" /etc/apk/repositories \
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
    # 链接64位库，不然无法运行64位程序
    && mkdir /lib64 \
    && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2 \
    \
    \
    \
    # 清理临时文件
    && rm -rf /var/cache/apk/*


ENTRYPOINT ["/usr/bin/entrypoint"]
CMD ["/bin/s6-svscan", "/etc/s6"]
