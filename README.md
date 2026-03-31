# NcatBot5 Docker

基于 NcatBot5 构建的 QQ 机器人 Docker 容器镜像，提供开箱即用的 QQ 机器人运行环境。

NcatBot5 采用适配器架构，支持多平台（QQ/Bilibili/GitHub），内置插件系统和 CLI 工具。

**镜像内已预装 NapCat + QQ**，无需等待首次安装，启动即用。

## 快速开始

### 方式一：Docker Compose（推荐）

*Tips: 此方式会从 Docker Hub 拉取最新镜像，如网络不通畅可尝试本地构建*

1. **克隆项目**：

```bash
git clone https://github.com/ncatbot/NcatBot-Docker.git ncatbot
cd ncatbot
```

2. **修改配置文件**：

编辑 data/config.yaml 填入 BOT 和管理员的 QQ 号信息

3. **首次启动**：

```bash
docker compose up
```
跟随提示完成配置，首次启动打印二维码，扫码登录即可使用。

如需后台运行：

ctrl + c 退出后，使用以下命令启动：

```bash
docker compose down && docker compose up -d
```

*如果感觉后台模式没有正常运行，可以 `docker attach ncatbot` 进入并查看日志*

*容器中，按 `Ctrl + P` + `Ctrl + Q` 可以退出交互模式而**不停止**容器*

**容器中，按 `Ctrl + C` 会触发优雅退出，等待进程清理后自动停止容器**


### 方式二：交互式运行

```bash
docker run -it --name ncatbot \
  -p 6099:6099 -p 3001:3001 \
  -v "$(pwd)/data/config.yaml:/root/ncatbot/config.yaml" \
  -v "$(pwd)/data/plugins:/root/ncatbot/plugins" \
  -v "$(pwd)/data/logs:/root/ncatbot/logs" \
  -v "$(pwd)/data/data:/root/ncatbot/data" \
  -v "$(pwd)/data/QQ:/root/.config/QQ" \
  huanyp/ncatbot:latest
```

进入容器后按提示操作：

1. 填入 `bot_uin`（机器人 QQ 号）和 `root`（管理员 QQ 号）
2. NapCat 启动后会在终端打印 **二维码**，用手机 QQ 扫码登录即可
3. 启动成功后，如果需要保持后台运行，按 `Ctrl + P` + `Ctrl + Q` 退出容器交互模式
4. 后续可以使用 `docker logs ncatbot` 查看日志，或 `docker exec -it ncatbot bash` 进入容器

### 配置说明

`config.yaml` 关键配置：

```yaml
bot_uin: '123456'                # 机器人 QQ 号
root: '123456'                   # 管理员 QQ 号
adapters:
  - type: napcat
    platform: qq
    enabled: true
    config:
      ws_uri: ws://localhost:3001
      ws_token: napcat_ws
plugin:
  load_plugin: true
```

## 构建指南

**Windows 用户（PowerShell）**：直接使用项目提供的构建脚本，已内置 UTF-8 代码页切换，避免构建日志乱码：

```powershell
.\build.ps1
```

**Linux / macOS 或手动构建**：

`ubuntu_cn` 支持两种构建方式：

- **官方源（默认）**：与 GitHub Actions 一致，适合海外网络或 CI 复现。
- **阿里云镜像**：国内本地构建时 `apt` 更快。

```bash
# 1. 构建基础镜像（二选一）
# 官方源 — 与 CI 相同
docker build -t ubuntu_cn ./ubuntu_cn/
# 或：国内网络 — 阿里云镜像加速
# docker build --build-arg USE_CN_MIRROR=1 -t ubuntu_cn ./ubuntu_cn/

docker build -t ncatbot_env ./ncatbot_env/

# 2. 构建主镜像
docker build -t huanyp/ncatbot:latest .
```

> **Windows 乱码说明**：Windows 控制台默认代码页为 936（GBK），而容器内 Python 输出为 UTF-8，
> 两者不兼容会导致中文日志乱码。`build.ps1` 在构建前自动执行 `chcp 65001` 切换至 UTF-8，
> 同时 Dockerfile 中已设置 `PYTHONUTF8=1` 从容器侧保证输出编码一致。

## CLI 命令

容器内激活虚拟环境后可使用 NcatBot5 CLI：

```bash
source /root/ncatbot/.venv/bin/activate

ncatbot run                   # 生产模式启动
ncatbot dev                   # 开发模式（热重载）
ncatbot init                  # 初始化新项目
ncatbot napcat install [--yes]  # 安装 NapCat（镜像已预装）
ncatbot napcat diagnose       # NapCat 诊断
ncatbot napcat diagnose ws    # WebSocket 连接检测
ncatbot napcat diagnose webui # WebUI 状态检测
```

## 查看日志

```bash
docker logs ncatbot
docker exec -it ncatbot bash
```

## 许可证

本项目遵循 MIT 许可证。

## 贡献

欢迎提交 Issue 和 Pull Request！
