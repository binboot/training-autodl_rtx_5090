#!/bin/bash
# Cloudflare Tunnel 启动脚本
# 用法: bash /root/autodl-tmp/cloudflared/start_cloudflared.sh
# 依赖:
#   - /root/autodl-tmp/cloudflared/cloudflared (二进制)
#   - /root/autodl-tmp/.secrets/cf-tunnel.token (tunnel token, chmod 600)
# 注意: token 通过 TUNNEL_TOKEN 环境变量传入, 不走命令行参数,
#       避免 pgrep/ps 把 token 打印出来.

set -e

TOKEN_FILE=/root/autodl-tmp/.secrets/cf-tunnel.token
BIN=/root/autodl-tmp/cloudflared/cloudflared
LOGDIR=/root/autodl-tmp/cloudflared/logs

[ -f "$TOKEN_FILE" ] || { echo "missing $TOKEN_FILE" >&2; exit 1; }
[ -x "$BIN" ]        || { echo "missing or not executable: $BIN" >&2; exit 1; }

mkdir -p "$LOGDIR"

if pgrep -f "cloudflared tunnel" > /dev/null; then
  echo "cloudflared already running, killing old instance"
  pkill -f "cloudflared tunnel" || true
  sleep 1
fi

export TUNNEL_TOKEN=$(cat "$TOKEN_FILE")
nohup "$BIN" tunnel --no-autoupdate run \
  >> "$LOGDIR/cloudflared.log" 2>&1 &
PID=$!
unset TUNNEL_TOKEN

echo "cloudflared started, PID=$PID"
echo "log: $LOGDIR/cloudflared.log"
