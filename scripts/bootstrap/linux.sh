#!/usr/bin/env bash
#
# Linux bootstrap - install essentials and tools
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

# Install fzf from git
_install_fzf() {
  if command_exists fzf; then
    info "fzf already installed"
    return
  fi
  spin "Installing fzf" bash -c '
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf" 2>/dev/null
    "$HOME/.fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish >/dev/null 2>&1
  '
  CHANGES_MADE=true
}

# Warn about tools that need apt repos with GPG keys
_check_apt_tools() {
  local missing=()

  command_exists eza || missing+=("eza (ls replacement)")
  command_exists gh || missing+=("gh (GitHub CLI)")

  if [[ ${#missing[@]} -gt 0 ]]; then
    warn "Tools requiring apt repos not found: ${missing[*]}"
    info "Install manually: https://github.com/eza-community/eza, https://cli.github.com"
  fi
}

bootstrap_linux() {
  _install_essential_apt_packages

  # Ensure ~/.local/bin exists for user installs
  mkdir -p "$HOME/.local/bin"

  # Curl-based installers (install to ~/.local/bin to avoid sudo)
  install_with_curl starship "Installing starship" \
    "curl -sS https://starship.rs/install.sh | sh -s -- -y -b ~/.local/bin"
  install_with_curl zoxide "Installing zoxide" \
    "curl -sSf https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash"
  install_with_curl direnv "Installing direnv" \
    "curl -sfL https://direnv.net/install.sh | bash"
  install_with_curl uv "Installing uv" \
    "curl -LsSf https://astral.sh/uv/install.sh | sh"

  # Git-based installers
  _install_fzf

  # Warn about tools that need apt repos (GPG keys can fail)
  _check_apt_tools

  # nvm (check directory instead of command)
  if [[ ! -d "$HOME/.nvm" ]]; then
    spin "Installing nvm" bash -c "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash >/dev/null 2>&1"
    CHANGES_MADE=true
  else
    info "nvm already installed"
  fi
}
