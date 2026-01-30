#!/usr/bin/env bash
#
# Coder CLI installation
#

install_coder() {
  # Skip in coder environments (already has CLI)
  if [[ "$DF_ENVIRONMENT" == "coder" ]]; then
    info "Coder CLI available in workspace"
    return
  fi

  install_with_curl "coder" "Installing Coder CLI" \
    "curl -fsSL https://coder.com/install.sh | sh >/dev/null 2>&1"
}
