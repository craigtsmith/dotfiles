#!/usr/bin/env bash
#
# Tmux plugin manager
#

install_tmux() {
  if ! command_exists tmux; then
    info "tmux not installed, skipping TPM"
    return
  fi

  local tpm_dir="$HOME/.tmux/plugins/tpm"

  if [[ ! -d "$tpm_dir" ]]; then
    spin "Installing Tmux Plugin Manager" git clone --quiet https://github.com/tmux-plugins/tpm "$tpm_dir"
    set_just_installed "tpm"
    CHANGES_MADE=true
    "$tpm_dir/bin/install_plugins" >/dev/null 2>&1 || true
  elif needs_update "tpm"; then
    spin "Updating Tmux Plugin Manager" git -C "$tpm_dir" pull --ff-only --quiet
    set_updated "tpm"
    CHANGES_MADE=true
  else
    info "Tmux Plugin Manager up to date"
  fi
}
