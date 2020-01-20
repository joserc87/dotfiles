#!/bin/sh

info() {
    printf "\033[34m$1\\033[39m$2"
}
warn() {
    printf "\033[33m$1\\033[39m$2"
}

# Links file ./$1/$2 to ~/$2
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
		# If the directory to link to does not exist, create it
        if [ ! -e $3 ]; then
            mkdir -p $3
        fi
		cd $3
		echo "Creating symbolic link for "$3$4
		# echo ln -s $dir$1$2 $4
		ln -s $dir$1$2 $4
		cd $dir
    else
        echo "File $3$4 exists. Replace? [y/N]"
	fi
}
