################
###  PUBLIC  ###
################


# All lines starting with ##! shall be taken
# as documentation for make help to interpret

##!    shell : copy over aliases and exports and updates bash and zshrc
.PHONY: shell
shell:
	./scripts/append.sh file ./conf/.shell_init ~/.shell_init
	./scripts/append.sh str "source ~/.shell_init" ~/.bashrc
	./scripts/append.sh str "source ~/.shell_init" ~/.zshrc

##!    rm      : install's delayed_rm into ~/.local/bin
.PHONY: rm
rm: shell
	git submodule update --init ./delayed_rm
	mkdir -p ~/.local/bin/
	sudo cp ./delayed_rm/delayed_rm.py ~/.local/bin/delayed_rm.py
	./scripts/append.sh str "alias rm='~/.local/bin/delayed_rm.py'" ~/.shell_init

##!    zsh     : install zsh, oh-my-zsh, and plugins, and configure them
.PHONY: zsh
zsh: shell
	./scripts/pkg.sh install zsh
	./scripts/append.sh file ./conf/.zshrc ~/.zshrc
	./scripts/omz.sh
	./scripts/omz_plugins.sh
	@echo '*** zsh setup ! ***'
	@echo '*** You may want to run chsh -s `which zsh` ***'

##!    git     : setup git aliases
.PHONY: git
git:
	@echo "Assuming git exists..."
	./scripts/append.sh file ./conf/.gitignore ~/.gitignore
	./scripts/setup_git.sh
	@echo '*** git setup ! ***'

##!    tmux    : install and configure tmux
.PHONY: tmux
tmux:
	./scripts/pkg.sh install tmux
	./scripts/append.sh file ./conf/.tmux.conf ~/.tmux.conf
	@echo '*** tmux setup ! ***'

##!    gdb     : install and configure gdb, install peda
.PHONY: gdb
gdb:
	./scripts/pkg.sh install gdb
	git clone https://github.com/longld/peda.git ~/.peda || true
	./scripts/append.sh file ./conf/.gdbinit ~/.gdbinit
	@echo '*** gdb setup ! ***'

##!    python  : install python, pip, virtualenvwrapper, and edit .shell_init
.PHONY: python
python: shell
	./scripts/pkg.sh install_if2 apt apt-get python3-pip virtualenvwrapper
	./scripts/pkg.sh install_if2 dnf yum     python3-pip python3-virtualenvwrapper
	./scripts/py_exports.sh

##!    vim     : install and configure vim and plugins
.PHONY: vim
vim: vim_setup vim_plugins vim_after
	@echo '*** vim setup ! ***'

##!    most    : do all of the above in order
.PHONY: most
most: shell rm zsh git tmux gdb python vim

##!    vim_ycm : install the vim plugin YouCompleteMe
.PHONY: vim_ycm
vim_ycm: vim_ycm_check vim python
	./scripts/pkg.sh install_if2 apt apt-get cmake python3-dev   build-essential
	./scripts/pkg.sh install_if2 dnf yum     cmake python3-devel gcc-c++ make
	sed -i "s|\" Plugin 'Valloric/YouCompleteMe'| Plugin 'Valloric/YouCompleteMe'|g" ~/.vimrc
	vim +PluginInstall +qall
	cd ~/.vim/bundle/YouCompleteMe && ./install.py --clang-completer
	@echo '*** YouCompleteMe setup ! ***'

##!    all     : do all of the above in order
.PHONY: all
all: most vim_ycm

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


.PHONY: vim_after
vim_after:
	mkdir -p ~/.vim/after/
	./scripts/append.sh file ./conf/gutter.vim ~/.vim/after/gutter.vim '" '

.PHONY: vim_plugins
vim_plugins:
	./scripts/append.sh file ./conf/.vimrc ~/.vimrc '" '
	git clone https://github.com/VundleVim/Vundle.vim.git \
		~/.vim/bundle/Vundle.vim || true
	vim +PluginInstall +qall

.PHONY: vim_setup
vim_setup: shell
	./scripts/pkg.sh install vim
	./scripts/pkg.sh install_if2 dnf yum vim-default-editor
	./scripts/default_vim.sh


.PHONY: vim_ycm_check
vim_ycm_check:
	./scripts/vim_ycm_chk.sh
