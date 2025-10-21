#!/usr/bin/env bash
#
# Cross-platform tools installed via curl
#

bootstrap_cross_platform() {
  # bun
  if ! command_exists bun; then
    spin "Installing bun" bash -c "curl -fsSL https://bun.sh/install | bash >/dev/null 2>&1"
    CHANGES_MADE=true
  else
    info "bun already installed"
  fi
}
