# build.ps1 — 在 Windows 上正确构建 NcatBot Docker 镜像
# 切换控制台代码页为 UTF-8，防止 Docker build 输出乱码
chcp 65001 | Out-Null
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$ErrorActionPreference = "Stop"

Write-Host "=== Step 1/3: 构建基础镜像 ubuntu_cn（阿里云源，适合本地/国内网络）===" -ForegroundColor Cyan
docker build --build-arg USE_CN_MIRROR=1 -t ubuntu_cn ./ubuntu_cn/
if ($LASTEXITCODE -ne 0) { Write-Error "ubuntu_cn 构建失败"; exit 1 }

Write-Host "=== Step 2/3: 构建环境镜像 ncatbot_env ===" -ForegroundColor Cyan
docker build -t ncatbot_env ./ncatbot_env/
if ($LASTEXITCODE -ne 0) { Write-Error "ncatbot_env 构建失败"; exit 1 }

Write-Host "=== Step 3/3: 构建最终镜像 huanyp/ncatbot ===" -ForegroundColor Cyan
docker build --no-cache -t huanyp/ncatbot:latest .
if ($LASTEXITCODE -ne 0) { Write-Error "ncatbot 构建失败"; exit 1 }

Write-Host "=== 全部构建完成 ===" -ForegroundColor Green
