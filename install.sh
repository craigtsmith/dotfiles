#!/usr/bin/env bash
#
# Dotfiles Installation Script
# Single entry point for GitHub Codespaces, Coder, and local setup
#
# Usage:
#   ./install.sh              # Full installation
#   ./install.sh --minimal    # Skip heavy tools
#   ./install.sh --verbose    # Show all messages
#   ./install.sh --skip-updates # Skip update checks
#   ./install.sh --force      # Skip checks, run everything
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES="${DOTFILES:-$SCRIPT_DIR}"

export CHANGES_MADE=false
export VERBOSE=false
export MINIMAL_MODE=false
export SKIP_UPDATES=false
export FORCE_MODE=false

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --minimal) MINIMAL_MODE=true ;;
    --verbose) VERBOSE=true ;;
    --skip-updates) SKIP_UPDATES=true ;;
    --force) FORCE_MODE=true ;;
  esac
  shift
done

# Source core helpers
source "$SCRIPT_DIR/scripts/lib.sh"

# Install gum for UI (silently)
_install_gum() {
  command_exists gum && return

  if [[ "$DF_OS_TYPE" == "macos" ]]; then
    brew install gum --quiet >/dev/null 2>&1
  else
    mkdir -p "$HOME/.local/bin"
    local arch="x86_64"
    [[ "$DF_OS_ARCH" == "aarch64" || "$DF_OS_ARCH" == "arm64" ]] && arch="arm64"
    local gum_dir="gum_${GUM_VERSION}_Linux_${arch}"
    curl -sL "https://github.com/charmbracelet/gum/releases/download/v${GUM_VERSION}/${gum_dir}.tar.gz" | tar -xz -C /tmp 2>/dev/null
    mv "/tmp/${gum_dir}/gum" "$HOME/.local/bin/" 2>/dev/null || maybe_sudo mv "/tmp/${gum_dir}/gum" /usr/local/bin/
    rm -rf "/tmp/${gum_dir}" 2>/dev/null
  fi
}

_install_gum

# Source UI and all modules
source "$SCRIPT_DIR/scripts/ui.sh"
source "$SCRIPT_DIR/scripts/bootstrap/mac.sh"
source "$SCRIPT_DIR/scripts/bootstrap/linux.sh"
source "$SCRIPT_DIR/scripts/bootstrap/cross-platform.sh"
source "$SCRIPT_DIR/scripts/install/zsh.sh"
source "$SCRIPT_DIR/scripts/install/omz.sh"
source "$SCRIPT_DIR/scripts/install/backup.sh"
source "$SCRIPT_DIR/scripts/install/stow.sh"
source "$SCRIPT_DIR/scripts/install/tmux.sh"
source "$SCRIPT_DIR/scripts/install/node.sh"
source "$SCRIPT_DIR/scripts/install/coder.sh"
source "$SCRIPT_DIR/scripts/install/opentofu.sh"

main() {
  # Show initial status
  if has_gum; then
    gum spin --spinner dot --title "Checking dotfiles" -- sleep 0.5
  fi

  install_zsh

  if [[ "$MINIMAL_MODE" != "true" ]]; then
    case "$DF_OS_TYPE" in
      macos) bootstrap_mac ;;
      linux) bootstrap_linux ;;
    esac
    bootstrap_cross_platform
  fi

  install_omz
  install_backup
  install_stow
  install_tmux
  install_coder
  install_opentofu

  [[ "$MINIMAL_MODE" != "true" ]] && install_node

  done_message
}

main
