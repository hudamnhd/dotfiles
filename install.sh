#!/bin/bash

dotfiles_dir="$(pwd)"

# Fungsi untuk membuat symlink dengan pengecekan
# $1: Path asal symlink
# $2: Path tujuan symlink
function create_symlink {
    if [ -L "$2" ]; then
        echo "Lewati: Symlink untuk $1 sudah ada."
    elif [ -e "$2" ]; then
        echo "Lewati: $2 sudah ada sebagai file atau direktori biasa, bukan symlink."
    else
        if ln -s "$1" "$2"; then
            echo "Sukses: Symlink $1 telah dibuat."
        else
            echo "Gagal: Tidak dapat membuat symlink $1."
        fi
    fi
}

# Buat symlink untuk .config
for config_item in "$dotfiles_dir/.config/"*; do
    create_symlink "$config_item" "$HOME/.config/$(basename "$config_item")"
done

# Buat symlink untuk .local/bin
for bin_item in "$dotfiles_dir/.local/bin/"*; do
    create_symlink "$bin_item" "$HOME/.local/bin/$(basename "$bin_item")"
done

# Buat symlink untuk .local/share
for share_item in "$dotfiles_dir/.local/share/"*; do
    create_symlink "$share_item" "$HOME/.local/share/$(basename "$share_item")"
done

# Buat symlink untuk file di home/
for home_item in "$dotfiles_dir/home/"*; do
    create_symlink "$home_item" "$HOME/.$(basename "$home_item")"
done
