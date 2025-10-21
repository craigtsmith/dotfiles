#!/bin/sh

if [ -s "/opt/homebrew/opt/nvm/nvm.sh" ]; then
  export NVM_DIR="$HOME/.nvm"
  . "/opt/homebrew/opt/nvm/nvm.sh"
fi

if ! command -v nvm &> /dev/null; then
  echo "🚨 nvm is not available!"
  exit 1
fi

echo "📦 Installing Node.js"
nvm use 24
nvm alias default 24
echo ""

echo "📦 Installing global npm packages"
if test ! $(which claude)
then
  npm install -g @anthropic-ai/claude-code
fi
echo ""

echo "📦 Enabling pnpm"
npm install -g corepack@latest
corepack enable pnpm
echo ""