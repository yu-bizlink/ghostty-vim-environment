# Ghostty Vim Environment

Ghosttyのスプリット機能を活用した、5ペイン構成のVim風統合開発環境

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)

## 概要

Ghosttyターミナルエミュレータ上で、Neovim、filetree、keifu、Claude Codeを統合した効率的な開発環境です。

### レイアウト

```
+--------+----------------+----------------+
| file   |                | Claude Code    |
| tree   |     Neovim     | (開発用)       |
| 20%    |     40%        | 40%            |
+--------+                +----------------+
| keifu  |                | Claude Code    |
| 20%    |                | (参照/調査用)  |
+--------+----------------+----------------+
```

## 特徴

- 🚀 **ワンコマンド起動** - `gvim`で5ペイン環境を自動構築
- 📁 **統合ファイルツリー** - filetreeからNeovimへシームレスに編集
- 🌳 **Git可視化** - keifuでコミット履歴をリアルタイム表示
- 🤖 **デュアルClaude** - 開発用と参照用の2インスタンス
- ⚡ **ホットリロード** - 設定変更を即座に反映
- ⌨️ **Vim風操作** - Ctrl+Cmd+H/J/K/Lでペイン移動

## 技術スタック

- **Ghostty** - 高速ターミナルエミュレータ
- **Neovim v0.11+** - LSP、Treesitter対応エディタ
- **filetree** - Rust製TUIファイルエクスプローラー
- **keifu** - Rust製Git可視化ツール
- **Claude Code** - AIペアプログラミング

## インストール

### 必須要件

- macOS (Apple Silicon / Intel)
- Homebrew
- Rust (cargo)
- Claude Code CLI

### クイックインストール

```bash
# リポジトリをクローン
git clone https://github.com/YOUR_USERNAME/ghostty-vim-environment.git
cd ghostty-vim-environment

# インストールスクリプトを実行
./install.sh

# インストール確認
ghostty-vim-check
```

### 手動インストール

<details>
<summary>クリックして展開</summary>

#### 1. 必須ツールのインストール

```bash
# Neovim
brew install neovim

# Nerd Font
brew install --cask font-jetbrains-mono-nerd-font

# Rustツール
cargo install filetree
cargo install keifu
```

#### 2. 設定ファイルのコピー

```bash
# Neovim設定
mkdir -p ~/.config/nvim
cp config/nvim/init.lua ~/.config/nvim/

# ツール設定
mkdir -p ~/.config/filetree ~/.config/keifu
cp config/filetree/config.toml ~/.config/filetree/
cp config/keifu/config.toml ~/.config/keifu/

# Ghostty設定（既存設定に追記）
cat config/ghostty/config >> ~/Library/Application\ Support/com.mitchellh.ghostty/config
```

#### 3. スクリプトのインストール

```bash
# スクリプトをコピー
mkdir -p ~/.local/bin
cp bin/* ~/.local/bin/
chmod +x ~/.local/bin/ghostty-*

# zsh設定を追記
cat config/zshrc >> ~/.zshrc
source ~/.zshrc
```

</details>

## 使い方

### 基本操作

```bash
# カレントディレクトリで起動
gvim

# 特定のディレクトリで起動
gvim ~/projects/myapp

# インストール確認
ghostty-vim-check
```

### キーバインド

#### ペイン操作

| キー | 機能 |
|------|------|
| `Ctrl+Cmd+H` | 左のペインへ移動 |
| `Ctrl+Cmd+J` | 下のペインへ移動 |
| `Ctrl+Cmd+K` | 上のペインへ移動 |
| `Ctrl+Cmd+L` | 右のペインへ移動 |
| `Ctrl+Cmd+Shift+H/J/K/L` | ペインリサイズ |
| `Ctrl+Cmd+E` | ペイン均等化 |
| `Cmd+D` | 右にスプリット |
| `Cmd+Shift+D` | 下にスプリット |
| `Cmd+W` | ペインを閉じる |

#### Neovim内

| キー | 機能 |
|------|------|
| `Space+W` | ファイル保存 |
| `Space+Q` | 終了 |
| `Space+E` | ファイルエクスプローラー |
| `gd` | 定義へジャンプ |
| `K` | ドキュメント表示 |
| `Space+rn` | 変数リネーム |

## 初回セットアップ

### AppleScriptアクセシビリティ権限

初回実行時、macOSが権限を要求します：

1. **システム環境設定** → **プライバシーとセキュリティ** → **アクセシビリティ**
2. Ghostty、ターミナル、osascriptに権限を付与
3. `gvim`を再実行

### Neovimプラグインのインストール

初回起動時、自動的にプラグインがインストールされます（1〜2分）。

## ホットリロード

