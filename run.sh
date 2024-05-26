#!/bin/bash

dotfiles_dir="$(pwd)"

# Fungsi untuk membuat symlink
# $1: Path asal symlink
# $2: Path tujuan symlink
function create_symlink {
    if ln -s "$1" "$2"; then
        echo "Sukses: Symlink $1 telah dibuat."
    else
        echo "Gagal: Tidak dapat membuat symlink $1."
    fi
}

for config_item in "$dotfiles_dir/.config/"*; do
    create_symlink "$config_item" "$HOME/.config/$(basename "$config_item")"
done

for bin_item in "$dotfiles_dir/.local/bin/"*; do
    create_symlink "$bin_item" "$HOME/.local/bin/$(basename "$bin_item")"
done

for share_item in "$dotfiles_dir/.local/share/"*; do
    create_symlink "$share_item" "$HOME/.local/share/$(basename "$share_item")"
done

for home_item in "$dotfiles_dir/home/"*; do
    create_symlink "$home_item" "$HOME/.$(basename "$home_item")"
done


