#!/bin/sh

ZUVE_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-uv-env"

if [ ! -d "$ZUVE_DIR" ]; then
  echo "📦 Installing zsh-uv-env"
  git clone https://github.com/matthiasha/zsh-uv-env.git "$ZUVE_DIR"
else
  echo "🔄 Updating zsh-uv-env"
  git -C "$ZUVE_DIR" pull --ff-only
fi

echo ""