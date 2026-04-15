---
theme: default
title: Gemma 4 × Huly on Slurm — 研究計画
info: |
  自前 GPU サーバー上の Gemma 4 と Huly を連携させるプロジェクトの研究計画スライドです。
class: text-center
highlighter: shiki
drawings:
  persist: false
transition: slide-left
mdc: true
---

# Gemma 4 × Huly on Slurm

自前 GPU サーバーで動かす AI 支援プロジェクト管理

<div class="pt-12">
  <span class="px-2 py-1 rounded cursor-pointer" hover="bg-white bg-opacity-10">
    スペースキー / →キー で次のスライドへ
  </span>
</div>

---

# アジェンダ

1. **背景と目的**
2. **システム構成**
3. **Gemma 4 について**
4. **Huly について**
5. **Slurm ジョブ設計**
6. **ロードマップ**
7. **まとめ**

---

# 背景と目的

## 課題

- プロジェクト管理ツールの**手動タスク作成・分類**にコストがかかる
- クラウド LLM は**データプライバシー**と**コスト**が懸念

## 解決策

- 自前 GPU（RTX 2080 Ti）＋ Slurm で **Gemma 4** を常駐運用
- **Huly**（OSS PM ツール）と API 連携してタスク自動化
- **完全オンプレミス**でプライバシーとコストを両立

---

# システム構成

```
開発者 PC
  └─ SSH ──→ Slurm ヘッドノード
                └─ sbatch ──→ GPU ノード (RTX 2080 Ti)
                                ├─ Ollama (Gemma 4)
                                └─ Docker Compose (Huly)
```

**データフロー:**
1. Huly に Issue 作成
2. Webhook → Gemma 4 API (Ollama)
3. LLM がタグ付け・優先度設定・要約を返却
4. Huly に自動反映

---

# Gemma 4 について

| 項目 | 内容 |
|------|------|
| 開発元 | Google DeepMind |
| パラメータ数 | 1B / 4B / 12B / 27B |
| ライセンス | Gemma Terms of Use（商用利用可） |
| 実行方法 | Ollama 経由（GGUF形式） |
| API | REST（localhost:11434） |

**選定理由:** 軽量かつ日本語対応、RTX 2080 Ti (11GB VRAM) で動作可能

---

# Huly について

- GitHub Issues / Linear 相当の**OSS プロジェクト管理ツール**
- セルフホスト可能 → Docker Compose で GPU ノード上にデプロイ
- Webhook・REST API 完備 → Gemma 4 と連携しやすい
- MIT ライセンス

---

# Slurm ジョブ設計

```bash
#!/bin/bash
#SBATCH --job-name=gemma4-ollama
#SBATCH --gres=gpu:1
#SBATCH --time=24:00:00
#SBATCH --output=logs/gemma4-%j.out

# Ollama を起動して Gemma 4 をサーブ
ollama serve &
sleep 5
ollama run gemma4:4b
```

詳細は `infra/slurm/gemma4_job.sh` を参照

---

# ロードマップ

| フェーズ | 内容 | 期限 |
|----------|------|------|
| Phase 1 | リポジトリ整備・Slurm ジョブ実装 | 〜 M1 |
| Phase 2 | Ollama + Gemma 4 デプロイ | 〜 M2 |
| Phase 3 | Huly Docker Compose 本番化 | 〜 M3 |
| Phase 4 | Huly ↔ Gemma 4 連携実装 | 〜 M4 |
| Phase 5 | Zenn 記事・スライド公開 | 〜 M5 |

---

# まとめ

- **自前 GPU × Gemma 4 × Huly** で完全オンプレ AI 支援 PM を構築
- Slurm を活用してジョブ管理・リソース制御を実現
- OSS のみで構成し、**プライバシー・コスト・柔軟性**を確保
- 構築ログは Zenn で発信予定

<br>

> リポジトリ: [github.com/Minoru-kuma/huly-gemma4-infra](https://github.com/Minoru-kuma/huly-gemma4-infra)
