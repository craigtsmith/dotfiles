#!/usr/bin/env bash
#
# Dotfiles Installation Script
# Single entry point for GitHub Codespaces, Coder, and local setup
#
# Usage:
#   ./install.sh              # Install dotfiles (no packages)
#   ./install.sh --minimal    # Skip optional tooling setup
#   ./install.sh --verbose    # Show all messages
#   ./install.sh --skip-updates # Skip update checks
#   ./install.sh --force      # Skip checks, run everything
#   ./install-packages.sh     # Manually install packages
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

# Source UI and all modules
source "$SCRIPT_DIR/scripts/ui.sh"
source "$SCRIPT_DIR/scripts/install/zsh.sh"
source "$SCRIPT_DIR/scripts/install/omz.sh"
source "$SCRIPT_DIR/scripts/install/backup.sh"
source "$SCRIPT_DIR/scripts/install/stow.sh"
source "$SCRIPT_DIR/scripts/install/tmux.sh"
source "$SCRIPT_DIR/scripts/install/node.sh"
source "$SCRIPT_DIR/scripts/install/coder.sh"

warn_missing_packages() {
  local required=(git stow zsh)
  local optional=(tmux fzf eza starship zoxide direnv uv bun gh gum)
  local missing_required=()
  local missing_optional=()

  for tool in "${required[@]}"; do
    command_exists "$tool" || missing_required+=("$tool")
  done

  for tool in "${optional[@]}"; do
    command_exists "$tool" || missing_optional+=("$tool")
  done

  if [[ ${#missing_required[@]} -gt 0 ]]; then
    warn "Missing required tools: ${missing_required[*]}"
  fi

  if [[ ${#missing_optional[@]} -gt 0 ]]; then
    warn "Missing optional tools: ${missing_optional[*]}"
  fi

  if [[ ${#missing_required[@]} -gt 0 || ${#missing_optional[@]} -gt 0 ]]; then
    warn "Run ./install-packages.sh to install prerequisites."
  fi
}

# Avoid failing Coder deployments on non-critical installer errors.
if [[ "$DF_ENVIRONMENT" == "coder" ]]; then
  set +e
fi

main() {
  warn_missing_packages

  # Show initial status
  if has_gum; then
    gum spin --spinner dot --title "Checking dotfiles" -- sleep 0.5
  fi

  install_zsh
  install_omz
  install_backup
  install_stow
  install_tmux
  install_coder

  [[ "$MINIMAL_MODE" != "true" ]] && install_node

  done_message
}

main
