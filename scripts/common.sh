#!/usr/bin/env bash
set -e

ignore_name() {
  local name="$1"
  case "${name}" in
    .|..|.DS_Store|Thumbs.db) return 0 ;;
  esac
  return 1
}

backup_target() {
  local target="$1"
  if [[ -e "${target}" || -L "${target}" ]]; then
    local stamp; stamp="$(date +%Y%m%d_%H%M%S)"
    local base; base="$(basename "${target}")"
    local backup="${HOME}/dotfile_backups/${base}.${stamp}.bak"
    mkdir -p "${HOME}/dotfile_backups"
    echo "Backing up ${target} -> ${backup}"
    mv -f "${target}" "${backup}"
  fi
}

link_to() {
  local src="$1"
  local dst="$2"
  backup_target "${dst}"
  mkdir -p "$(dirname "${dst}")"
  ln -sfn "${src}" "${dst}"
  echo "Linked ${dst} -> ${src}"
}
