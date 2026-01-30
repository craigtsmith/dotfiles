#!/usr/bin/env bash
#
# Tmux plugin manager
#

install_tmux() {
  if ! command_exists tmux; then
    warn "tmux not installed; skipping TPM."
    return
  fi

  if ! command_exists git; then
    warn "git not installed; skipping TPM."
    return
  fi

  local tpm_dir="$HOME/.tmux/plugins/tpm"

  if install_or_update_repo "https://github.com/tmux-plugins/tpm" "$tpm_dir" "tpm" "Installing Tmux Plugin Manager" "Updating Tmux Plugin Manager"; then
    "$tpm_dir/bin/install_plugins" >/dev/null 2>&1 || true
  else
    info "Tmux Plugin Manager up to date"
  fi
}
