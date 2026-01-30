#!/usr/bin/env bash
#
# Stow dotfile topics
#

install_stow() {
  if ! command_exists stow; then
    warn "stow not installed; cannot stow dotfiles. Run ./install-packages.sh."
    return
  fi

  local topics=(git zsh tmux starship fzf fsh node local agents)

  # Add ghostty on macOS only
  [[ "$DF_OS_TYPE" == "macos" ]] && topics+=(ghostty)

  cd "$DOTFILES"

  info "Stowing topics: ${topics[*]}"

  for topic in "${topics[@]}"; do
    if [[ ! -d "$topic" ]]; then
      info "Skipping $topic (not found)"
      continue
    fi

    # Try normal stow first, fall back to adopt for conflicts
    # -t $HOME needed when DOTFILES isn't directly under $HOME (e.g. Coder)
    if stow -t "$HOME" -R "$topic" 2>/dev/null; then
      info "Stowed $topic"
    elif stow -t "$HOME" --adopt -R "$topic" 2>/dev/null; then
      info "Stowed $topic (adopted)"
    else
      warn "Failed to stow $topic"
    fi
  done

  # Use environment-specific Claude settings
  _install_claude_settings
}

# Copy appropriate Claude settings based on environment
_install_claude_settings() {
  local settings_dir="$HOME/.claude"
  local dest="$settings_dir/settings.json"
  local src="$DOTFILES/agents/.claude/settings.json"

  case "$DF_ENVIRONMENT" in
    coder)
      src="$DOTFILES/agents/.claude/settings.coder.json"
      info "Using coder Claude settings"
      ;;
    codespaces)
      src="$DOTFILES/agents/.claude/settings.codespaces.json"
      info "Using codespaces Claude settings"
      ;;
    *)
      info "Using local Claude settings"
      ;;
  esac

  # Remove symlink if present, then copy
  mkdir -p "$settings_dir"
  [[ -L "$dest" ]] && rm "$dest"
  cp "$src" "$dest"
}
