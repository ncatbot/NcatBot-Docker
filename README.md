# NcatBot Docker

基于 NcatBot 构建的 QQ 机器人 Docker 容器镜像，提供开箱即用的 QQ 机器人运行环境。

## 快速指南

### 运行

```bash
docker run -it huanyp/ncatbot:latest
```

```bash
./start.sh
```

### 配置

`/root/ncatbot/config.yaml` 为配置文件：

```yaml
root: 654321 # 机器人管理员 QQ 号
bt_uin: 123456 # 机器人自身 QQ 号
enable_webui_interaction: True # 是否启用 WebUI 交互
debug: False # 是否开启调试模式
napcat:
  ws_uri: localhost:3001 # NapCat WebSocket 连接地址（通常无需改变）
  webui_uri: localhost:6099 # NapCat WebUI 访问地址（通常无需改变）
  ws_token: your_token # WebSocket 连接令牌
```

## 项目结构

本项目采用多层 Docker 镜像设计，包含以下镜像：

- `ubuntu_cn:1.0` - 基础 Ubuntu 中文环境镜像
- `ncatbot_env:0.1` - NcatBot 运行环境镜像
- 主镜像 - 完整的机器人应用镜像

## 构建指南

```bash
# 构建基础镜像
docker build -t ubuntu_cn:1.0 ./ubuntu_cn/
docker build -t ncatbot_env:0.1 ./ncatbot_env/

# 构建主镜像
docker build -t ncatbot:latest .
```

## 目录结构

```
ncatbot-docker/
├── Dockerfile                    # 主镜像构建文件
├── ubuntu_cn/
│   └── Dockerfile               # Ubuntu 中文环境镜像
├── ncatbot_env/
│   └── Dockerfile               # NcatBot 环境镜像
├── resources/
│   ├── config.yaml              # 机器人配置文件
│   ├── main.py                  # 机器人主程序示例
│   ├── start.sh                 # 启动脚本
│   └── welcome.txt              # 欢迎信息
└── README.md                    # 项目说明
```

## 部署

### 使用 Docker Compose（推荐）

创建 `docker-compose.yml` 文件：

```yaml
version: '3.8'
services:
  ncatbot:
    build: .
    container_name: ncatbot
    volumes:
      - ./logs:/root/ncatbot/logs
      - ./config:/root/ncatbot/config  # 可选：挂载配置目录
    environment:
      - TZ=Asia/Shanghai
    restart: unless-stopped
```

然后运行：

```bash
docker-compose up -d
```

### 查看日志

```bash
# 查看容器日志
docker logs ncatbot

# 查看 NapCat 日志
docker exec -it ncatbot tail -f /root/ncatbot/logs/napcat.log
```

## 许可证

本项目遵循 MIT 许可证。

## 贡献

欢迎提交 Issue 和 Pull Request！
