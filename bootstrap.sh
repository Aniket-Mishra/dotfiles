#!/bin/bash

set -e

case "$(uname)" in
  Darwin)  OS="macOS" ;;
  Linux)   OS="linux" ;;
  *)       OS="unknown" ;;
esac

echo "Running setup on $OS"

if ! command -v brew &> /dev/null; then
  echo "Installing Homebrew."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew present"
fi

if [ -f ~/github/dotfiles/scripts/install_brew_packages.sh ]; then
  echo "Installing brew packages"
  bash ~/github/dotfiles/scripts/install_brew_packages.sh
else
  echo "No install_brew_packages.sh found, skipping brew package install."
fi
echo "Setting up dotfile symlinks."

echo "Backing up existing dotfiles."
mkdir -p ~/dotfile_backups
for file in .zshrc .p10k.zsh .zprofile .gitconfig; do
  [ -f ~/$file ] && cp ~/$file ~/dotfile_backups/${file}_$(date +%s)
done

echo "Creating Symlinks."
ln -sf ~/github/dotfiles/.zshrc ~/.zshrc
ln -sf ~/github/dotfiles/.p10k.zsh ~/.p10k.zsh
ln -sf ~/github/dotfiles/.zprofile ~/.zprofile
ln -sf ~/github/dotfiles/.gitconfig ~/.gitconfig

echo "Symlinks created successfully."

# Decrypt SSH config
if [ -f ~/github/dotfiles/secrets/ssh_config.gpg ]; then
  echo "Decrypting SSH config."
  gpg --quiet --output ~/.ssh/config --decrypt ~/github/dotfiles/secrets/ssh_config.gpg
  chmod 600 ~/.ssh/config
else
  echo "No encrypted SSH config found. Skipping."
fi

echo "Done BOIII"
