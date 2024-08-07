# All lines starting with ##! shall be taken
# as documentation for make help to interpret

##!    shell   : copy over aliases and exports and updates bash and zshrc
.PHONY: shell
shell:
	./scripts/append.sh file ./conf/.shell_init ~/.shell_init
	./scripts/append.sh str "source ~/.shell_init" ~/.bashrc
	./scripts/append.sh str "source ~/.shell_init" ~/.zshrc

##!    python  : install python, pip, virtualenvwrapper, and edit .shell_init
.PHONY: python
python: shell
	./scripts/pkg.sh install_if2 apt apt-get python3-pip virtualenvwrapper
	./scripts/pkg.sh install_if2 dnf yum     python3-pip python3-virtualenvwrapper
	./scripts/py_exports.sh

##!    rm      : install delayed_rm
.PHONY: rm
rm: shell python
	./scripts/install_delayed_rm.sh

##!    quote   : install quote
.PHONY: quote
quote: shell python
	./scripts/install_quote.sh

.PHONY: basic_zsh
basic_zsh: shell
	./scripts/pkg.sh install zsh
	./scripts/append.sh file ./conf/.zshrc ~/.zshrc
	./scripts/omz.sh
	@echo '*** basic zsh setup ! ***'

##!    zsh     : install zsh, oh-my-zsh, and plugins, and configure them (also installs fzf and tree)
.PHONY: zsh
zsh: basic_zsh
	./scripts/pkg.sh install fzf tree
	@echo '*** zsh setup ! ***'

##!    git     : setup git aliases
.PHONY: git
git:
	@echo "Assuming git exists..."
	./scripts/append.sh file ./conf/.gitignore ~/.gitignore
	./scripts/git_config.sh
	@echo '*** git setup ! ***'

##!    tmux    : install and configure tmux
.PHONY: tmux
tmux:
	./scripts/pkg.sh install tmux
	./scripts/append.sh file ./data/tmux_ssh ~/.shell_init
	./scripts/append.sh file ./conf/.tmux.conf ~/.tmux.conf
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm || true
	tmux new-session -d 'tmux source ~/.tmux.conf && ~/.tmux/plugins/tpm/scripts/install_plugins.sh'
	./scripts/pkg.sh install_if2 dnf yum sysstat  # For a tmux plugin
	@echo '*** tmux setup ! ***'

##!    gdb     : install and configure gdb, install peda
.PHONY: gdb
gdb:
	./scripts/pkg.sh install gdb
	git clone https://github.com/longld/peda.git ~/.peda || true
	./scripts/append.sh file ./conf/.gdbinit ~/.gdbinit
	@echo '*** gdb setup ! ***'

##!    lldb     : configure lldb
.PHONY: lldb
gdb:
	./scripts/append.sh file ./conf/.lldbinit ~/.lldbinit
	@echo '*** lldb setup ! ***'

##!    vim     : install and configure vim and plugins
.PHONY: vim
vim: shell
	./scripts/pkg.sh install vim
	./scripts/default_vim.sh
	mkdir -v -p ~/.vim/colors
	./scripts/append.sh file ./conf/github.vim ~/.vim/colors/github.vim '" '
	./scripts/append.sh file ./conf/.vimrc ~/.vimrc '" '
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim || true
	vim +PluginInstall +qall
	mkdir -p ~/.vim/after/
	./scripts/append.sh file ./conf/gutter.vim ~/.vim/after/gutter.vim '" '
	@echo '*** vim setup ! ***'

##!    gpg     : install gpg
.PHONY: gpg
gpg: shell
	./scripts/pkg.sh install gnupg
	mkdir -m 700 ~/.gnupg || true
	./scripts/append.sh file ./conf/.gnupg/gpg.conf ~/.gnupg/gpg.conf

##!    most    : do most of the above in order
.PHONY: most
most: shell python rm quote zsh git tmux gdb vim gpg

##!    vim_ycm : install the vim plugin YouCompleteMe
.PHONY: vim_ycm
vim_ycm: vim vim_ycm_check python
	./scripts/pkg.sh install_if2 apt apt-get cmake python3-dev   build-essential
	./scripts/pkg.sh install_if2 dnf yum     cmake python3-devel gcc-c++ make
	sed -i "s|\" Plugin 'Valloric/YouCompleteMe'| Plugin 'Valloric/YouCompleteMe'|g" ~/.vimrc
	vim +PluginInstall +qall
	cd ~/.vim/bundle/YouCompleteMe && ./install.py --clang-completer # --force-sudo if root
	@echo '*** YouCompleteMe setup ! ***'

##!    all     : do all of the above in order (skipping non-linux items)
.PHONY: linux
linux: most vim_ycm

##!    help    : print this helpful message
.PHONY: help
help:
	@echo ""
	@echo "make options:"
	@sed -n 's/^##!//p' < ./Makefile
	@echo ""

### Private helpers

.PHONY: vim_ycm_check
vim_ycm_check:
	./scripts/vim_ycm_chk.sh
