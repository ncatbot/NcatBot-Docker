# 1. 使用 Ubuntu 24.04 基础镜像
FROM ubuntu:24.04

# 设置环境变量以避免交互式安装时的弹窗
ENV DEBIAN_FRONTEND=noninteractive

# 2. 备份原有源并替换为阿里云 24.04 (noble) 源
# 注意：Ubuntu 24.04 的代号是 noble
RUN cp /etc/apt/sources.list /etc/apt/sources.list.bak && \
    echo 'deb http://mirrors.aliyun.com/ubuntu/ noble main restricted universe multiverse' > /etc/apt/sources.list && \
    echo 'deb http://mirrors.aliyun.com/ubuntu/ noble-updates main restricted universe multiverse' >> /etc/apt/sources.list && \
    echo 'deb http://mirrors.aliyun.com/ubuntu/ noble-backports main restricted universe multiverse' >> /etc/apt/sources.list && \
    echo 'deb http://mirrors.aliyun.com/ubuntu/ noble-security main restricted universe multiverse' >> /etc/apt/sources.list

# 3. 更新索引并安装中文语言包、时区数据与常用工具
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        locales \
        language-pack-zh-hans \
        fonts-noto-cjk \
        curl \
        wget \
        vim \
        sudo \
        tzdata && \
    locale-gen zh_CN.UTF-8

# 4. 设置容器默认 locale
ENV LANG=zh_CN.UTF-8
ENV LANGUAGE=zh_CN:zh
ENV LC_ALL=zh_CN.UTF-8

# 5. 设置时区 (上海)
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone

# 6. 默认交互 shell
CMD ["/bin/bash"]