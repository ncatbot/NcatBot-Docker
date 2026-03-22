# NcatBot5 Docker

基于 NcatBot5 构建的 QQ 机器人 Docker 容器镜像，提供开箱即用的 QQ 机器人运行环境。

NcatBot5 采用适配器架构，支持多平台（QQ/Bilibili/GitHub），内置插件系统和 CLI 工具。

**镜像内已预装 NapCat + QQ**，无需等待首次安装，启动即用。

## 快速开始

### 方式一：交互式运行

```bash
docker run -it -p 6099:6099 -p 3001:3001 huanyp/ncatbot:latest
```

进入容器后按提示操作：

1. 执行 `ncatbot init`，填入 `bot_uin`（机器人 QQ 号）和 `root`（管理员 QQ 号）
2. 执行 `ncatbot run`，NapCat 启动后会在终端打印 **二维码**，用手机 QQ 扫码登录即可

### 方式二：Docker Compose（推荐）

1. 准备配置文件：

```bash
mkdir -p data/plugins
cp resources/config.yaml data/config.yaml
# 编辑 data/config.yaml 填入你的 QQ 号信息
```

2. 启动：

```bash
docker-compose up -d
```

3. **首次需扫码登录**：打开浏览器访问 **http://localhost:6099**，进入 NapCat WebUI，按页面引导扫码登录。

   > 登录成功后会话会持久化到 Docker volume，**重启容器无需重新扫码**。

### 配置说明

`config.yaml` 关键配置：

```yaml
bot_uin: '123456'       # 机器人 QQ 号（必填）
root: '123456'          # 管理员 QQ 号（必填）
debug: false

napcat:
  ws_uri: ws://localhost:3001
  ws_token: napcat_ws
  webui_uri: http://localhost:6099
  webui_token: napcat_webui
  enable_webui: true
  skip_setup: false     # true 则跳过 NapCat 安装直接连接

plugin:
  plugins_dir: plugins
  load_plugin: true
  auto_install_pip_deps: true
```

## 项目结构

本项目采用多层 Docker 镜像设计：

- `ubuntu_cn:1.0` — 基础 Ubuntu 24.04 中文环境镜像
- `ncatbot_env:0.2` — Python 3.12 + NcatBot5 + NapCat/QQ 预装环境镜像
- 主镜像 — 完整的机器人应用镜像（含配置、示例插件、启动脚本）

```
ncatbot-docker/
├── Dockerfile                    # 主镜像构建文件
├── docker-compose.yml            # Docker Compose 部署配置
├── ubuntu_cn/
│   └── Dockerfile               # Ubuntu 中文环境镜像
├── ncatbot_env/
│   └── Dockerfile               # NcatBot5 环境镜像
├── resources/
│   ├── config.yaml              # 机器人配置文件
│   ├── main.py                  # 备用程序入口（高级用法）
│   ├── welcome.txt              # 欢迎信息
│   └── plugins/
│       └── hello_world/         # 示例插件
│           ├── manifest.toml
│           └── plugin.py
└── README.md
```

## 构建指南

**Windows 用户（PowerShell）**：直接使用项目提供的构建脚本，已内置 UTF-8 代码页切换，避免构建日志乱码：

```powershell
.\build.ps1
```

**Linux / macOS 或手动构建**：

```bash
# 1. 构建基础镜像
docker build -t ubuntu_cn:1.0 ./ubuntu_cn/
docker build -t ncatbot_env:0.2 ./ncatbot_env/

# 2. 构建主镜像
docker build -t ncatbot:latest .
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
