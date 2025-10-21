#!/bin/sh

# Check for Homebrew
if test ! $(which brew)
then
  echo "📦 Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if test $(which brew)
then
  echo "🔄 Updating Homebrew"
  brew update

  echo "🍺 Installing brews"
  brew bundle install --file=$DOTFILES/lib/homebrew/Brewfile
fi

exit 0
