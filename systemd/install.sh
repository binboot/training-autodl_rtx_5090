#!/bin/bash
# 在 AutoDL RTX 5090 服务器上安装 systemd 单元, 实现开机自启
# 用法: sudo bash /root/autodl-tmp/systemd/install.sh
# 注意: AutoDL 实例重建后 /etc 会被重置, 需要重新跑这个脚本;
#       /root/autodl-tmp/ 是持久盘, 单元源文件放这里 (独立于 ollama/).

set -e

SRC_DIR="$(cd "$(dirname "$0")" && pwd)"
SYS_DIR=/etc/systemd/system
UNITS=(ollama.service cloudflared.service)

# 0. 前置检查
command -v systemctl >/dev/null 2>&1 || {
  echo "ERROR: systemctl 不存在, 当前环境可能不是 systemd init" >&2
  exit 1
}
[ -x /root/autodl-tmp/ollama/bin/ollama ]        || echo "WARN: ollama 二进制缺失"
[ -x /root/autodl-tmp/cloudflared/cloudflared ]  || echo "WARN: cloudflared 二进制缺失"
[ -f /root/autodl-tmp/.secrets/cf-tunnel.token ] || echo "WARN: cf-tunnel.token 缺失"

# 1. 复制单元 (用 cp 而不是 symlink, 避免 /root/autodl-tmp 挂载顺序问题)
for u in "${UNITS[@]}"; do
  install -m 644 "$SRC_DIR/$u" "$SYS_DIR/$u"
  echo "installed $SYS_DIR/$u"
done

# 2. reload + enable + start
systemctl daemon-reload
systemctl enable "${UNITS[@]}"
systemctl restart "${UNITS[@]}"

# 3. 状态输出
for u in "${UNITS[@]}"; do
  echo
  echo "=== $u ==="
  systemctl --no-pager --lines=3 status "$u" || true
done
