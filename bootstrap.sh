#!/bin/bash

echo "Setting up dotfile symlinks..."

ln -sf ~/github/dotfiles/.zshrc ~/.zshrc
ln -sf ~/github/dotfiles/.p10k.zsh ~/.p10k.zsh
ln -sf ~/github/dotfiles/.zprofile ~/.zprofile
ln -sf ~/github/dotfiles/.gitconfig ~/.gitconfig

echo "Symlinks created successfully."

