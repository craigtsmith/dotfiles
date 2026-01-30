#!/usr/bin/env bash
#
# Stow dotfile topics
#

install_stow() {
  local stow_ready=true

  if ! command_exists stow; then
    if [[ "$MINIMAL_MODE" == "true" ]]; then
      error "stow is required for --minimal; install it or run without --minimal"
      return 1
    fi

    case "$DF_OS_TYPE" in
      macos)
        spin "Installing stow" brew install stow --quiet
        CHANGES_MADE=true
        ;;
      linux)
        if ! sudo_available; then
          warn "sudo required to install stow; skipping stow."
          stow_ready=false
        else
          spin "Installing stow" bash -c "export -f maybe_sudo; maybe_sudo apt-get update -qq && maybe_sudo apt-get install -y -qq stow"
          CHANGES_MADE=true
        fi
        ;;
      *)
        warn "Unsupported OS for stow install"
        return 1
        ;;
    esac
  fi

  local topics=(git zsh tmux starship fzf fsh node local agents)

  # Add ghostty on macOS only
  [[ "$DF_OS_TYPE" == "macos" ]] && topics+=(ghostty)

  if [[ "$stow_ready" == "true" ]]; then
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

  fi

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
