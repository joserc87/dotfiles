#############################
# CUSTOM OPTIONS ADDED BY ME:
#############################

# in neovim, <C-H> won't work:
# Solution found at https://github.com/neovim/neovim/wiki/FAQ#my-ctrl-h-mapping-doesnt-work
# if .terminfo does not exist, apply
# infocmp $TERM | sed 's/kbs=^[hH]/kbs=\\177/' > $TERM.ti
#tic $TERM.ti"
export TERMINFO="$HOME/.terminfo"

# for neovim
export XDG_CONFIG_HOME="~/.config/"
# vi style incremental search
# look at www.drbunsen.org/the-text-triumvirate/

# If neovim exists, use nvim, otherwise use vim
if ! hash nvim 2>/dev/null; then
    export EDITOR="vim"
else
    export EDITOR="nvim"
    # This is just because I am used to type $ vim instead of $ nvim
    alias vim=nvim
fi
export SHELL="/bin/zsh"
bindkey -v

# Add this so we don't have to type cd
setopt AUTO_CD

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh
export DEFAULT_USER=jose

# To solve the weird characters on ssh
export LC_ALL=en_US.utf-8
export LANG="$LC_ALL"

# Tokens for fb bots and wit.ai
export MESSENGER_PAGE_ACCESS_TOKEN=__FACEBOOK_PAGE_ACCESS_TOKEN_HERE__
export MESSENGER_VALIDATION_TOKEN=__FACEBOOK_VERIFY_TOKEN_HERE__
export WIT_TOKEN=__WIT_TOKEN_HERE__
export PORT=3000

##############################
# DEFAULT OH-MY-ZSH CONFIG   #
##############################

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# The following would be the default theme
# ZSH_THEME="robbyrussell"
ZSH_THEME="agnoster"


# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# User configuration

#export PATH="/Applications/MAMP/Library/bin:/Applications/MAMP/bin/php/php5.6.7/bin:~/.composer/vendor/bin:/opt/local/bin:/opt/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/Library/TeX/texbin:/Applications/MAMP/Library/bin:/Applications/MAMP/bin/php/php5.6.7/bin:~/.composer/vendor/bin:/opt/local/bin:/opt/local/sbin:/usr/local/bin/:/usr/local/bin/"
# export MANPATH="/usr/local/man:$MANPATH"
export PATH=~/scripts/:~/macscripts/:/usr/local/Cellar/python/2.7.10_2/bin/:$PATH
# Python
export PYTHONPATH=~/dev/whatsapp/cortado/yowsup/:.:$PYTHONPATH
# Android tools:
export PATH=~/Library/Android/sdk/platform-tools/:/Applications/MacPorts/MacVim.app/Contents/MacOS/:$PATH
# Antlr
export CLASSPATH=.:/usr/local/lib/antlr-4.5.3-complete.jar:$CLASSPATH
alias antlr4='java -jar /usr/local/lib/antlr-4.5.3-complete.jar'
alias grun='java org.antlr.v4.gui.TestRig'

source $ZSH/oh-my-zsh.sh

# Virtualenv/VirtualenvWrapper
if [[ -f /usr/local/bin/virtualenvwrapper.sh ]];
then
    source /usr/local/bin/virtualenvwrapper.sh
fi

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
