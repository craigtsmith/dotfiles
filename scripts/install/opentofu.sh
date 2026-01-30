#!/usr/bin/env bash
#
# OpenTofu installation
#

install_opentofu() {
  install_with_curl "tofu" "Installing OpenTofu" \
    "curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh | sh -s -- --install-method standalone >/dev/null 2>&1"
}
