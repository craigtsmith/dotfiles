#!/usr/bin/env bash
#
# Oh My Zsh installation and plugins
#

install_omz() {
  if ! command_exists git; then
    warn "git not installed; skipping Oh My Zsh."
    return
  fi

  if ! command_exists zsh; then
    warn "zsh not installed; skipping Oh My Zsh."
    return
  fi

  local omz_dir="$HOME/.oh-my-zsh"

  if ! install_or_update_repo "https://github.com/ohmyzsh/ohmyzsh.git" "$omz_dir" "omz" "Installing Oh My Zsh" "Updating Oh My Zsh"; then
    info "Oh My Zsh up to date"
  fi

  # Install plugins
  install_omz_plugin "fast-syntax-highlighting" "https://github.com/zdharma-continuum/fast-syntax-highlighting.git"
  install_omz_plugin "zsh-uv-env" "https://github.com/matthiasha/zsh-uv-env.git"
}
