#!/bin/bash

echo "MacOS setup"

if ! command -v brew &> /dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew present"
fi

bash ~/github/dotfiles/scripts/install_brew_packages.sh

echo "Setting up dotfile symlinks..."

ln -sf ~/github/dotfiles/.zshrc ~/.zshrc
ln -sf ~/github/dotfiles/.p10k.zsh ~/.p10k.zsh
ln -sf ~/github/dotfiles/.zprofile ~/.zprofile
ln -sf ~/github/dotfiles/.gitconfig ~/.gitconfig

echo "Symlinks created successfully."

# Decrypt SSH config
if [ -f ~/github/dotfiles/secrets/ssh_config.gpg ]; then
  echo "Decrypting SSH config..."
  gpg --quiet --output ~/.ssh/config --decrypt ~/github/dotfiles/secrets/ssh_config.gpg
  chmod 600 ~/.ssh/config
fi

echo "Done BOIII"