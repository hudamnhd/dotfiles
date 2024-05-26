#!/bin/bash

dotfiles_dir="$(pwd)"

# Fungsi untuk menghapus symlink
# $1: Path symlink yang akan dihapus
function remove_symlink {
    if rm "$1"; then
        echo "Sukses: Symlink $1 telah dihapus."
    else
        echo "Gagal: Tidak dapat menghapus symlink $1."
    fi
}

for config_item in "$dotfiles_dir/.config/"*; do
    remove_symlink "$HOME/.config/$(basename "$config_item")"
done

for bin_item in "$dotfiles_dir/.local/bin/"*; do
    remove_symlink "$HOME/.local/bin/$(basename "$bin_item")"
done

for share_item in "$dotfiles_dir/.local/share/"*; do
    remove_symlink "$HOME/.local/share/$(basename "$share_item")"
done

for home_item in "$dotfiles_dir/home/"*; do
    remove_symlink "$HOME/.$(basename "$home_item")"
done
