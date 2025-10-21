#!/usr/bin/env bash
#
# Oh My Zsh installation and plugins
#

install_omz() {
  local omz_dir="$HOME/.oh-my-zsh"

  # Install or update Oh My Zsh
  if [[ ! -d "$omz_dir" ]]; then
    spin "Installing Oh My Zsh" bash -c 'RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" >/dev/null 2>&1'
    set_just_installed "omz"
    CHANGES_MADE=true
  elif needs_update "omz"; then
    spin "Updating Oh My Zsh" git -C "$omz_dir" pull --ff-only --quiet
    set_updated "omz"
    CHANGES_MADE=true
  else
    info "Oh My Zsh up to date"
  fi

  # Install plugins
  install_omz_plugin "fast-syntax-highlighting" "https://github.com/zdharma-continuum/fast-syntax-highlighting.git"
  install_omz_plugin "zsh-uv-env" "https://github.com/matthiasha/zsh-uv-env.git"
}
