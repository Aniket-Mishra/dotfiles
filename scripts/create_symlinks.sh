#!/usr/bin/env bash
set -e

# ~/github/dotfiles/scripts/ -> dynamic cuz others will use
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "${REPO_DIR}/scripts/common.sh"


echo "Setting up symlinks."

[[ -f "${REPO_DIR}/.zshrc" ]] && link_to "${REPO_DIR}/.zshrc"     "${HOME}/.zshrc"
[[ -f "${REPO_DIR}/.p10k.zsh" ]] && link_to "${REPO_DIR}/.p10k.zsh"  "${HOME}/.p10k.zsh"
[[ -f "${REPO_DIR}/.zprofile" ]] && link_to "${REPO_DIR}/.zprofile"  "${HOME}/.zprofile"
[[ -f "${REPO_DIR}/.gitconfig" ]] && link_to "${REPO_DIR}/.gitconfig" "${HOME}/.gitconfig"


# can add more folders othre than fastfetch n micro.
if [[ -d "${REPO_DIR}/.config" ]]; then
  mkdir -p "${HOME}/.config"
  shopt -s nullglob
  for path in "${REPO_DIR}/.config"/*; do
    name="$(basename "${path}")"
    if ignore_name "${name}"; then continue; fi
    link_to "${path}" "${HOME}/.config/${name}"
  done
  shopt -u nullglob
fi

# Makes zshrc smaller + no hardcode, but makes . files
[[ -f "${REPO_DIR}/zsh_aliases"     ]] && link_to "${REPO_DIR}/zsh_aliases"     "${HOME}/.zsh_aliases"
[[ -f "${REPO_DIR}/shell_functions" ]] && link_to "${REPO_DIR}/shell_functions" "${HOME}/.zsh_functions"

echo "Symlinks created."
