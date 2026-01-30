#!/usr/bin/env bash
#
# OpenTofu installation
#

install_opentofu() {
  if [[ "$FORCE_MODE" == "true" ]] || ! command_exists tofu; then
    require_sudo
    spin "Installing OpenTofu" bash -c \
      "curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh | sudo sh -s -- --install-method standalone >/dev/null 2>&1"
    CHANGES_MADE=true
  else
    info "tofu already installed"
  fi
}
