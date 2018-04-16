################
###  PUBLIC  ###
################


.PHONY: aliases
aliases: 
	cp ./.shell_aliases ~/.shell_aliases

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

.PHONY: all
all: aliases update bash_helper zsh_helper fish_helper tmux_helper vim_helper


#################
###  PRIVATE  ###
#################


.PHONY: update
update:
	sudo apt-get update

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

.PHONY: vim_helper
vim_helper:
	sudo apt-get install build-essential cmake -y
	sudo apt-get install python-dev python3-dev -y
	mv ~/.vimrc ~/.vimrc.old || true
	cp ./.vimrc ~/.vimrc
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim || true
	vim +PluginInstall +qall
	./helpers/has_mem.sh
	cd ~/.vim/bundle/YouCompleteMe && ./install.py --clang-completer
	@echo '*** vim setup ! ***'
