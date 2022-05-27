################
###  PUBLIC  ###
################


# All lines starting with ##! shall be taken
# as documentation for make help to interpret

##!    shell : copy over aliases and exports and updates bash and zshrc
.PHONY: shell
shell:
	./scripts/append.sh ./conf/.shell_init ~/.shell_init
	./scripts/append_str.sh "source ~/.shell_init" ~/.bashrc
	./scripts/append_str.sh "source ~/.shell_init" ~/.zshrc

##!    rm      : install's delayed_rm into ~/.local/bin
.PHONY: rm
rm: shell
	git submodule update --init ./delayed_rm
	mkdir -p ~/.local/bin/
	sudo cp ./delayed_rm/delayed_rm.py ~/.local/bin/delayed_rm.py
	./scripts/append_str.sh "alias rm='~/.local/bin/delayed_rm.py'" ~/.shell_init

##!    zsh     : install zsh, oh-my-zsh, and plugins, and configure them
.PHONY: zsh
zsh: prep_install zsh_helper

##!    git     : setup git aliases
.PHONY: git
git:
	@echo "Assuming git exists..."
	./scripts/append.sh ./conf/.gitignore ~/.gitignore
	./scripts/setup_git.sh
	@echo '*** git setup ! ***'

##!    tmux    : install and configure tmux
.PHONY: tmux
tmux: prep_install tmux_helper

##!    gdb     : install and configure gdb, install peda
.PHONY: gdb
gdb: prep_install gdb_helper

##!    python  : install python, pip, virtualenvwrapper, and edit .shell_init
.PHONY: python
python: prep_install python_helper

##!    vim     : install and configure vim and plugins
.PHONY: vim
vim: prep_install vim_helper

##!    most    : do all of the above in order
.PHONY: most
most: shell rm prep_install zsh_helper git tmux_helper gdb_helper python_helper vim_helper

##!    vim_ycm : install the vim plugin YouCompleteMe
.PHONY: vim_ycm
vim_ycm: prep_install vim_ycm_helper

##!    all     : do all of the above in order
.PHONY: all
all: most vim_ycm_helper

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


.PHONY: prep_install
prep_install:
	./scripts/prep_install.sh


.PHONY: zsh_helper
zsh_helper: shell
	./scripts/install.sh zsh
	./scripts/append.sh ./conf/.zshrc ~/.zshrc
	./scripts/omz.sh
	./scripts/omz_plugins.sh
	@echo '*** zsh setup ! ***'
	@echo '*** You may want to run chsh -s `which zsh` ***'


.PHONY: tmux_helper
tmux_helper:
	./scripts/install.sh tmux
	./scripts/append.sh ./conf/.tmux.conf ~/.tmux.conf
	@echo '*** tmux setup ! ***'


.PHONY: gdb_helper
gdb_helper:
	./scripts/install.sh gdb
	git clone https://github.com/longld/peda.git ~/.peda || true
	./scripts/append.sh ./conf/.gdbinit ~/.gdbinit
	@echo '*** gdb setup ! ***'


.PHONY: python_helper
python_helper: shell
	./scripts/install_if.sh apt apt-get python3-pip virtualenvwrapper
	./scripts/install_if.sh dnf yum     python3-pip python3-virtualenvwrapper
	./scripts/py_exports.sh


.PHONY: vim_after
vim_after:
	mkdir -p ~/.vim/after/
	./scripts/append.sh ./conf/gutter.vim ~/.vim/after/gutter.vim '" '

.PHONY: vim_plugins
vim_plugins:
	./scripts/append.sh ./conf/.vimrc ~/.vimrc '" '
	git clone https://github.com/VundleVim/Vundle.vim.git \
		~/.vim/bundle/Vundle.vim || true
	vim +PluginInstall +qall

.PHONY: vim_setup
vim_setup: shell
	./scripts/install.sh vim
	./scripts/install_if.sh dnf yum vim-default-editor
	./scripts/default_vim.sh

.PHONY: vim_helper
vim_helper: vim_setup vim_plugins vim_after
	@echo '*** vim setup ! ***'


.PHONY: vim_ycm_check
vim_ycm_check:
	./scripts/vim_ycm_chk.sh

.PHONY: vim_ycm_helper
vim_ycm_helper: vim_ycm_check vim python
	./scripts/install_if.sh apt apt-get cmake python3-dev   build-essential
	./scripts/install_if.sh dnf yum     cmake python3-devel gcc-c++ make
	sed -i "s|\" Plugin 'Valloric/YouCompleteMe'| Plugin 'Valloric/YouCompleteMe'|g" ~/.vimrc
	vim +PluginInstall +qall
	cd ~/.vim/bundle/YouCompleteMe && ./install.py --clang-completer
	@echo '*** YouCompleteMe setup ! ***'
