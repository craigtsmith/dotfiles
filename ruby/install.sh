#!/bin/sh
echo "\n"

if test ! $(which rbenv)
then
  echo "  Installing rbenv for you."
  brew install rbenv
  echo "  ------\n"
fi

if test ! $(which ruby-build)
then
  echo "  Installing ruby-build for you."
  brew install ruby-build
  echo "  ------\n"
fi

if ! [[ -a ~/.rbenv/plugins/rbenv-vars ]]
then
  echo "  Installing rbenv-vars plugin for you"
  mkdir -p ~/.rbenv/plugins
  cd ~/.rbenv/plugins
  git clone https://github.com/sstephenson/rbenv-vars.git
  echo "  ------\n"
else
  echo "  updating rbenv-vars plugin for you"
  cd ~/.rbenv/plugins/rbenv-vars
  git pull --prune
  echo "  ------\n"
fi

if ! [[ -a ~/.rbenv/plugins/rbenv-default-gems ]]
then
  echo "  Installing rbenv-default-gems plugin for you"
  mkdir -p ~/.rbenv/plugins
  cd ~/.rbenv/plugins
  git clone https://github.com/sstephenson/rbenv-default-gems.git
  ln -s $ZSH/ruby/default-gems ~/.rbenv/default-gems
  echo "  ------\n"
else
  echo "  updating rbenv-default-gems plugin for you"
  ln -s $ZSH/ruby/default-gems ~/.rbenv/default-gems
  cd ~/.rbenv/plugins/rbenv-default-gems
  git pull --prune
  echo "  ------\n"
fi

echo "  Installing some rubies"
rbenv install 1.9.3-p327
rbenv install 2.0.0-p247
rbenv global 2.0.0-p247

echo "------------\n"
exit 0
