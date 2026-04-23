apt install -y zip unzip zstd

mkdir -p /root/autodl-tmp/ollama/logs
mkdir -p /root/autodl-tmp/ollama
tar --zstd -xf /root/autodl-tmp/data/ollama-linux-amd64.tar.zst -C /root/autodl-tmp/ollama

tar -xzf /root/autodl-tmp/data/ollama-gemma4-31b.tar.gz -C /root/autodl-tmp/ollama
tar -xzf /root/autodl-tmp/data/ollama-gemma4-26b.tar.gz -C /root/autodl-tmp/ollama


export PATH="/root/autodl-tmp/ollama/bin:$PATH"
export OLLAMA_MODELS="/root/autodl-tmp/ollama/models"
