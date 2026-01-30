```
      .o8                .    .o88o.  o8o  oooo
     "888              .o8    888 `"  `"'  `888
 .oooo888   .ooooo.  .o888oo o888oo  oooo   888   .ooooo.   .oooo.o
d88' `888  d88' `88b   888    888    `888   888  d88' `88b d88(  "8
888   888  888   888   888    888     888   888  888ooo888 `"Y88b.
888   888  888   888   888 .  888     888   888  888    .o o.  )88b
`Y8bod88P" `Y8bod8P'   "888" o888o   o888o o888o `Y8bod8P' 8""888P'
```

Personal dotfiles for macOS and Linux using [GNU Stow](https://www.gnu.org/software/stow/).

## Install

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install-packages.sh   # manual package install (optional)
./install.sh            # stow dotfiles
./install.sh --minimal  # CI/containers
```

Package installation is manual. `./install.sh` will warn about any missing tools.

## Support matrix

- macOS (Homebrew)
- Ubuntu/Debian (apt)
- Codespaces (Ubuntu + no `chsh`)
- Coder workspaces (Ubuntu + `-t $HOME` stow)

## Requirements

- Packages are installed manually via `./install-packages.sh` (or preinstalled in your image).
- macOS: Homebrew + Brewfile packages
- Linux: apt + sudo (or root) for package installs
- Minimal mode: `stow` must already exist

## Local Config

- `~/.localrc` - secrets/env vars
- `~/.gitconfig.local` - git user info

<details>
<summary>Core tools (install-packages.sh)</summary>

macOS via Brewfile (install-packages.sh):
- coreutils, jq, stow
- direnv, eza, fzf, gum, starship, zoxide
- gh, nvm, tmux, uv
- ansible

Linux via install-packages.sh:
- apt: curl, git, stow, tmux, zsh, wget, gpg, ca-certificates
- curl: starship, zoxide, direnv, uv, bun
- git: fzf
- apt repos: eza, gh

</details>
