# huly-gemma4-infra

自前 GPU サーバー（Slurm）上の **Gemma 4** と **Huly**（OSSプロジェクト管理）を連携させるためのインフラ・ドキュメントリポジトリです。

---

## 📁 リポジトリ構成

```
huly-gemma4-infra/
├── .github/
│   └── workflows/
│       └── deploy-slides.yml   # Slidev → GitHub Pages 自動デプロイ
├── docs/
│   └── overview.md             # プロジェクト概要ドキュメント
├── infra/
│   ├── slurm/
│   │   └── gemma4_job.sh       # Slurm sbatch スクリプト例
│   └── docker/
│       └── docker-compose.yml  # Docker Compose 雛形（Ollama + Huly）
├── slides/
│   ├── package.json            # Slidev 依存関係
│   └── slides.md               # 研究計画スライド
├── zenn/
│   ├── package.json            # Zenn CLI 依存関係
│   └── articles/
│       └── 01-project-setup.md # 構築ログ記事のサンプル
├── .gitignore
└── README.md                   # このファイル
```

---

## 🎯 プロジェクト概要

| 項目 | 内容 |
|------|------|
| **目的** | Huly（OSSプロジェクト管理ツール）と自前 GPU サーバー上の Gemma 4 を連携し、AI 支援プロジェクト管理を実現する |
| **実行環境** | Slurm 管理下の GPU ノード（RTX 2080 Ti 等）、Ollama、Docker |
| **使用ツール** | Slidev（スライド）、Zenn CLI（技術記事）、GitHub Actions（CI/CD） |

詳細は [`docs/overview.md`](./docs/overview.md) を参照してください。

---

## 🚀 セットアップ手順

### 前提条件

- Node.js 18 以上
- Docker / Docker Compose
- Slurm が使える GPU クラスター環境
- GitHub アカウント（GitHub Pages 利用時）

### 1. リポジトリのクローン

```bash
git clone https://github.com/Minoru-kuma/huly-gemma4-infra.git
cd huly-gemma4-infra
```

### 2. Slidev（研究計画スライド）

```bash
cd slides
npm install
npm run dev      # ローカルプレビュー (http://localhost:3030)
npm run build    # 静的ファイル生成 → dist/
```

GitHub Pages へのデプロイは `main` ブランチへの push 時に自動実行されます。

### 3. Zenn CLI（技術記事）

```bash
cd zenn
npm install
npx zenn preview  # ローカルプレビュー (http://localhost:8000)
```

Zenn への反映は [Zenn の GitHub 連携](https://zenn.dev/dashboard/deploys) を設定してください。

### 4. Slurm ジョブの投入（GPU サーバー上で実行）

```bash
# GPU サーバーにログイン後
sbatch infra/slurm/gemma4_job.sh
```

### 5. Docker Compose（Ollama + Huly）

```bash
cd infra/docker
cp ../../.env.example .env   # 環境変数を設定
docker compose up -d
```

---

## 📖 Zenn 記事

構築ログや技術解説は Zenn で公開予定です。

- [Zenn プロフィール](https://zenn.dev/) *(公開後リンクを更新してください)*

---

## 🤝 Contributing

Issue・PR はお気軽にどうぞ。

---

## 📄 License

MIT
