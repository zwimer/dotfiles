#!/bin/sh -eux


# User
git config --global user.name zwimer
git config --global user.email github@zwimer.com
SSHDIR="${HOME}/.ssh"
if [ ! -d "${SSHDIR}" ]; then
	mkdir -m 700 "${SSHDIR}"
fi
KEYFILE="${SSHDIR}/GitSigningKey"
if [ ! -f "${KEYFILE}" ]; then
	ssh-keygen -t ed25519 -o -a 150 -C "$(whoami)_$(uname -n)_GitSigningKey" -N "" -f "${KEYFILE}"
fi
git config --global user.signingkey "${KEYFILE}"

# Core
touch ~/.gitignore
if [ -f /usr/bin/vim ]; then
	git config --global editor /usr/bin/vim
fi
git config --global core.excludesfile ~/.gitignore
git config --global core.eautocrlf input
git config --global core.safecrlf true

# Behavior
git config --global push.default simple
git config --global pull.rebase true
git config --global credential.helper store
git config --global blame.markUnblamableLines true
git config --global branch.sort -comitterdate
git config --global gpg.format ssh

# Color
git config --global color.ui auto
git config --global color.decorate.tag blue
git config --global diff.colorMoved zebra

#
# Aliases
#

# Add
git config --global alias.a "add"
git config --global alias.ap "add -p"
git config --global alias.aa "add -A"
git config --global alias.aware "add -N"

# Commit
git config --global alias.cm "commit -S -m"
git config --global alias.ca "commit -S --amend --no-edit"
git config --global alias.cae "commit -S --amend"

# Push
git config --global alias.ps "push"
git config --global alias.pushhard "push --force-with-lease"
git config --global alias.yolo "push --force"
git config --global alias.upstream "push --set-upstream origin master"

# Log
git config --global alias.l "log --graph --decorate --pretty=oneline --abbrev-commit"
git config --global alias.tree "log --graph --decorate --pretty=oneline --abbrev-commit --all"
git config --global alias.last "log -1 HEAD"

# Status
git config --global alias.s "status"

# General
git config --global alias.pl "pull"
git config --global alias.co "checkout"
git config --global alias.br "branch"
git config --global alias.unstage "reset HEAD --"
git config --global alias.f "fetch"

# Diff
git config --global alias.d "diff"
git config --global alias.changed "show"
git config --global alias.staged "diff --staged"

# Rebase
git config --global alias.r "rebase"
git config --global alias.ri "rebase -i"
git config --global alias.rc "rebase --continue"

# Undo
git config --global alias.undo "reset head@{0}"

# Help
git config --global alias.aliases "config --get-regexp '^alias\.'"

# Tabs
git config --global core.pager "less --tabs 4"
