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
./install.sh          # full install
./install.sh --minimal  # CI/containers
```

## Local Config

- `~/.localrc` - secrets/env vars
- `~/.gitconfig.local` - git user info
