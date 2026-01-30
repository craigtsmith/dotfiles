#!/usr/bin/env bash
#
# Coder CLI check
#

install_coder() {
  # Skip in coder environments (already has CLI)
  if [[ "$DF_ENVIRONMENT" == "coder" ]]; then
    info "Coder CLI available in workspace"
    return
  fi

  if command_exists coder; then
    info "Coder CLI already installed"
    return
  fi

  warn "Coder CLI not installed; run ./install-packages.sh."
}
