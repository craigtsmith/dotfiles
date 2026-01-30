#!/usr/bin/env bash
#
# Node.js checks via nvm
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

_sanitize_npmrc() {
  local npmrc="$HOME/.npmrc"

  _npmrc_has_prefix || return 0

  if [[ ! -w "$npmrc" ]]; then
    warn ".npmrc has prefix/globalconfig but isn't writable; skipping"
    return 0
  fi

  local backup="${npmrc}.dotfiles.$(date +%Y%m%d%H%M%S).bak"

  if ! cp "$npmrc" "$backup" 2>/dev/null; then
    warn "Unable to backup .npmrc; skipping cleanup"
    return 0
  fi

  grep -Ev '^\s*(prefix|globalconfig)\s*=' "$npmrc" > "${npmrc}.tmp" || true
  mv "${npmrc}.tmp" "$npmrc"
  warn "Removed prefix/globalconfig from .npmrc (backup saved)"
}

install_node() {
  _source_nvm

  if [[ "$DF_ENVIRONMENT" == "coder" ]]; then
    _sanitize_npmrc
  fi

  if ! command_exists node; then
    warn "Node.js not installed; skipping Node setup. Run ./install-packages.sh."
    return
  fi

  if ! type nvm >/dev/null 2>&1; then
    warn "nvm not available; skipping Node version management."
    return
  fi

  local node_version
  node_version="$(_get_node_version)"

  if ! nvm ls "$node_version" >/dev/null 2>&1; then
    warn "Node.js $node_version not installed via nvm; skipping."
    return
  fi

  nvm alias default "$node_version" >/dev/null 2>&1 || true
  nvm use "$node_version" >/dev/null 2>&1 || true
  info "Node.js $node_version already installed"
}
