#!/bin/bash
set -e

# 显示欢迎信息
echo -e "$(cat /root/ncatbot/welcome.txt)"

# 用 exec 替换当前 shell，使 ncatbot run 成为 PID 1
# 这样 Docker 的 SIGTERM/SIGINT 会直接发送给 ncatbot 进程，实现优雅退出
exec ncatbot run
