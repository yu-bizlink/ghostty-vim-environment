#!/bin/bash
# Ghostty Vim環境 自動インストールスクリプト

set -e

echo "========================================="
echo "Ghostty Vim環境 インストール"
echo "========================================="
echo ""

# カラー定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# エラーチェック関数
check_command() {
    if command -v "$1" &> /dev/null; then
        echo -e "${GREEN}✓${NC} $2 インストール済み"
        return 0
    else
        echo -e "${RED}✗${NC} $2 未インストール"
        return 1
    fi
}

echo "=== 必須ツールのチェック ==="
echo ""

errors=0

# Homebrewチェック
if ! check_command brew "Homebrew"; then
    echo -e "${YELLOW}Homebrewをインストールしてください: https://brew.sh/${NC}"
    errors=$((errors+1))
fi

# Rustチェック
if ! check_command cargo "Rust (cargo)"; then
    echo -e "${YELLOW}Rustをインストールしてください: https://rustup.rs/${NC}"
    errors=$((errors+1))
fi

# Claude Codeチェック
if ! check_command claude "Claude Code"; then
    echo -e "${YELLOW}Claude Codeをインストールしてください: https://claude.ai/code${NC}"
    errors=$((errors+1))
fi

if [ $errors -gt 0 ]; then
    echo ""
    echo -e "${RED}必須ツールをインストールしてから再実行してください${NC}"
    exit 1
fi

echo ""
echo "=== ツールのインストール ==="
echo ""

# Neovim
if ! check_command nvim "Neovim"; then
    echo "Neovimをインストール中..."
    brew install neovim
fi

# Nerd Font
if ! brew list --cask font-jetbrains-mono-nerd-font &> /dev/null; then
    echo "JetBrains Mono Nerd Fontをインストール中..."
    brew install --cask font-jetbrains-mono-nerd-font
else
    echo -e "${GREEN}✓${NC} JetBrains Mono Nerd Font インストール済み"
fi

# filetree
if ! check_command ft "filetree"; then
    echo "filetreeをインストール中..."
    cargo install filetree
fi

# keifu
if ! check_command keifu "keifu"; then
    echo "keifuをインストール中..."
    cargo install keifu
fi

echo ""
echo "=== 設定ファイルのコピー ==="
echo ""

# ディレクトリ作成
mkdir -p ~/.config/nvim
mkdir -p ~/.config/filetree
mkdir -p ~/.config/keifu
mkdir -p ~/.local/bin

# Neovim設定
if [ -f ~/.config/nvim/init.lua ]; then
    echo -e "${YELLOW}⚠${NC} ~/.config/nvim/init.lua が既に存在します"
    read -p "バックアップして上書きしますか？ (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cp ~/.config/nvim/init.lua ~/.config/nvim/init.lua.backup
        cp config/nvim/init.lua ~/.config/nvim/
        echo -e "${GREEN}✓${NC} Neovim設定をコピー（バックアップ: init.lua.backup）"
    else
        echo "スキップしました"
    fi
else
    cp config/nvim/init.lua ~/.config/nvim/
    echo -e "${GREEN}✓${NC} Neovim設定をコピー"
fi

# filetree設定
cp config/filetree/config.toml ~/.config/filetree/
echo -e "${GREEN}✓${NC} filetree設定をコピー"

# keifu設定
cp config/keifu/config.toml ~/.config/keifu/
echo -e "${GREEN}✓${NC} keifu設定をコピー"

# スクリプト
cp bin/* ~/.local/bin/
chmod +x ~/.local/bin/ghostty-*
echo -e "${GREEN}✓${NC} スクリプトをコピー"

# Ghostty設定
echo ""
echo -e "${YELLOW}⚠${NC} Ghostty設定を手動で追加してください:"
echo "  以下のコマンドを実行："
echo "  cat config/ghostty/config >> ~/Library/Application\\ Support/com.mitchellh.ghostty/config"
echo ""

# zsh設定
if grep -q "Ghostty Vim環境" ~/.zshrc 2>/dev/null; then
    echo -e "${YELLOW}⚠${NC} ~/.zshrcに既に設定が存在します（スキップ）"
else
    echo ""
    read -p "~/.zshrcに設定を追加しますか？ (Y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        cat config/zshrc >> ~/.zshrc
        echo -e "${GREEN}✓${NC} zsh設定を追加"
    fi
fi

echo ""
echo "=== インストール完了 ==="
echo ""
echo -e "${GREEN}✓${NC} すべてのコンポーネントがインストールされました"
echo ""
echo "次のステップ:"
echo "  1. Ghostty設定を追加（上記のcatコマンドを実行）"
echo "  2. ターミナルを再起動または: source ~/.zshrc"
echo "  3. インストール確認: ghostty-vim-check"
echo "  4. 環境起動: gvim"
echo ""
echo "詳細: README.mdを参照"
