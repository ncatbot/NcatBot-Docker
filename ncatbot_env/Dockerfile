FROM ubuntu_cn

# 确保 Python 始终以 UTF-8 模式输出（防止 Windows 终端乱码）
ENV PYTHONUTF8=1
ENV PYTHONIOENCODING=utf-8

# 1.1 安装 Python 3.12、基本工具以及 NapCat 所需系统依赖
#    预先安装这些包，避免 ncatbot napcat install 在镜像构建时因代理/网络问题下载失败
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y --no-install-recommends \
        python3.12 \
        python3.12-venv \
        python3-pip \
        ca-certificates \
        git \
        zip \
        unzip \
        jq \
        xvfb \
        screen \
        xauth \
        procps \
        rpm2cpio \
        cpio \
        libnss3 \
        libgbm1 \
        libglib2.0-0t64 \
        libatk1.0-0t64 \
        libatspi2.0-0t64 \
        libgtk-3-0t64 \
        libasound2t64

# 1.2 安装个大的
RUN apt-get install -y --no-install-recommends ffmpeg

# 2. 把 python3.12 设为默认 python
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.12 1

# 3. 创建虚拟环境并安装 NcatBot5
RUN mkdir -p /root/ncatbot && cd /root/ncatbot && \
    python -m venv .venv && \
    . .venv/bin/activate && \
    pip install ncatbot5 -U

# 4. 默认命令
CMD ["/bin/bash"]
