FROM ncatbot_env:0.1

# 拷贝必要的文件
COPY resources/* /root/ncatbot/

# 更新有关依赖
RUN . /root/ncatbot/.venv/bin/activate && \
    pip install -U ncatbot -i https://mirrors.aliyun.com/pypi/simple && \
    napcat update

# 清理
RUN apt-get clean && \
rm -rf /var/lib/apt/lists/*


# 设置
RUN chmod 700 /root/ncatbot/start.sh
WORKDIR /root/ncatbot

# 默认命令
CMD ["sh", "-c", "echo \"$(cat /root/ncatbot/welcome.txt)\" && exec bash"]
