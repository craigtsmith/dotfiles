#!/bin/sh

FSH_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting"

if [ ! -d "$FSH_DIR" ]; then
  echo "📦 Installing fast-syntax-highlighting"
  git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$FSH_DIR"
else
  echo "🔄 Updating fast-syntax-highlighting"
  git -C "$FSH_DIR" pull --ff-only
fi

echo ""