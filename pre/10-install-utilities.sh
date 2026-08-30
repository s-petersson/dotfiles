#!/usr/bin/env bash

source "${DOTFILES_LIB:?}/packages.sh"

if dotfiles_is_macos; then
    brew tap FelixKratz/formulae
fi

dotfiles_install_packages \
    openssh \
    zsh \
    zsh-autosuggestions \
    zsh-syntax-highlighting \
    stow \
    fzf \
    neovim \
    starship \
    zoxide \
    fnm \
    uv \
    eza \
    bat \
    tuicr \
    --macos FelixKratz/formulae/borders \
    --arch curl \
    ghostty \
    obsidian

dotfiles_install_homebrew_casks \
    ghostty \
    nikitabobko/tap/aerospace \
    obsidian
