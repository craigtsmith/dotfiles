#!/usr/bin/env bash
#
# Core helper functions for dotfiles
#

# Tool versions
export GUM_VERSION="0.16.0"
export NVM_VERSION="0.40.1"

# Update tracking file
UPDATE_FILE="$DOTFILES/.update-timestamps"
UPDATE_INTERVAL=$((7 * 24 * 60 * 60))  # 7 days in seconds

# Check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Detect OS type and architecture
detect_os() {
  local uname_s uname_m
  uname_s="$(uname -s)"
  uname_m="$(uname -m)"

  case "$uname_s" in
    Darwin)
      DF_OS_TYPE="macos"
      case "$uname_m" in
        arm64)
          DF_OS_ARCH="arm64"
          HOMEBREW_PREFIX="/opt/homebrew"
          ;;
        x86_64)
          DF_OS_ARCH="x86_64"
          HOMEBREW_PREFIX="/usr/local"
          ;;
      esac
      ;;
    Linux)
      DF_OS_TYPE="linux"
      DF_OS_ARCH="$uname_m"
      HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
      ;;
    *)
      DF_OS_TYPE="unknown"
      DF_OS_ARCH="unknown"
      HOMEBREW_PREFIX=""
      ;;
  esac

  export DF_OS_TYPE DF_OS_ARCH HOMEBREW_PREFIX
}

# Detect environment (Codespaces, Coder, local)
detect_environment() {
  if [[ -n "$CODESPACES" ]]; then
    DF_ENVIRONMENT="codespaces"
  elif [[ -n "$CODER" ]] || [[ -n "$CODER_WORKSPACE_ID" ]]; then
    DF_ENVIRONMENT="coder"
  else
    DF_ENVIRONMENT="local"
  fi

  export DF_ENVIRONMENT
}

# Handle sudo in environments that may not have it
maybe_sudo() {
  if command_exists sudo && [[ "$(id -u)" -ne 0 ]]; then
    sudo "$@"
  else
    "$@"
  fi
}

# Pre-authenticate sudo before running spinner commands
# This prompts for password upfront so spinners don't swallow the prompt
require_sudo() {
  [[ "$(id -u)" -eq 0 ]] && return 0
  command_exists sudo || return 0
  sudo -v
}

# Backup a file if it exists and is not a symlink
# Returns 0 if backed up, 1 if nothing to do
backup_file() {
  local file="$1"
  local backup_dir="${DOTFILES}/backups"

  if [[ -e "$file" ]] && [[ ! -L "$file" ]]; then
    mkdir -p "$backup_dir"
    local backup_name="$(basename "$file").$(date +%Y%m%d%H%M%S)"
    mv "$file" "$backup_dir/$backup_name"
    return 0
  fi
  return 1
}

# Check if something needs updating (>7 days since last update)
needs_update() {
  local key="$1"
  local now last_update

  # Force mode always returns true (needs update)
  [[ "$FORCE_MODE" == "true" ]] && return 0

  # Skip all update checks if SKIP_UPDATES is set
  [[ "$SKIP_UPDATES" == "true" ]] && return 1

  [[ ! -f "$UPDATE_FILE" ]] && return 0

  now=$(date +%s)
  last_update=$(grep "^${key}=" "$UPDATE_FILE" 2>/dev/null | cut -d= -f2)

  [[ -z "$last_update" ]] && return 0
  [[ $((now - last_update)) -gt $UPDATE_INTERVAL ]] && return 0

  return 1
}

# Mark something as updated
set_updated() {
  local key="$1"
  local now
  now=$(date +%s)

  mkdir -p "$(dirname "$UPDATE_FILE")"

  if [[ -f "$UPDATE_FILE" ]]; then
    # Remove old entry and add new one
    grep -v "^${key}=" "$UPDATE_FILE" > "$UPDATE_FILE.tmp" 2>/dev/null || true
    mv "$UPDATE_FILE.tmp" "$UPDATE_FILE"
  fi

  echo "${key}=${now}" >> "$UPDATE_FILE"
}

# Mark something as just installed (resets update timer)
set_just_installed() {
  set_updated "$1"
}

# Install or update a git repository
# Usage: install_or_update_repo "repo_url" "destination" "name" "install_label" "update_label"
# Returns 0 if changes made, 1 if no changes
install_or_update_repo() {
  local repo="$1"
  local dest="$2"
  local name="$3"
  local install_label="${4:-Installing $name}"
  local update_label="${5:-Updating $name}"

  if [[ ! -d "$dest" ]]; then
    spin "$install_label" git clone --quiet "$repo" "$dest"
    set_just_installed "$name"
    CHANGES_MADE=true
    return 0
  elif needs_update "$name"; then
    spin "$update_label" git -C "$dest" pull --ff-only --quiet
    set_updated "$name"
    CHANGES_MADE=true
    return 0
  fi
  return 1
}

# Install an OMZ plugin from a git repository
# Usage: install_omz_plugin "plugin_name" "repo_url"
install_omz_plugin() {
  local plugin_name="$1"
  local repo="$2"
  local omz_dir="$HOME/.oh-my-zsh"
  local dest="${ZSH_CUSTOM:-$omz_dir/custom}/plugins/$plugin_name"

  if ! install_or_update_repo "$repo" "$dest" "$plugin_name" "Installing $plugin_name" "Updating $plugin_name"; then
    info "$plugin_name already installed"
  fi
}

# Install a tool via curl if not present (or force reinstall)
# Runs WITHOUT spinner since external scripts may need interactive input
# Usage: install_with_curl "command" "label" "curl_command"
install_with_curl() {
  local cmd="$1"
  local label="$2"
  local curl_cmd="$3"

  if [[ "$FORCE_MODE" == "true" ]] || ! command_exists "$cmd"; then
    printf "  %s...\n" "$label"
    if bash -c "$curl_cmd"; then
      CHANGES_MADE=true
    else
      error "$label failed"
      return 1
    fi
  else
    info "$cmd already installed"
  fi
}

# Initialize
detect_os
detect_environment
