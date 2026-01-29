# Shell Aliases

# Dotfiles installer
alias dotfiles="$DOTFILES/install.sh"

# Reload shell configuration
alias reload!="omz reload"

# Copy public key to clipboard (macOS only)
if [[ "$DF_OS_TYPE" == "macos" ]]; then
  alias pubkey="cat ~/.ssh/id_rsa.pub | pbcopy && echo '=> Public key copied to pasteboard.'"
fi

# Claude Code
alias cc="claude --dangerously-skip-permissions"

# direnv
alias da="direnv allow"
