# ~/.zshrc - Main zsh configuration
# Consolidated config replacing .zshrc, .zprofile, and .profile

# =============================================================================
# Platform Detection & Homebrew (replaces .zprofile)
# =============================================================================
case "$(uname -s)-$(uname -m)" in
  Darwin-arm64)
    export HOMEBREW_PREFIX="/opt/homebrew"
    export DF_OS_TYPE="macos"
    ;;
  Darwin-x86_64)
    export HOMEBREW_PREFIX="/usr/local"
    export DF_OS_TYPE="macos"
    ;;
  Linux-*)
    export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
    export DF_OS_TYPE="linux"
    ;;
esac

# Detect environment (Codespaces, Coder, local)
if [[ -n "$CODESPACES" ]]; then
  export DF_ENVIRONMENT="codespaces"
elif [[ -n "$CODER" ]] || [[ -n "$CODER_WORKSPACE_ID" ]]; then
  export DF_ENVIRONMENT="coder"
else
  export DF_ENVIRONMENT="local"
fi

# Initialize Homebrew if available
if [[ -x "$HOMEBREW_PREFIX/bin/brew" ]]; then
  eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
fi

# =============================================================================
# Environment Variables
# =============================================================================
export DOTFILES="$HOME/.dotfiles"
export ZSH="$HOME/.oh-my-zsh"

# Editor - cursor only available on local macOS
if [[ -n "$SSH_CONNECTION" ]]; then
  export EDITOR='nano'
elif [[ "$DF_OS_TYPE" == "macos" ]] && [[ "$DF_ENVIRONMENT" == "local" ]]; then
  export EDITOR="cursor --wait"
else
  export EDITOR='nano'
fi

# =============================================================================
# Oh My Zsh Configuration
# =============================================================================
# Base plugins (cross-platform)
plugins=(
  aliases
  direnv
  docker
  eza
  fast-syntax-highlighting
  fzf
  git
  nvm
  ssh
  starship
  zoxide
  zsh-uv-env
)

# Platform-specific plugins
if [[ "$DF_OS_TYPE" == "macos" ]]; then
  plugins+=(1password brew macos)
fi

# Plugin settings
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

zstyle ':omz:plugins:eza' 'dirs-first' yes
zstyle ':omz:plugins:eza' 'icons' yes

zstyle ':omz:plugins:nvm' lazy yes
zstyle ':omz:plugins:nvm' autoload yes
zstyle ':omz:plugins:nvm' silent-autoload yes

# Load Oh My Zsh
[[ -f "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

# =============================================================================
# PATH Configuration (replaces .profile)
# =============================================================================
# Local bin
if [[ -d "$HOME/.local/bin" ]]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

# Docker
if [[ -d "$HOME/.docker/bin" ]]; then
  export PATH="$HOME/.docker/bin:$PATH"
fi

# pnpm - platform-aware path
if [[ "$DF_OS_TYPE" == "macos" ]]; then
  export PNPM_HOME="$HOME/Library/pnpm"
else
  export PNPM_HOME="$HOME/.local/share/pnpm"
fi
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# bun
export BUN_INSTALL="$HOME/.bun"
if [[ -d "$BUN_INSTALL" ]]; then
  export PATH="$BUN_INSTALL/bin:$PATH"
  [[ -s "$BUN_INSTALL/_bun" ]] && source "$BUN_INSTALL/_bun"
fi

# =============================================================================
# Modular Configuration Loading
# =============================================================================
# Source all .zsh files from ~/.config/zsh/
if [[ -d "$HOME/.config/zsh" ]]; then
  for file in "$HOME/.config/zsh"/*.zsh(N); do
    source "$file"
  done
fi

# =============================================================================
# Local Configuration
# =============================================================================
# Source local secrets/overrides (not tracked in git)
[[ -f "$HOME/.localrc" ]] && source "$HOME/.localrc"
