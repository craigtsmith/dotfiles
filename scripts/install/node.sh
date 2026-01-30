#!/usr/bin/env bash
#
# Node.js setup via nvm
#

# Source nvm from known locations
_source_nvm() {
  export NVM_DIR="$HOME/.nvm"

  if [[ "$DF_OS_TYPE" == "macos" ]] && [[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ]]; then
    source "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
  elif [[ -s "$NVM_DIR/nvm.sh" ]]; then
    source "$NVM_DIR/nvm.sh"
  fi
}

# Get configured node version
_get_node_version() {
  local version_file="$DOTFILES/node/.config/node/version"
  if [[ -f "$version_file" ]]; then
    tr -d '[:space:]' < "$version_file"
  else
    echo "lts/*"
  fi
}

# Check for npmrc settings that break nvm
_npmrc_has_prefix() {
  [[ -f "$HOME/.npmrc" ]] || return 1
  grep -Eq '^\s*(prefix|globalconfig)\s*=' "$HOME/.npmrc"
}

# Install default packages from config
_install_default_packages() {
  local packages_file="$DOTFILES/node/.config/node/default-packages"
  [[ ! -f "$packages_file" ]] && return

  while IFS= read -r package || [[ -n "$package" ]]; do
    [[ "$package" =~ ^#.*$ || -z "$package" ]] && continue
    spin "Installing $package" bash -c "pnpm add -g \"$package\" >/dev/null 2>&1 || npm install -g \"$package\" >/dev/null 2>&1"
  done < "$packages_file"
}

install_node() {
  _source_nvm

  # Exit if nvm is not available
  if ! type nvm >/dev/null 2>&1; then
    info "nvm not available, skipping Node.js"
    return
  fi

  local node_version
  node_version="$(_get_node_version)"

  # Skip if version already installed
  if nvm ls "$node_version" >/dev/null 2>&1; then
    info "Node.js $node_version already installed"
    return
  fi

  # Install node (nvm is a shell function, must run in subshell for spinner)
  spin "Installing Node.js $node_version" bash -c "
    export NVM_DIR=\"\$HOME/.nvm\"
    [ -s \"\$NVM_DIR/nvm.sh\" ] && . \"\$NVM_DIR/nvm.sh\"
    nvm install $node_version >/dev/null 2>&1
  "

  if [[ "$DF_ENVIRONMENT" == "coder" ]] && _npmrc_has_prefix; then
    warn "npmrc prefix/globalconfig detected; running nvm use --delete-prefix"
    nvm use --delete-prefix "$node_version" --silent >/dev/null 2>&1 || true
  fi

  nvm alias default "$node_version" >/dev/null 2>&1
  nvm use default >/dev/null 2>&1 || true
  CHANGES_MADE=true

  # Setup pnpm and default packages
  spin "Enabling pnpm" bash -c "npm install -g corepack@latest >/dev/null 2>&1 && corepack enable pnpm >/dev/null 2>&1"
  _install_default_packages
}
