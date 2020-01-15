################
###  PUBLIC  ###
################


# All lines starting with ##! shall be taken
# as documentation for make help to interpret

##!    aliases : copy over aliases
.PHONY: aliases
aliases:
	cp ./.shell_init ~/.shell_init
	git submodule init ./delayed_rm
	sudo cp ./delayed_rm/delayed_rm.py ~/.local/bin/delayed_rm.py

##!    bash    : copy over bashrc
.PHONY: bash
bash: aliases bash_helper

##!    fish    : install and configure fish
.PHONY: fish
fish: aliases update fish_helper

##!    zsh     : install zsh, oh-my-zsh, and plugins, and configure them
.PHONY: zsh
zsh: aliases update zsh_helper

##!    git     : setup git aliases
.PHONY: git
git: git_helper

##!    tmux    : install and configure tmux
.PHONY: tmux
tmux: update tmux_helper

##!    gdb     : install and configure gdb, install peda
.PHONY: gdb
gdb: update gdb_helper

##!    vim     : install and configure vim, install youcompleteme and other plugins
.PHONY: vim
vim: prep vim_helper

##!    tools   : install a bunch of tools via apt-get
.PHONY: tools
tools: update tools_helper

##!    most    : make everything except tools
.PHONY: most
most: prep most_helper

##!    all     : do all of the above in order, but do tools first
.PHONY: all
all: prep tools_helper most_helper

##!    help    : print this helpful message
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
	sudo DEBIAN_FRONTEND=noninteractive apt-get update --fix-missing -q

.PHONY: prep
prep: update
	./helpers/has_mem.sh


.PHONY: bash_helper
bash_helper:
	mv ~/.bashrc ~/.bashrc.old || true
	cp ./.bashrc ~/.bashrc
	@echo '*** bash setup ! ***'


.PHONY: fish_helper
fish_helper:
	sudo DEBIAN_FRONTEND=noninteractive apt-get install fish -yq
	mkdir -p ~/.config/fish/config.fish.old || true
	mv ~/.config/fish/config.fish ~/.config/fish/config.fish.old || true
	cp ./.config/fish/config.fish ~/.config/fish/config.fish
	@echo '*** fish setup ! ***'


.PHONY: zsh_helper
zsh_helper:
	sudo DEBIAN_FRONTEND=noninteractive apt-get install zsh -yq
	mv ~/.zshrc ~/.zshrc.old || true
	cp ./.zshrc ~/.zshrc
	./helpers/omz.sh
	./helpers/omz_plugins.sh
	@echo '*** zsh setup ! ***'


.PHONY: git_helper
git_helper:
	./helpers/setup_git.sh
	@echo '*** git setup ! ***'


.PHONY: tmux_helper
tmux_helper:
	sudo DEBIAN_FRONTEND=noninteractive apt-get install tmux -yq
	mv ~/.tmux.conf ~/.tmux.conf.old || true
	cp ./.tmux.conf ~/.tmux.conf
	@echo '*** tmux setup ! ***'


.PHONY: gdb_helper
gdb_helper:
	sudo DEBIAN_FRONTEND=noninteractive apt-get install gdb -yq
	git clone https://github.com/longld/peda.git ~/peda || true
	mv ~/.gdbinit ~/.gdbinit.old || true
	cp ./.gdbinit ~/.gdbinit
	@echo '*** gdb setup ! ***'


.PHONY: vim_you_complete_me
vim_you_complete_me:
	sudo DEBIAN_FRONTEND=noninteractive apt-get install -yq \
		build-essential cmake python-dev python3-dev python-pip
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
	git clone https://github.com/VundleVim/Vundle.vim.git \
		~/.vim/bundle/Vundle.vim || true
	vim +PluginInstall +qall

.PHONY: vim_setup
vim_setup:
	sudo DEBIAN_FRONTEND=noninteractive apt-get install -yq \
		vim vim-gtk latexmk texlive-latex-extra

.PHONY: vim_helper
vim_helper: vim_setup vim_plugins vim_after vim_you_complete_me
	@echo '*** vim setup ! ***'


.PHONY: tools_helper
tools_helper:
	sudo ./helpers/useful_tools.sh
	@echo '*** Tools setup ! ***'


.PHONY: most_helper
most_helper: aliases bash_helper fish_helper zsh_helper git_helper tmux_helper gdb_helper vim_helper
