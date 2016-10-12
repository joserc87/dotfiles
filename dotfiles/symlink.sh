dotfiles=""

symlink_home () {
	if [ ! -e ~/$2 ]; then
		dir=`pwd`/
		cd ~
		echo "Creating symbolic link for ~/"$2
		# echo ln -s $dir$1$2 $2
		ln -s $dir$1$2 $2
		cd $dir
	fi
}

symlink() {
	if [ ! -e $3$4 ]; then
		dir=`pwd`/
		cd $3
		echo "Creating symbolic link for "$3$4
		# echo ln -s $dir$1$2 $4
		ln -s $dir$1$2 $4
		cd $dir
	fi
}



symlink_home vim/ .vim
symlink_home vim/ .vimrc
symlink vim/ .vimrc ~/.config/nvim/ init.vim

symlink_home git/ .gitconfig
symlink_home git/ .gitignore_global

symlink_home "" .bash_profile
symlink_home "" .zshrc
symlink_home "" .tmux.conf

