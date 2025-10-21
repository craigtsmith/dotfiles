#!/bin/sh

OMZ_DIR="$HOME/.oh-my-zsh"

# Check for Oh My ZSH
if [ ! -d "$OMZ_DIR" ]; then
  echo "📦 Installing Oh My ZSH"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  rm $HOME/.zshrc.pre-oh-my-zsh
else
  echo "🔄 Updating Oh My ZSH"
  git -C "$OMZ_DIR" pull --ff-only
fi

echo ""

source $DOTFILES/lib/omz/zsh-fsh/omz.sh
source $DOTFILES/lib/omz/zsh-uv-env/omz.sh

exit 0



