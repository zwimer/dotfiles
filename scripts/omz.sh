#!/bin/bash -eu

URL="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
echo "Running ${URL}"
CHSH=no RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl "${URL}")"

PDIR="${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins"
mkdir -p "${PDIR}"
cd "${PDIR}"

# These are custom plugins we noted in our .zshrc, we install them now
git clone "https://github.com/zsh-users/zsh-syntax-highlighting"
git clone "https://github.com/zsh-users/zsh-autosuggestions"
