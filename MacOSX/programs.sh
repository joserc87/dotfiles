#!/bin/zsh

info() {
    echo -en "\e[34m$1\\e[39m$2"
}
warn() {
    echo -en "\e[33m$1\\e[39m$2"
}

brew_update() {
    if ! hash brew 2>/dev/null; then
        info "brew" ": Installing..."
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" >/dev/null;
        echo "Done."
    fi

    info "brew" ": Updating..."
    brew update >/dev/null;
    echo "Done."
}

# The first argument is the package name
# The second argument is one of the programs in the package, to check
brew_install() {
    # Install brew if not installed yet
    if ! hash $1 2>/dev/null; then
        info $2 ": Installing..."
		brew install $2
        echo "Done."
    else
        info $2 ": Already installed.\n"
    fi
}

warn "Installing software:\n"
# Homebrew:
brew_update
brew_install zsh zsh-completions
brew_install zsh zsh
brew_install nvim neovim
brew_install node node
brew_install grunt grunt-cli

# Oh my zsh
if [ -z ${ZSH} ]; then
    info "oh-my-zsh" ": Installing..."
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" >/dev/null;
    echo "Done."
else
    info "oh-my-zsh" ": Already installed.\n"
fi

warn "Done\n"
