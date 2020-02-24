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
		info "Creating symbolic link for ~/$2\n"
		# echo ln -s $dir$1$2 $2
		ln -s $dir$1$2 $2
		cd $dir
	fi
}

symlink() {
    # If the file exists and it's not a link, ask if we should remove it
    if [[ -e "$3/$4" && ! -L "$3/$4" ]]; then # If it's not a symlink
        read -p "File $3/$4 exists. Merge? [y/N]" -r
        # echo # (optional) move to a new line
        if [[ $REPLY =~ ^[Yy]$ ]]
        then
            if [[ -d "$3/$4" ]]; then
                # If we could remove it, it was empty
                if ! rmdir "$3/$4" ; then
                    # If it's a directory, move all the content and rmdir
                    warn "Moving $3/$4/* to $1/$2/\n"
                    mv "$3/$4/"* "$3/$4/".* "$1/$2/"
                    rmdir "$3/$4"
                fi
            else
                # if it's just a file, then just move it
                warn "Moving $3/$4 to $1/$2\n"
                mv "$3/$4" "$1/$2"
            fi
        fi
    fi
    # If the file does not exist, link it
	if [ ! -e "$3/$4" ]; then
		dir=`pwd`/
		# If the directory to link to does not exist, create it
        if [ ! -e $3 ]; then
            mkdir -p $3
        fi
		cd $3
		info "Creating symbolic link for $3/$4\n"
		# echo ln -s $dir$1$2 $4
		ln -s $dir$1$2 $4
		cd $dir
	fi
}
