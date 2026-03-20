---
applyTo: "**"
---

# Docker 发布流程 Skill

本项目的 Docker 镜像发布流程指南。适用于本地手动发布和 CI 自动发布。

## 项目镜像架构

三层镜像，从底层到顶层：

1. `ubuntu_cn:1.0` — 基础 Ubuntu 24.04 中文环境（`ubuntu_cn/Dockerfile`）
2. `ncatbot_env:0.3` — Python 3.12 + NapCat 系统依赖（`ncatbot_env/Dockerfile`）
3. `huanyp/ncatbot:latest` — 最终应用镜像（根目录 `Dockerfile`）

**日常更新只需重新构建根目录 Dockerfile**，它会拉取最新 ncatbot5 和 napcat。
基础镜像（1、2）仅在系统依赖变更时才需要重建。

## 本地发布流程

### 前置条件

- Docker Desktop 已启动
- 已登录 Docker Hub：`docker login`
- 环境变量（可选，默认值已内置）：
  - `DOCKERHUB_USERNAME`：Docker Hub 用户名（默认 `huanyp`）
  - `DOCKERHUB_REPO`：仓库名（默认 `ncatbot`）

### 步骤

1. **构建主镜像**（只需根目录 Dockerfile，使用 `--no-cache` 确保拉取最新 ncatbot5/napcat）：

```powershell
chcp 65001 | Out-Null
docker build --no-cache -t huanyp/ncatbot:latest -t huanyp/ncatbot:5 .
```

2. **推送到 Docker Hub**：

```powershell
docker push huanyp/ncatbot:latest
docker push huanyp/ncatbot:5
```

3. **验证**：

```powershell
docker run -it --rm -p 6099:6099 -p 3001:3001 huanyp/ncatbot:latest
```

### 完整基础镜像重建（仅在系统依赖变更时）

```powershell
.\build.ps1
docker push huanyp/ncatbot:latest
docker push huanyp/ncatbot:5
```

## CI 自动发布

GitHub Actions 工作流 `.github/workflows/auto-update.yml` 会：

- 每天 UTC 0:00、8:00、16:00（北京时间 8:00、16:00、0:00）检查 PyPI 上 ncatbot5 最新版本
- 与上次构建版本对比，有新版时自动触发构建并推送到 Docker Hub
- 需要在 GitHub 仓库 Settings → Secrets 中配置：
  - `DOCKERHUB_USERNAME`：Docker Hub 用户名
  - `DOCKERHUB_TOKEN`：Docker Hub Access Token（在 https://hub.docker.com/settings/security 创建）

## 注意事项

- 根目录 Dockerfile 的 `RUN pip install -U ncatbot5` 会在每次 `--no-cache` 构建时拉取 PyPI 最新版
- `ncatbot napcat install --yes` 也会安装最新 napcat
- 基础镜像版本号变更时需同步更新：`ncatbot_env/Dockerfile`、根目录 `Dockerfile` 的 FROM、`build.ps1`
