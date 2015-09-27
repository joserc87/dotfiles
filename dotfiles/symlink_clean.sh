dotfiles=""

symlink_remove () {
	if [ ! -e ~/$2 ]; then
		dir=`pwd`/
		cd ~
		echo "Removing symlink "$2
		echo rm $2
		rm $2
		cd $dir
	fi
}

symlink_remove vim/ .vim
symlink_remove vim/ .vimrc
symlink_remove "" .bash_profile
symlink_remove "" .zshrc
symlink_remove "" .tmux.conf

