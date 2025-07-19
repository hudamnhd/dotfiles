#!/usr/bin/env bash

set -euo pipefail

dotfiles_dir="$(pwd)"
dry_run=false

if [[ "${1-}" == "--dry-run" ]]; then
    dry_run=true
    echo "[Dry Run Mode] Will not make any real changes."
fi

function create_symlink() {
    local link_name="$1"
    local target="$2"

    if $dry_run; then
        echo "[Dry Run] ln -sf $target $link_name"
    else
        echo "ln -sf $target $link_name"
        ln -sf "$target" "$link_name"
    fi
}

# .config
for config_item in "$dotfiles_dir/.config/"*; do
    link_path="$HOME/.config/$(basename "$config_item")"
    create_symlink "$link_path" "$config_item"
done

# .local/bin
for bin_item in "$dotfiles_dir/.local/bin/"*; do
    link_path="$HOME/.local/bin/$(basename "$bin_item" .sh)"
    create_symlink "$link_path" "$bin_item"
done
