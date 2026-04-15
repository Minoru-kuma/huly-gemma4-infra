#!/bin/bash
#SBATCH --job-name=gemma4-ollama
#SBATCH --partition=gpu
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=24:00:00
#SBATCH --output=logs/gemma4-%j.out
#SBATCH --error=logs/gemma4-%j.err
#SBATCH --mail-type=BEGIN,END,FAIL
# #SBATCH --mail-user=your-email@example.com  # 必要に応じてコメントアウトを外す

# ==============================================================
# Gemma 4 (via Ollama) Slurm ジョブスクリプト
#
# 使い方:
#   sbatch infra/slurm/gemma4_job.sh
#
# 前提:
#   - ollama コマンドが PATH に通っている、または下記 OLLAMA_PATH を設定
#   - logs/ ディレクトリが存在すること（なければ自動作成）
#   - ポート 11434 が空いていること
# ==============================================================

set -euo pipefail

# --- 設定 -----------------------------------------------------
OLLAMA_PATH="${OLLAMA_PATH:-$(which ollama)}"
OLLAMA_HOST="0.0.0.0:11434"
# 利用可能なモデルの例: gemma4:4b, gemma4:12b, gemma4:27b
MODEL="${MODEL:-gemma4:4b}"
LOG_DIR="$(pwd)/logs"
# --------------------------------------------------------------

echo "=== Gemma 4 Ollama Job Start ==="
echo "Job ID   : ${SLURM_JOB_ID}"
echo "Node     : ${SLURMD_NODENAME}"
echo "GPU      : ${CUDA_VISIBLE_DEVICES}"
echo "Model    : ${MODEL}"
echo "Time     : $(date '+%Y-%m-%d %H:%M:%S')"
echo "================================"

# ログディレクトリ作成
mkdir -p "${LOG_DIR}"

# GPU の確認
if command -v nvidia-smi &>/dev/null; then
    nvidia-smi --query-gpu=name,memory.total,memory.free --format=csv,noheader
fi

# Ollama サーバー起動
echo "[INFO] Starting Ollama server on ${OLLAMA_HOST} ..."
OLLAMA_HOST="${OLLAMA_HOST}" "${OLLAMA_PATH}" serve &
OLLAMA_PID=$!
echo "[INFO] Ollama PID: ${OLLAMA_PID}"

# サーバー起動待機
echo "[INFO] Waiting for Ollama to be ready ..."
for i in $(seq 1 30); do
    if curl -sf "http://localhost:11434/api/tags" > /dev/null 2>&1; then
        echo "[INFO] Ollama is ready."
        break
    fi
    sleep 2
done

# モデルのプル（未取得の場合のみダウンロード）
echo "[INFO] Pulling model: ${MODEL} ..."
"${OLLAMA_PATH}" pull "${MODEL}"

# 動作確認（簡易テスト）
echo "[INFO] Running inference test ..."
"${OLLAMA_PATH}" run "${MODEL}" "日本語で「準備完了」と一言だけ答えてください。"

echo "[INFO] Ollama server is serving model '${MODEL}' on port 11434."
echo "[INFO] API endpoint: http://${SLURMD_NODENAME}:11434"

# サーバーをフォアグラウンドで維持（ジョブ終了まで待機）
wait "${OLLAMA_PID}"

echo "=== Job Finished ==="
