#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

need_cmd() {
  command -v "$1" >/dev/null 2>&1
}

install_with_brew() {
  echo "Using Homebrew"
  brew install fzf ripgrep fd bat eza
}

install_with_apt() {
  echo "Using apt"
  sudo apt update
  sudo apt install -y fzf ripgrep fd-find bat

  if apt-cache show eza >/dev/null 2>&1; then
    sudo apt install -y eza
  else
    echo "eza is not available via apt on this system. Skipping eza."
  fi
}

setup_fzf() {
  if need_cmd brew && [[ -x "$(brew --prefix)/opt/fzf/install" ]]; then
    "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc || true
  fi
}

deploy_zshrc() {
  if [[ -f "$HOME/.zshrc" && ! -f "$HOME/.zshrc.bak" ]]; then
    cp "$HOME/.zshrc" "$HOME/.zshrc.bak"
  fi

  cp "$REPO_DIR/zshrc" "$HOME/.zshrc"
}

main() {
  if need_cmd brew; then
    install_with_brew
  elif need_cmd apt; then
    install_with_apt
  else
    echo "Unsupported package manager. Add support for your distro."
    exit 1
  fi

  deploy_zshrc
  setup_fzf

  echo
  echo "Done."
  echo "Reload shell with: source ~/.zshrc"
}

main "$@"
