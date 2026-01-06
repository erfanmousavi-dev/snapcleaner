#!/usr/bin/env bash

# Simple Arch Linux package audit & removal script
# Shows package name + description and asks to keep or remove

set -e

# Check pacman
if ! command -v pacman &>/dev/null; then
    echo "pacman not found. This script is for Arch Linux."
    exit 1
fi

echo "=== Installed packages audit ==="
echo "k = keep | r = remove | s = skip"
echo

# Get all explicitly installed packages (not dependencies)
mapfile -t packages < <(pacman -Qqe)

for pkg in "${packages[@]}"; do
    desc=$(pacman -Qi "$pkg" | awk -F': ' '/^Description/ {print $2}')

    echo "----------------------------------------"
    echo "Package: $pkg"
    echo "Description: $desc"
    echo

    while true; do
        read -rp "[k]eep / [r]emove / [s]kip ? " choice
        case "$choice" in
            k|K)
                echo "Keeping $pkg"
                break
                ;;
            r|R)
                echo "Removing $pkg ..."
                sudo pacman -Rns "$pkg"
                break
                ;;
            s|S|"")
                echo "Skipped $pkg"
                break
                ;;
            *)
                echo "Invalid option. Choose k, r, or s."
                ;;
        esac
    done
done

echo
echo "=== Done ==="

