FROM ncatbot_env

# 确保 Python 始终以 UTF-8 模式输出（防止 Windows 终端乱码）
ENV PYTHONUTF8=1
ENV PYTHONIOENCODING=utf-8

# 将虚拟环境路径置于 PATH 最前，进入容器后自动生效，无需 source activate
ENV PATH="/root/ncatbot/.venv/bin:$PATH"

COPY resources/welcome.txt /root/ncatbot/

# 更新 ncatbot 到最新版并确认 NapCat 已安装，同时记录版本号到 label
RUN . /root/ncatbot/.venv/bin/activate && \
    pip install -U ncatbot5 && \
    ncatbot napcat install --yes && \
    echo $(pip show ncatbot5 | grep Version | cut -d' ' -f2) > /tmp/ncatbot_version

# 清理
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 版本标签（CI 通过 --label 覆盖，本地构建读取安装版本）
ARG NCATBOT_VERSION=unknown
LABEL ncatbot.version=${NCATBOT_VERSION}

WORKDIR /root/ncatbot

# 暴露 NapCat 相关端口
EXPOSE 3001 6099

# 默认命令：显示欢迎信息，初始化项目，再启动 Bot
CMD ["sh", "-c", "echo \"$(cat /root/ncatbot/welcome.txt)\" && ncatbot init && ncatbot run"]
