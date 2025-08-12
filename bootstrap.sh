#!/bin/bash

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${REPO_DIR}/scripts/common.sh"

case "$(uname)" in
  Darwin)  OS="macOS" ;;
  Linux)   OS="linux" ;;
  *)       OS="unknown" ;;
esac

echo "Running setup on $OS"

if [[ "${OS}" == "macOS" ]]; then
  if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  # brew to path (m n intel (yes some people stil use intel))
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi

elif [[ "${OS}" == "linux" ]]; then
  if ! command -v brew &>/dev/null; then
    if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    else
      echo "Use your package manager or install Linuxbrew."
    fi
  fi

elif [[ "${OS}" == "unknown" ]]; then
  echo "No love for windows n others."
else
  echo "Homebrew present"
fi

# Update this for other managers like apt/pacman etc
if [[ -f "${REPO_DIR}/scripts/install_brew_packages.sh" ]]; then
  echo "Installing brew packages"
  bash "${REPO_DIR}/scripts/install_brew_packages.sh"
else
  echo "No install_brew_packages.sh found, skipping brew package install."
fi

echo "Setting up dotfile symlinks."

echo "Backing up existing dotfiles."
for t in "$HOME/.zshrc" "$HOME/.zsh_aliases" "$HOME/.zsh_functions" \
         "$HOME/.zprofile" "$HOME/.gitconfig" "$HOME/.p10k.zsh" \
         "$HOME/.config/fastfetch" "$HOME/.config/micro"; do
  backup_target "$t"
done

echo "Creating Symlinks."
bash "${REPO_DIR}/scripts/create_symlinks.sh"
echo "Symlinks created successfully."

# # Decrypt SSH config
# if [ -f ~/github/dotfiles/secrets/ssh_config.gpg ]; then
#   echo "Decrypting SSH config."
#   gpg --quiet --output ~/.ssh/config --decrypt ~/github/dotfiles/secrets/ssh_config.gpg
#   chmod 600 ~/.ssh/config
# else
#   echo "No encrypted SSH config found. Skipping."
# fi

echo "Done BOIII"
