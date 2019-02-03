################
###  PUBLIC  ###
################


# All lines starting with ##! shall be taken
# as documentation for make help to interpret

##!    aliases         : Copy's over aliases
.PHONY: aliases
aliases:
	cp ./.shell_init ~/.shell_init

##!    bash            : copy over bashrc
.PHONY: bash
bash: aliases bash_helper

##!    fish            : install and configure fish
.PHONY: fish
fish: aliases update fish_helper

##!    zsh             : install zsh, oh-my-zsh, and plugins, and configure them
.PHONY: zsh
zsh: aliases update zsh_helper

##!    tmux            : install and configure tmux
.PHONY: tmux
tmux: update tmux_helper

##!    gdb             : install and configure gdb, install peda
.PHONY: gdb
gdb: update gdb_helper

##!    vim             : install and configure vim, install youcompleteme and other plugins
.PHONY: vim
vim: has_mem update vim_helper

##!    useful_tools    : install a bunch of useful tools via apt-get
.PHONY: useful_tools
useful_tools: update useful_tools_helper

##!    all_no_upgrade  : do all of the above in order, but do useful_tools first. Does not run apt-get upgrade
.PHONY: all_no_upgrade
all_no_upgrade: has_mem update all_helper


##!    all             : do all of the above in order, but do useful_tools first
.PHONY: all
all: has_mem update upgrade all_helper

##!    help            : print this helpful message
.PHONY: help
help:
	@echo ""
	@echo "make options:"
	@sed -n 's/^##!//p' < ./Makefile
	@echo ""

#################
###  PRIVATE  ###
#################


.PHONY: update
update:
	sudo apt-get update --fix-missing

.PHONY: upgrade
update:
	sudo apt-get upgrade

.PHONY: has_mem
has_mem:
	./helpers/has_mem.sh


.PHONY: bash_helper
bash_helper:
	mv ~/.bashrc ~/.bashrc.old || true
	cp ./.bashrc ~/.bashrc
	@echo '*** bash setup ! ***'


.PHONY: fish_helper
fish_helper:
	sudo apt-get install fish -y
	mkdir -p ~/.config/fish/config.fish.old || true
	mv ~/.config/fish/config.fish ~/.config/fish/config.fish.old || true
	cp ./.config/fish/config.fish ~/.config/fish/config.fish
	@echo '*** fish setup ! ***'


.PHONY: zsh_helper
zsh_helper:
	sudo apt-get install zsh -y
	mv ~/.zshrc ~/.zshrc.old || true
	cp ./.zshrc ~/.zshrc
	./helpers/install_omz.sh
	./helpers/install_omz_plugins.sh
	@echo '*** zsh setup ! ***'


.PHONY: tmux_helper
tmux_helper:
	sudo apt-get install tmux -y
	mv ~/.tmux.conf ~/.tmux.conf.old || true
	cp ./.tmux.conf ~/.tmux.conf
	@echo '*** tmux setup ! ***'


.PHONY: gdb_helper
gdb_helper:
	sudo apt-get install gdb -y
	git clone https://github.com/longld/peda.git ~/peda || true
	mv ~/.gdbinit ~/.gdbinit.old || true
	cp ./.gdbinit ~/.gdbinit
	@echo '*** gdb setup ! ***'


.PHONY: vim_you_complete_me
vim_you_complete_me:
	sudo apt-get install build-essential cmake -y
	sudo apt-get install python-dev python3-dev -y
	sudo apt-get install python-pip python-dev build-essential -y
	cd ~/.vim/bundle/YouCompleteMe && ./install.py --clang-completer

.PHONY: vim_after
vim_after:
	mkdir -p ~/.vim/after/
	mv ~/.vim/after/gutter.vim ~/.vim/after/gutter.vim.old || true
	cp ./gutter.vim ~/.vim/after/gutter.vim

.PHONY: vim_plugins
vim_plugins:
	mv ~/.vimrc ~/.vimrc.old || true
	cp ./.vimrc ~/.vimrc
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim || true
	vim +PluginInstall +qall

.PHONY: vim_setup
vim_setup:
	sudo apt-get install vim -y

.PHONY: vim_helper
vim_helper: vim_setup vim_plugins vim_after vim_you_complete_me
	@echo '*** vim setup ! ***'


.PHONY: useful_tools_helper
useful_tools_helper:
	sudo ./helpers/install_useful_tools.sh
	@echo '*** Useful tools setup ! ***'


.PHONY: all_helper
all_helper: useful_tools_helper aliases bash_helper fish_helper zsh_helper tmux_helper gdb_helper vim_helper
