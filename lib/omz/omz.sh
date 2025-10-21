export ZSH="$HOME/.oh-my-zsh"

# Plugins
plugins=(
    1password 
    aliases 
    ansible 
    brew 
    direnv 
    eza 
    fast-syntax-highlighting 
    fzf 
    git 
    macos 
    nvm 
    ssh 
    starship 
    zoxide 
    zsh-uv-env
    )

# Plugin settings
zstyle ':omz:plugins:nvm' lazy yes
zstyle ':omz:plugins:nvm' autoload yes
zstyle ':omz:plugins:nvm' silent-autoload yes

zstyle ':omz:plugins:eza' 'dirs-first' yes
zstyle ':omz:plugins:eza' 'icons' yes

source $ZSH/oh-my-zsh.sh