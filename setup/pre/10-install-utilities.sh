#!/usr/bin/env bash

source "${DOTFILES_LIB:?}/packages.sh"

dotfiles_install_packages \
    openssh \
    stow \
    fzf \
    neovim \
    starship \
    fnm \
    uv
