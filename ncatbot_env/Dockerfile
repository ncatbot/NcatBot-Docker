FROM ubuntu_cn:1.0

# 1. 安装 Python 3.12 及基本工具
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y --no-install-recommends \
        python3.12 \
        python3.12-venv \
        python3-pip \
        ca-certificates

# 2. 把 python3.12 设为默认 python
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.12 1

# 3. 创建虚拟环境并安装 NcatBott
RUN mkdir -p /root/ncatbot && cd /root/ncatbot && \
    python -m venv .venv && \
    . .venv/bin/activate && \
    pip install ncatbot -U -i https://mirrors.aliyun.com/pypi/simple && \
    yes | python -c "from ncatbot.core.adapter.nc.install import install_napcat; install_napcat('install')"

# 5. 默认命令
CMD ["/bin/bash"]
