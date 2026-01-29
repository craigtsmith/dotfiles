#!/usr/bin/env bash
#
# Backup existing dotfiles before stowing
#

install_backup() {
  local files=(
    "$HOME/.zshrc"
    "$HOME/.gitconfig"
    "$HOME/.tmux.conf"
    "$HOME/.local/bin/env.sh"
  )

  local backed_up=0
  for file in "${files[@]}"; do
    if backup_file "$file"; then
      info "Backed up $file"
      backed_up=$((backed_up + 1))
      CHANGES_MADE=true
    fi
  done

  [[ $backed_up -eq 0 ]] && info "No files to backup" || true
}
