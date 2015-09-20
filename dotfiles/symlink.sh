dotfiles=""

symlink_home () {
	if [ ! -e ~/$2 ]; then
		dir=`pwd`/
		cd ~
		echo "Creating symbolic link for ~/"$2
		echo ln -s $dir$1$2 $2
		ln -s $dir$1$2 $2
		cd $dir
	fi
}

symlink_home vim/ .vim
symlink_home vim/ .vimrc
symlink_home "" .bash_profile
symlink_home "" .zshrc
symlink_home "" .oh-my-zsh
symlink_home "" .tmux.conf

