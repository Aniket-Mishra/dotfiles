#!/bin/bash

echo "Installing Homebrew packages from brew-packages.txt..."

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

BREW_LIST="${REPO_DIR}/brew-packages.txt"
# BREW_LIST="${REPO_DIR}/apt-packages.txt"

if [ -f "$BREW_LIST" ]; then
  xargs -n 1 brew install < "$BREW_LIST"
  echo "Brew packages installed."
else
  echo "Package list not found at $BREW_LIST"
fi
