# 1. 使用 Ubuntu 24.04 基础镜像
FROM ubuntu:24.04

# 设置环境变量以避免交互式安装时的弹窗
ENV DEBIAN_FRONTEND=noninteractive

# 是否替换为阿里云源：0=保持官方源（GitHub Actions / 海外网络），1=使用阿里镜像（国内本地构建）
ARG USE_CN_MIRROR=0

# 2. 可选：替换为阿里云 24.04 (noble) 源
# Ubuntu 24.04 使用 DEB822 格式（ubuntu.sources），需同时覆盖两处
RUN if [ "$USE_CN_MIRROR" = "1" ]; then \
      rm -f /etc/apt/sources.list.d/ubuntu.sources && \
      echo 'deb http://mirrors.aliyun.com/ubuntu/ noble main restricted universe multiverse' > /etc/apt/sources.list && \
      echo 'deb http://mirrors.aliyun.com/ubuntu/ noble-updates main restricted universe multiverse' >> /etc/apt/sources.list && \
      echo 'deb http://mirrors.aliyun.com/ubuntu/ noble-backports main restricted universe multiverse' >> /etc/apt/sources.list && \
      echo 'deb http://mirrors.aliyun.com/ubuntu/ noble-security main restricted universe multiverse' >> /etc/apt/sources.list; \
    fi

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
