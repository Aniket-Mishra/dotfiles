#!/bin/bash

echo "Installing Homebrew packages from brew-packages.txt..."

BREW_LIST="$HOME/github/dotfiles/brew-packages.txt"

if [ -f "$BREW_LIST" ]; then
  xargs -n 1 brew install < "$BREW_LIST"
  echo "Brew packages installed."
else
  echo "Package list not found at $BREW_LIST"
fi
