#!/bin/zsh

info() {
    echo -en "\e[34m$1\\e[39m$2"
}
warn() {
    echo -en "\e[33m$1\\e[39m$2"
}

brew_update() {
    if ! hash brew 2>/dev/null; then
        echo "brew - Installing..."
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" >/dev/null;
        echo "brew - Installed."
    fi

    info "brew" ": Updating..."
    brew update >/dev/null;
    echo "Done."
}

# The first argument is the package name
# The second argument is one of the programs in the package, to check
brew_install() {
    # Install brew if not installed yet
    if ! hash $2 2>/dev/null; then
        info $1 ": Installing..."
		brew install $1
        echo "Done."
    else
        info $1 ": Already installed.\n"
    fi
}

warn "Installing software:\n"
# Brew:
brew_update
brew_install neovim nvim
brew_install node node
brew_install grunt-cli grunt
warn "Done\n"
