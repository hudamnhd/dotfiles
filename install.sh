#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log() {
  echo "[DOTFILES] $*"
}

# Create or replace symlink
create_symlink() {
  local target="$1"  # e.g. ~/.config/nvim
  local source="$2"  # e.g. ~/dotfiles/.config/nvim

  if [ -L "$target" ] || [ -e "$target" ]; then
    rm -rf "$target"
    log "Removed existing $target"
  fi

  ln -s "$source" "$target"
  log "Linked $target → $source"
}

# Install .config items
install_config_dir() {
  for item in "$DOTFILES_DIR/.config"/*; do
    [ -e "$item" ] || continue
    local name
    name=$(basename "$item")
    create_symlink "$HOME/.config/$name" "$item"
  done
}

# Files/dirs to exclude from root dotfiles installation
EXCLUDES=(.git .config README.md install.sh)

install_root_dir() {
  for file in "$DOTFILES_DIR"/.*; do
    local name
    name=$(basename "$file")

    # Skip common/explicitly excluded files
    if [[ " ${EXCLUDES[*]} " == *" $name "* ]]; then
      continue
    fi

    create_symlink "$HOME/$name" "$file"
  done
}

main() {
  install_config_dir
  install_root_dir
}

main "$@"
