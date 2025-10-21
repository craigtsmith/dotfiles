#!/usr/bin/env bash
#
# macOS bootstrap - Homebrew packages
#

bootstrap_mac() {
  # Install Homebrew if not present
  if ! command_exists brew; then
    spin "Installing Homebrew" /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$("$HOMEBREW_PREFIX/bin/brew" shellenv)"
    set_just_installed "homebrew"
    CHANGES_MADE=true
  else
    info "Homebrew already installed"
  fi

  # Update Homebrew if needed
  if needs_update "homebrew"; then
    spin "Updating Homebrew" brew update --quiet
    set_updated "homebrew"
    CHANGES_MADE=true
  else
    info "Homebrew update skipped"
  fi

  # Install packages from Brewfile if any are missing
  if ! brew bundle check --file="$DOTFILES/scripts/Brewfile" >/dev/null 2>&1; then
    spin "Installing Homebrew packages" brew bundle install --file="$DOTFILES/scripts/Brewfile" --quiet
    CHANGES_MADE=true
  else
    info "Homebrew packages up to date"
  fi
}
