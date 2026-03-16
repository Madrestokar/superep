#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

have() {
  command -v "$1" >/dev/null 2>&1
}

install_brew() {
  echo "Using Homebrew..."
  brew install zsh fzf ripgrep fd bat eza
}

install_apt() {
  echo "Using apt..."
  sudo apt update
  sudo apt install -y zsh fzf ripgrep fd-find bat

  if apt-cache show eza >/dev/null 2>&1; then
    sudo apt install -y eza
  else
    echo "eza package not found in apt repositories, skipping."
  fi
}

backup_zshrc() {
  if [ -f "$HOME/.zshrc" ] && [ ! -f "$HOME/.zshrc.bak" ]; then
    cp "$HOME/.zshrc" "$HOME/.zshrc.bak"
    echo "Backed up existing ~/.zshrc to ~/.zshrc.bak"
  fi
}

deploy_zshrc() {
  cp "$REPO_DIR/zshrc" "$HOME/.zshrc"
  echo "Installed ~/.zshrc"
}

main() {
  if have brew; then
    install_brew
  elif have apt; then
    install_apt
  else
    echo "Unsupported package manager. Add support manually."
    exit 1
  fi

  backup_zshrc
  deploy_zshrc

  echo
  echo "Bootstrap finished."
  echo "Start zsh with:"
  echo "  exec zsh"
}

main "$@"
