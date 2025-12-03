# All lines starting with ##! shall be taken
# as documentation for make help to interpret

##!    shell   : copy over aliases and exports and updates bash and zshrc
.PHONY: shell
shell:
	./scripts/append.sh file ./conf/.shell_init ~/.shell_init
	@echo '*** ~/.shell_init setup ! ***'

##!    python  : install python, pip, virtualenvwrapper, and edit .shell_init
.PHONY: python
python: shell
	./scripts/pkg.sh install_if2 apt apt-get python3-pip virtualenvwrapper
	./scripts/pkg.sh install_if2 dnf yum     python3-pip python3-virtualenvwrapper
	@echo '*** python setup ! ***'

##!    cli     : install the venv cli including: delayed_rm, quote, etc.
.PHONY: cli
cli: shell python
	bash -c 'source ~/.shell_init && mkvirtualenv cli && set -eux \
		&& pip3 install -U pip && pip3 install -U delayed_rm quote_lines rpipe sigsleep'
	./scripts/argcomplete.sh
	@echo '*** cli setup ! ***'

##!    bash    : configure ~/.bashrc
.PHONY: bash
bash: cli
	./scripts/append.sh str "source ~/.shell_init" ~/.bashrc
	@echo '*** bash setup ! ***'

##!    zsh     : install zsh, oh-my-zsh, and plugins, and configure them (also installs fzf and tree)
.PHONY: zsh
zsh: cli
	./scripts/pkg.sh install zsh fzf tree
	./scripts/append.sh file ./conf/.zshrc ~/.zshrc
	./scripts/omz.sh
	./scripts/append.sh str "source ~/.shell_init" ~/.zshrc
	@echo '*** zsh setup ! ***'

##!    git     : setup git
.PHONY: git
git:
	./scripts/pkg.sh install vim git git-lfs
	./scripts/append.sh file ./conf/.gitignore ~/.gitignore
	./scripts/git_config.sh
	@echo '*** git setup ! ***'

##!    tmux    : install and configure tmux
.PHONY: tmux
tmux:
	./scripts/pkg.sh install tmux
	./scripts/append.sh file ./conf/.tmux.conf ~/.tmux.conf
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm || true
	tmux new-session -d 'tmux source ~/.tmux.conf && ~/.tmux/plugins/tpm/scripts/install_plugins.sh'
	./scripts/pkg.sh install_if2 dnf yum sysstat  # For a tmux plugin
	@echo '*** tmux setup ! ***'

##!    gdb     : install and configure gdb, install peda
.PHONY: gdb
gdb:
	./scripts/pkg.sh install gdb
	git clone https://github.com/zwimer/peda.git ~/.peda || true
	./scripts/append.sh file ./conf/.gdbinit ~/.gdbinit
	@echo '*** gdb setup ! ***'

##!    lldb     : configure lldb
.PHONY: lldb
lldb:
	./scripts/append.sh file ./conf/.lldbinit ~/.lldbinit
	@echo '*** lldb setup ! ***'

##!    vim     : install and configure vim and plugins
.PHONY: vim
vim: shell
	./scripts/pkg.sh install vim
	./scripts/default_vim.sh
	mkdir -v -p ~/.vim/colors
	mv ./conf/github.vim ~/.vim/colors/github.vim
	./scripts/append.sh file ./conf/.vimrc ~/.vimrc '" '
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim || true
	vim +PluginInstall +qall
	mkdir -p ~/.vim/after/
	echo "GitGutterEnable" > ~/.vim/after/gutter.vim
	@echo '*** vim setup ! ***'

##!    gpg     : install gpg
.PHONY: gpg
gpg: shell
	./scripts/pkg.sh install gnupg
	mkdir -m 700 ~/.gnupg || true
	./scripts/append.sh file ./conf/.gnupg/gpg.conf ~/.gnupg/gpg.conf
	./scripts/append.sh file ./conf/.gnupg/gpg-agent.conf ~/.gnupg/gpg-agent.conf
	chmod 600 ~/.gnupg/gpg.conf ~/.gnupg/gpg-agent.conf
	@echo '*** gpg setup ! ***'

##!    most    : do most of the above in order
.PHONY: most
most: shell python bash zsh git gpg tmux vim

##!    vim_ycm : install the vim plugin YouCompleteMe
.PHONY: vim_ycm
vim_ycm: vim python
	[ "$(MEMORY)" -ge 2000000 ] \
		|| (echo "*** Insufficient memory. You need at least 2GB! ***"; exit 1)
	./scripts/pkg.sh install_if2 apt apt-get cmake python3-dev   build-essential
	./scripts/pkg.sh install_if2 dnf yum     cmake python3-devel gcc-c++ make
	sed -i "s|\" Plugin 'Valloric/YouCompleteMe'| Plugin 'Valloric/YouCompleteMe'|g" ~/.vimrc
	vim +PluginInstall +qall
	cd ~/.vim/bundle/YouCompleteMe && ./install.py --clang-completer  # --force-sudo if root
	@echo '*** YouCompleteMe setup ! ***'

##!    linux   : do all of the above in order (skipping non-linux items)
.PHONY: linux
linux: most vim_ycm

##!    help    : print this helpful message
.PHONY: help
help:
	@echo $$'\n'"make options:"
	@sed -n 's/^##!//p' < ./Makefile
	@echo ""

# Constants

MEMORY = $$(grep MemTotal /proc/meminfo | sed -r 's/.* ([0-9]+) .*/\1/')
