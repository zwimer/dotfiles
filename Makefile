################
###  PUBLIC  ###
################


.PHONY: aliases
aliases:
	cp ./.shell_init ~/.shell_init

.PHONY: bash
bash: aliases bash_helper

.PHONY: zsh
zsh: aliases update zsh_helper

.PHONY: fish
fish: aliases update fish_helper

.PHONY: tmux
tmux: update tmux_helper

.PHONY: vim
vim: update vim_helper

.PHONY: useful_tools
useful_tools: update useful_tools_helper

.PHONY: all
all: aliases update bash_helper zsh_helper fish_helper tmux_helper vim_helper useful_tools_helper


#################
###  PRIVATE  ###
#################


.PHONY: update
update:
	sudo apt-get update --fix-missing


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


.PHONY: vim_you_complete_me
vim_you_complete_me:
	sudo apt-get install build-essential cmake -y
	sudo apt-get install python-dev python3-dev -y
	sudo apt-get install python-pip python-dev build-essential -y
	./helpers/has_mem.sh
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
