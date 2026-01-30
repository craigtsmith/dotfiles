#!/usr/bin/env bash
#
# Ensure zsh is installed and set as default
#

install_zsh() {
  # Install zsh if not present
  if ! command_exists zsh; then
    case "$DF_OS_TYPE" in
      macos) spin "Installing zsh" brew install zsh --quiet ;;
      linux) spin "Installing zsh" bash -c "sudo apt-get update -qq && sudo apt-get install -y -qq zsh" ;;
    esac
    CHANGES_MADE=true
  else
    info "zsh already installed"
  fi

  # Set zsh as default shell if not already
  local current_shell zsh_path
  current_shell="$(basename "$SHELL")"
  if [[ "$current_shell" == "zsh" ]]; then
    info "zsh already default shell"
    return
  fi

  zsh_path="$(which zsh)"

  # Add to /etc/shells if not present (Linux)
  if [[ "$DF_OS_TYPE" == "linux" ]]; then
    grep -q "$zsh_path" /etc/shells 2>/dev/null || \
      echo "$zsh_path" | maybe_sudo tee -a /etc/shells >/dev/null
  fi

  # Change shell (skip in Codespaces where it may not persist)
  if [[ "$DF_ENVIRONMENT" != "codespaces" ]]; then
    chsh -s "$zsh_path" 2>/dev/null || true
  fi
  CHANGES_MADE=true
}
