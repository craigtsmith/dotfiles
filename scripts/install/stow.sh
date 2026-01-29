#!/usr/bin/env bash
#
# Stow dotfile topics
#

install_stow() {
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
    if stow -R "$topic" 2>/dev/null; then
      info "Stowed $topic"
    elif stow --adopt -R "$topic" 2>/dev/null; then
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

  # Use coder settings in coder environment
  if [[ "$DF_ENVIRONMENT" == "coder" ]]; then
    src="$DOTFILES/agents/.claude/settings.coder.json"
    info "Using coder Claude settings"
  else
    info "Using local Claude settings"
  fi

  # Remove symlink if present, then copy
  mkdir -p "$settings_dir"
  [[ -L "$dest" ]] && rm "$dest"
  cp "$src" "$dest"
}
