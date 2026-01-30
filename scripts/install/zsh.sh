#!/usr/bin/env bash
#
# Ensure zsh is installed and set as default
#

_enable_zsh_fallback() {
  local bashrc="$HOME/.bashrc"
  local marker_start="# >>> dotfiles zsh >>>"
  local marker_end="# <<< dotfiles zsh <<<"

  if [[ -f "$bashrc" ]] && grep -q "$marker_start" "$bashrc" 2>/dev/null; then
    return
  fi

  {
    echo ""
    echo "$marker_start"
    echo "if command -v zsh >/dev/null 2>&1 && [[ -z \"$ZSH_VERSION\" ]]; then"
    echo "  exec zsh"
    echo "fi"
    echo "$marker_end"
  } >> "$bashrc"

  info "Added zsh fallback to $bashrc"
}

install_zsh() {
  # Install zsh if not present
  if ! command_exists zsh; then
    case "$DF_OS_TYPE" in
      macos) spin "Installing zsh" brew install zsh --quiet ;;
      linux)
        if ! sudo_available; then
          warn "sudo required to install zsh; skipping."
          return
        fi
        spin "Installing zsh" bash -c "export -f maybe_sudo; maybe_sudo apt-get update -qq && maybe_sudo apt-get install -y -qq zsh"
        ;;

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
    if sudo_available; then
      grep -q "$zsh_path" /etc/shells 2>/dev/null || \
        echo "$zsh_path" | maybe_sudo tee -a /etc/shells >/dev/null
    else
      warn "sudo required to update /etc/shells; skipping."
    fi
  fi

  # Change shell (skip in Codespaces where it may not persist)
  if [[ "$DF_ENVIRONMENT" != "codespaces" ]]; then
    chsh -s "$zsh_path" 2>/dev/null || true
  fi

  if [[ "$DF_ENVIRONMENT" == "coder" ]]; then
    _enable_zsh_fallback
  fi

  CHANGES_MADE=true
}
