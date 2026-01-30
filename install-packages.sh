#!/usr/bin/env bash
#
# Manual package installation (happy path)
# Run this script explicitly before ./install.sh if you need packages.
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES="${DOTFILES:-$SCRIPT_DIR}"

export CHANGES_MADE=false
export VERBOSE=false
export SKIP_UPDATES=false
export FORCE_MODE=false

source "$SCRIPT_DIR/scripts/lib.sh"
source "$SCRIPT_DIR/scripts/ui.sh"
source "$SCRIPT_DIR/scripts/bootstrap/mac.sh"
source "$SCRIPT_DIR/scripts/bootstrap/linux.sh"
source "$SCRIPT_DIR/scripts/bootstrap/cross-platform.sh"

main() {
  case "$DF_OS_TYPE" in
    macos) bootstrap_mac ;;
    linux) bootstrap_linux ;;
    *)
      error "Unsupported OS: $DF_OS_TYPE"
      exit 1
      ;;
  esac

  bootstrap_cross_platform

  if [[ "$CHANGES_MADE" == "true" ]]; then
    tick "packages installed"
  else
    tick "packages already installed"
  fi

  echo "Run ./install.sh to apply dotfiles"
}

main
