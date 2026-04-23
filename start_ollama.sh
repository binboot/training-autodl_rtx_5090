#!/bin/bash
# Ollama 启动脚本（5090 优化版）
# 用法: bash /root/autodl-tmp/ollama/start_ollama.sh

export PATH="/root/autodl-tmp/ollama/bin:$PATH"
export OLLAMA_MODELS="/root/autodl-tmp/ollama/models"

# === 5090 性能/显存优化 ===
export OLLAMA_FLASH_ATTENTION=1      # FA: prefill 加速 + KV 内存降低
export OLLAMA_KV_CACHE_TYPE=q8_0     # KV cache 8bit 量化, 占用减半, 质量损失可忽略

# 后台启动, 日志追加到 logs/
mkdir -p /root/autodl-tmp/ollama/logs
nohup ollama serve >> /root/autodl-tmp/ollama/logs/ollama.log 2>&1 &
echo "ollama serve started, PID=$!"
echo "FA=$OLLAMA_FLASH_ATTENTION, KV=$OLLAMA_KV_CACHE_TYPE"
