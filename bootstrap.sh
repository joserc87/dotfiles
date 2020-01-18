#!/usr/bin/env bash

USER_HOME=$(getent passwd $SUDO_USER | cut -d: -f6)
REPO=https://github.com/joserc87/config-files
REPO_DIR=$USER_HOME/code/config-files
PROGRAMS_LIST_FILE=$REPO_DIR/programs.txt
do="sudo -u $SUDO_USER "

check_is_sudo() {
	if [ "$EUID" -ne 0 ]; then
		echo "ERROR: Please run as root"
		exit
	fi
}

update() {
	echo "...Updating the package manager"
	if type pacman > /dev/null; then
		pacman -Syuu --noconfirm
	elif type apt-get > /dev/null; then
		apt-get update -y
	fi
}

install() {
	if type pacman > /dev/null; then
		pacman -S $@ --noconfirm
	elif type apt-get > /dev/null; then
		apt-get install $@
	fi
}

install_pre_req() {
	echo "...Installing pre-requirements"
	install git
}

install_all() {
	echo "...Installing the rest of the requirements"
	install $(cat $PROGRAMS_LIST_FILE)
}

clone_dotfiles() {
	echo "...Cloning the github repo"
	$do mkdir -p $REPO_DIR
	$do git clone $REPO $REPO_DIR
}

link_dotfiles() {
	echo "...Deploying the dotfiles in the system"
	cd $REPO_DIR
	$do ./symlink.sh
	cd $USER_HOME
}

install_generic_software() {
    # Vundle
    if [ ! -e $USER_HOME/.vim/bundle/Vundle.vim ]; then
        echo "Installing Vundle\n";
        $do git clone https://github.com/VundleVim/Vundle.vim.git $USER_HOME/.vim/bundle/Vundle.vim;
    else
        echo "Vundle already installed\n";
    fi
    # OhMyZsh
    if [ ! -e $USER_HOME/.oh-my-zsh/ ]; then
        # A new .zshrc will be generated as part of the process, so let's back it up
        mv $USER_HOME/.zshrc $USER_HOME/.zshrc.bak
        wget_url=https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
        if type curl > /dev/null; then
            $do sh -c "$(curl -fsSL $wget_url)" "" --unattended
            echo a
        elif type wget > /dev/null; then
            $do sh -c "$(wget -O- $wget_url)" "" --unattended
            echo a
        else
            echo 'Curl or wget needed'
            exit
        fi
        rm $USER_HOME/.zshrc
        mv $USER_HOME/.zshrc.bak $USER_HOME/.zshrc
    fi
    $do chsh -s $(which zsh)
}

bootstrap() {
	check_is_sudo
	update
	install_pre_req
	clone_dotfiles
	install_all
	link_dotfiles
    install_generic_software
}

bootstrap
