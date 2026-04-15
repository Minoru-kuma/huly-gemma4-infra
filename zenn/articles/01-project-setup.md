---
title: "Gemma 4 × Huly on Slurm — 環境構築ログ #1: リポジトリ初期設定"
emoji: "🚀"
type: "tech"
topics: ["gemma", "huly", "slurm", "ollama", "docker"]
published: false
---

# Gemma 4 × Huly on Slurm — 環境構築ログ #1

## はじめに

本記事は、自前 GPU サーバー（Slurm 管理下）上で Gemma 4 を動かし、Huly（OSS プロジェクト管理ツール）と連携させるプロジェクトの構築ログです。

## プロジェクト概要

- **目的**: Huly と Gemma 4 を連携した AI 支援プロジェクト管理の実現
- **環境**: RTX 2080 Ti × Slurm、Ollama、Docker Compose
- **リポジトリ**: [huly-gemma4-infra](https://github.com/Minoru-kuma/huly-gemma4-infra)

## リポジトリ構成

```
huly-gemma4-infra/
├── .github/workflows/   # GitHub Actions
├── docs/                # プロジェクトドキュメント
├── infra/
│   ├── slurm/           # Slurm sbatch スクリプト
│   └── docker/          # Docker Compose 設定
├── slides/              # Slidev スライド
└── zenn/                # この記事を含む Zenn コンテンツ
```

## 次回予告

次回は Slurm GPU ノードへの Ollama + Gemma 4 のデプロイ手順を紹介します。

## 参考リンク

- [Ollama 公式](https://ollama.ai/)
- [Huly GitHub](https://github.com/hcengineering/huly)
- [Gemma - Google AI](https://ai.google.dev/gemma)
