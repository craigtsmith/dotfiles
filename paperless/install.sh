#!/bin/sh
echo "\n"
#
# Paperless
#
# This istalls the stuff needed for my paperless workflow

# Check for Homebrew
if test ! $(which brew)
then
  echo "  Installing Homebrew for you."
  ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
fi

# Update Brew
brew update
 
# We need a custom formula for now
brew tap craigtsmith/homebrew-additions

# Install what we can from brew
brew install exact-image tag tesseract

exit 0
