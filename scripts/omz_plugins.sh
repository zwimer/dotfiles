#!/bin/bash -x

PDIR="${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins"
mkdir -p "${PDIR}"
cd "${PDIR}"

# These are custom plugins we noted in our .zshrc, we install them now
git clone "https://github.com/zsh-users/zsh-syntax-highlighting"
git clone "https://github.com/zsh-users/zsh-autosuggestions"
