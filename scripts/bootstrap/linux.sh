#!/usr/bin/env bash
#
# Linux bootstrap - install essentials, warn about optional tools
#

# Install essential apt packages needed for dotfiles to work
_install_essential_apt_packages() {
  local packages=(curl git stow tmux zsh)
  local missing=()

  for pkg in "${packages[@]}"; do
    dpkg -l "$pkg" >/dev/null 2>&1 || missing+=("$pkg")
  done

  if [[ ${#missing[@]} -gt 0 ]]; then
    # apt-get update can warn about repos but still work
    sudo apt-get update -qq 2>/dev/null || true
    spin "Installing essentials" bash -c "sudo apt-get install -y -qq ${missing[*]}"
    CHANGES_MADE=true
  else
    info "Essential packages up to date"
  fi
}

# Warn about missing optional tools that have stow configs
_check_optional_tools() {
  local missing=()

  command_exists starship || missing+=("starship (prompt)")
  command_exists fzf || missing+=("fzf (fuzzy finder)")
  command_exists eza || missing+=("eza (ls replacement)")
  command_exists zoxide || missing+=("zoxide (cd replacement)")
  command_exists direnv || missing+=("direnv (env management)")
  command_exists gh || missing+=("gh (GitHub CLI)")
  command_exists uv || missing+=("uv (Python)")

  if [[ ${#missing[@]} -gt 0 ]]; then
    warn "Optional tools not found: ${missing[*]}"
    info "Install manually for full functionality"
  fi
}

bootstrap_linux() {
  _install_essential_apt_packages

  # Ensure ~/.local/bin exists for user installs
  mkdir -p "$HOME/.local/bin"

  # Warn about missing optional tools
  _check_optional_tools

  # nvm (check directory instead of command)
  if [[ ! -d "$HOME/.nvm" ]]; then
    spin "Installing nvm" bash -c "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash >/dev/null 2>&1"
    CHANGES_MADE=true
  else
    info "nvm already installed"
  fi
}
