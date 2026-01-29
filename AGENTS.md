# AGENTS.md

This file provides guidance to agents when working with code in this repository.

## Commands

```bash
./install.sh              # Full installation
./install.sh --minimal    # CI/containers (skip heavy tools)
./install.sh --skip-updates  # Skip update checks for git repos

stow -R <package>         # Re-stow a single package after changes
brew bundle install --file=scripts/Brewfile  # Install Homebrew packages
```

## Architecture

GNU Stow-based dotfiles. Each top-level directory is a stow package symlinked into `$HOME`.

### Stow Packages

- `zsh/` - Shell config (`.zshrc`, `.config/zsh/*.zsh`)
- `git/` - Git config (`.gitconfig`, `.gitconfig.local`)
- `tmux/` - Tmux config (`.tmux.conf`)
- `agents/` - Global AI agent settings stowed to `~/.config/agents/` and `~/.claude/`
- `starship/`, `fzf/`, `fsh/`, `node/` - Tool configs in `.config/`
- `ghostty/` - macOS-only terminal config
- `local/` - Scripts in `.local/bin/`

### File Conventions

- `AGENTS.md` - Canonical file, `CLAUDE.md` symlinks to it
- Repo root: project-specific instructions (this file)
- `agents/.config/agents/AGENTS.md` - Global agent defaults (stowed to all projects)

### Scripts

- `scripts/lib.sh` - Core helpers (OS detection, `clone_or_update`, `backup_file`)
- `scripts/ui.sh` - UI helpers using gum
- `scripts/bootstrap/` - Platform setup (mac.sh, linux.sh)
- `scripts/install/` - Module installers (zsh, omz, stow, tmux, node)

### Key Patterns

- OS: `DF_OS_TYPE` (macos/linux), `DF_OS_ARCH`
- Environment: `DF_ENVIRONMENT` (codespaces/coder/local)
- Update throttling: 7-day interval in `.update-timestamps`
- Claude settings: copied (not symlinked) with environment variants

### Local Overrides

- `~/.localrc` - Secrets/env vars (sourced by .zshrc)
- `~/.gitconfig.local` - Git user info