`gvim`で環境を起動すると、自動的にホットリロード機能が有効になります。

### 自動リロード対象

以下の設定ファイルが監視され、変更時に自動的にリロードされます：

- **Ghostty設定** (`~/Library/Application Support/com.mitchellh.ghostty/config`)
  - 保存すると即座にGhosttyがリロード
  - macOS通知で完了を確認

- **Neovim設定** (`~/.config/nvim/init.lua`)
  - 保存すると実行中のNeovimに反映
  - 一部の変更は再起動が必要

- **filetree設定** (`~/.config/filetree/config.toml`)
  - 保存すると通知表示
  - ペインの再起動を推奨

- **keifu設定** (`~/.config/keifu/config.toml`)
  - 保存すると通知表示
  - ペインの再起動を推奨

### 使い方

```bash
# 環境起動（ホットリロードも自動起動）
gvim

# 設定を編集
nvim ~/.config/nvim/init.lua
# 保存すると自動的に反映される

# ホットリロードのログを確認
tail -f /tmp/ghostty-vim-hotreload.log

# ホットリロードを停止
ghostty-vim-stop
```

### 手動起動

環境を起動せずにホットリロードのみ起動したい場合：

```bash
# バックグラウンドで起動
ghostty-vim-hotreload &

# フォアグラウンドで起動（ログをリアルタイム表示）
ghostty-vim-hotreload
```

## トラブルシューティング

### filetreeからファイルが開けない

```bash
# ソケット確認
cat /tmp/nvim-ghostty-socket

# 手動テスト
nvim --server $(cat /tmp/nvim-ghostty-socket) --remote ~/testfile.txt
```

### レイアウトが崩れる

1. Ghosttyウィンドウを最大化（推奨: 240列以上）
2. `Ctrl+Cmd+E`でペイン均等化

### keifuが動作しない

```bash
# Gitリポジトリの確認
git status

# Gitリポジトリ化
git init
```

## カスタマイズ

### Neovim設定

`~/.config/nvim/init.lua`を編集：

```lua
-- リーダーキーを変更
vim.g.mapleader = ","

-- 追加プラグイン
{
  "github/copilot.vim",
  config = function()
    -- 設定
  end,
}
```

### Ghostty設定

`~/Library/Application Support/com.mitchellh.ghostty/config`を編集：

```
# カスタムキーバインド
keybind = cmd+t=new_tab
keybind = cmd+n=new_window
```

## プロジェクト構造

```
ghostty-vim-environment/
├── README.md                 # このファイル
├── LICENSE                   # MITライセンス
├── install.sh                # インストールスクリプト
├── bin/                      # 実行スクリプト
│   ├── ghostty-vim-project   # メイン起動スクリプト
│   ├── ghostty-pane-nvim     # Neovimペイン
│   ├── ghostty-pane-filetree # filetreeペイン
│   ├── ghostty-pane-keifu    # keifuペイン
│   ├── ghostty-pane-claude   # Claude Codeペイン
│   └── ghostty-vim-check     # 確認スクリプト
├── config/                   # 設定ファイル
│   ├── nvim/
│   │   └── init.lua          # Neovim設定
│   ├── filetree/
│   │   └── config.toml       # filetree設定
│   ├── keifu/
│   │   └── config.toml       # keifu設定
│   ├── ghostty/
│   │   └── config            # Ghostty設定
│   └── zshrc                 # zsh設定（追記用）
└── docs/                     # ドキュメント
    ├── installation.md       # インストールガイド
    ├── usage.md              # 使い方ガイド
    └── troubleshooting.md    # トラブルシューティング
```

## 貢献

プルリクエストを歓迎します！

1. このリポジトリをフォーク
2. フィーチャーブランチを作成 (`git checkout -b feature/amazing-feature`)
3. 変更をコミット (`git commit -m 'Add amazing feature'`)
4. ブランチにプッシュ (`git push origin feature/amazing-feature`)
5. プルリクエストを作成

## ライセンス

MIT License - 詳細は[LICENSE](LICENSE)を参照

## クレジット

- [Ghostty](https://github.com/mitchellh/ghostty) - Mitchell Hashimoto
- [Neovim](https://neovim.io/) - Neovim Project
- [filetree](https://github.com/IndianBoy42/filetree.nvim) - Rust TUI
- [keifu](https://github.com/robatipoor/keifu) - Git visualization

## 関連リンク

- [Ghostty公式サイト](https://ghostty.org/)
- [Neovim公式ドキュメント](https://neovim.io/doc/)
- [Claude Code](https://claude.ai/code)

---

**作成者**: [YOUR_NAME]
**バージョン**: 1.0.0
**更新日**: 2026-01-17
