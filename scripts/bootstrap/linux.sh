#!/usr/bin/env bash
#
# Linux bootstrap - apt packages and curl installers
#

# Install apt packages if missing
_install_apt_packages() {
  local packages=(build-essential curl git jq stow tmux unzip wget zsh)
  local missing=()

  for pkg in "${packages[@]}"; do
    dpkg -l "$pkg" >/dev/null 2>&1 || missing+=("$pkg")
  done

  if [[ ${#missing[@]} -gt 0 ]]; then
    spin "Installing apt packages" bash -c "sudo apt-get update -qq && sudo apt-get install -y -qq ${missing[*]}"
    CHANGES_MADE=true
  else
    info "apt packages up to date"
  fi
}

# Install eza via apt repository
_install_eza() {
  if command_exists eza; then
    info "eza already installed"
    return
  fi
  spin "Installing eza" bash -c '
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg 2>/dev/null
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list >/dev/null
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt-get update -qq && sudo apt-get install -y -qq eza
  '
  CHANGES_MADE=true
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

# Install GitHub CLI via apt repository
_install_gh() {
  if command_exists gh; then
    info "gh already installed"
    return
  fi
  spin "Installing GitHub CLI" bash -c '
    sudo mkdir -p -m 755 /etc/apt/keyrings
    wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null
    sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
    sudo apt-get update -qq && sudo apt-get install -y -qq gh
  '
  CHANGES_MADE=true
}

bootstrap_linux() {
  _install_apt_packages

  # Curl-based installers
  install_with_curl starship "Installing starship" \
    "curl -sS https://starship.rs/install.sh | sh -s -- -y >/dev/null 2>&1"
  install_with_curl zoxide "Installing zoxide" \
    "curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash >/dev/null 2>&1"
  install_with_curl direnv "Installing direnv" \
    "curl -sfL https://direnv.net/install.sh | bash >/dev/null 2>&1"
  install_with_curl uv "Installing uv" \
    "curl -LsSf https://astral.sh/uv/install.sh | sh >/dev/null 2>&1"

  # Complex installers
  _install_eza
  _install_fzf
  _install_gh

  # nvm (check directory instead of command)
  if [[ ! -d "$HOME/.nvm" ]]; then
    spin "Installing nvm" bash -c "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash >/dev/null 2>&1"
    CHANGES_MADE=true
  else
    info "nvm already installed"
  fi
}
