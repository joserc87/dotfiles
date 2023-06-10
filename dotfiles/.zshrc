#############################
# CUSTOM OPTIONS ADDED BY ME:
#############################

export TERMINFO="$HOME/.terminfo"
export TERM=xterm-256color
# This one makes ranger crash
# export TERM=screen-256color

# for neovim
export XDG_CONFIG_HOME="$HOME/.config/"
# vi style incremental search
# look at www.drbunsen.org/the-text-triumvirate/

# nano? hell no!
[ "$EDITOR" = "$(which nano)" ] && unset EDITOR

# If neovim exists, use nvim, otherwise use vim
if ! type nvim >/dev/null; then
    export EDITOR=${EDITOR:-vim}
    alias nvim=vim
else
    export EDITOR=${EDITOR:-nvim}
    # This is just because I am used to type $ vim instead of $ nvim
    alias vim=nvim
fi
export SHELL="/bin/zsh"
bindkey -v

# TMUXINATOR
if hash tmuxinator 2>/dev/null; then
    alias mux=tmuxinator
fi

# Add this so we don't have to type cd
setopt AUTO_CD

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh
export DEFAULT_USER=jose

# To solve the weird characters on ssh
export LC_ALL=en_US.UTF-8
export LANG="$LC_ALL"

# Tokens for fb bots and wit.ai
export MESSENGER_PAGE_ACCESS_TOKEN=__FACEBOOK_PAGE_ACCESS_TOKEN_HERE__
export MESSENGER_VALIDATION_TOKEN=__FACEBOOK_VERIFY_TOKEN_HERE__
export WIT_TOKEN=__WIT_TOKEN_HERE__
export PORT=3000

############
# PROJECTS #
############

# TRIVIHASH
export TRIVIHASH_DATABASE_PASSWORD=trivihash

# CORTADO
# Tokens for fb bots and wit.ai
export MESSENGER_PAGE_ACCESS_TOKEN=__FACEBOOK_PAGE_ACCESS_TOKEN_HERE__
export MESSENGER_VALIDATION_TOKEN=__FACEBOOK_VERIFY_TOKEN_HERE__
export TELEGRAM_BOT_TOKEN=__TELEGRAM_TOKEN_HERE__
export WIT_TOKEN=__WIT_TOKEN_HERE__
export PORT=3000

source ~/.tokens


##############################
# DEFAULT OH-MY-ZSH CONFIG   #
##############################

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# The following would be the default theme
ZSH_THEME="robbyrussell"
# ZSH_THEME="joserc"
# ZSH_THEME="agnoster"
# ZSH_THEME="lambda-gister"
# ZSH_THEME="node"
# ZSH_THEME="spaceship"


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
export DISABLE_AUTO_TITLE="true"

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
plugins=(git virtualenv)

# User configuration

function add_path {
    [[ -e "$1" ]] && export PATH="$1:$PATH"
}
# -- JOSE --
# Deprecated:
# export PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"
# export PATH="$HOME/Dev/spell/build/install/spell/bin:$PATH"

# User defined scripts:
# Scripts folder is present for Linux and Mac OS

# In reverse order of priority
add_path "$HOME/.gem/ruby/2.4.0/bin"
add_path "/usr/local/Cellar/python/2.7.10_2/bin/"
add_path "$HOME/Library/Android/sdk/platform-tools/"
add_path "/Applications/MacPorts/MacVim.app/Contents/MacOS/"
add_path "/opt/flutter/.pub-cache/bin"
add_path "$HOME/macscripts/"
add_path "$HOME/scripts/"
add_path "$HOME/Scripts/"
add_path "$HOME/.local/bin"
add_path "$HOME/bin/"
add_path "$HOME/apps/"
add_path "$HOME/.cargo/bin"
add_path "$HOME/.pyenv/bin"
add_path "$HOME/go/bin"

export PYTHONPATH=.:..:./ravenpack:./python:$PYTHONPATH

# Android tools:
export PATH=\
~/Library/Android/sdk/platform-tools/\
:/Applications/MacPorts/MacVim.app/Contents/MacOS/\
:/opt/oracle/instantclient_21_1/\
:$PATH
# Antlr
export CLASSPATH=.:/usr/local/lib/antlr-4.5.3-complete.jar:$CLASSPATH
alias antlr4='java -jar /usr/local/lib/antlr-4.5.3-complete.jar'
alias grun='java org.antlr.v4.gui.TestRig'

# -- JOSE --
# rbenv
if which rbenv &> /dev/null;
then
    eval "$(rbenv init -)";
fi
# Path to the Gems:
#if [[ -e ~/.gem/ruby/2.4.0/bin ]];
#then
#    export PATH=~/.gem/ruby/2.4.0/bin/:$PATH
#fi

# Disable warning when .oh-my-zsh is shared between users
# https://github.com/robbyrussell/oh-my-zsh/issues/6835#issuecomment-390216875
ZSH_DISABLE_COMPFIX=true
source $ZSH/oh-my-zsh.sh
# Show the virtualenv
PROMPT+='%{$fg_bold[magenta]%}$(virtualenv_prompt_info)%{$reset_color%} '

# Virtualenv/VirtualenvWrapper
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/git
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
export VIRTUALENVWRAPPER_VIRTUALENV=/usr/local/bin/virtualenv
if [[ -f /usr/local/bin/virtualenvwrapper.sh ]];
then
    source /usr/local/bin/virtualenvwrapper.sh
elif [[ -f /usr/bin/virtualenvwrapper.sh ]];
then
    source /usr/bin/virtualenvwrapper.sh
fi

if [[ -f /opt/asdf-vm/asdf.sh ]];
then
    source /opt/asdf-vm/asdf.sh
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

# Python
if command -v pyenv 1>/dev/null 2>&1; then
  #eval "$(pyenv virtualenv init -)"
  #eval "$(pyenv init -)"
  #eval "$(pyenv init --path)"

  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
  __pyenv_version_ps1 (){
      local ret=$?;
      if [ -n "${PYENV_VERSION}" ]; then
          echo -n "(${PYENV_VERSION}) "
      fi
      return $?
  }

  export PYENV_VIRTUALENV_DISABLE_PROMPT=1
  PS1="\$(__pyenv_version_ps1)${PS1}"
fi

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# alias checktws="find -type f -exec egrep -l \" +$\" {} \;"
function checktws() {
    if [ "$1" != "" ]
    then
        find "$1" -type f -exec egrep -l " +$" {} \;
    else
        find . -type f -exec egrep -l " +$" {} \;
    fi
}


# Automatically change the directory in bash after closing ranger
#
# This is a bash function for .bashrc to automatically change the directory to
# the last visited one after ranger quits.
# To undo the effect of this function, you can type "cd -" to return to the
# original directory.

function ranger-cd {
    tempfile="$(mktemp -t tmp.XXXXXX)"
    /usr/bin/ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
        cd -- "$(cat "$tempfile")"
    fi
    rm -f -- "$tempfile"
}
alias rcd=ranger-cd
# Ranger + Tmux
alias rmux="ranger-cd && tmux new -s `echo '${PWD##*/}'`"
alias t='task'
# alias th="task priority:H"
# alias tl="task priority:H or priority:"
alias alamux='TERM=screen-256color tmux'
alias gs='git status'
alias tt="tmux new -s base -c ~ || tmux attach -t base -c ~"
alias ta="tmux attach"
alias tn="tmux new -s "

if command -v thefuck 1>/dev/null 2>&1; then
    eval $(thefuck --alias)
fi
if command -v zoxide 1>/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

##########
# ORACLE #
##########

# export ORACLE_HOME=/usr/lib/oracle/12.2/client64/lib/
export ORACLE_HOME=/usr/lib/
export LD_LIBRARY_PATH=\
/usr/lib/oracle/12.2/client64/lib/\
:/opt/oracle/instantclient_21_1/\
:$LD_LIBRARY_PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export JIRA_USER=jcano
alias my-jiras="jira-get 'code,summary' assignee=$JIRA_USER status='Open' separator=' '"

HISTSIZE=999999999

# -U to Ignore VCS ignore files (.gitignore)
export FZF_DEFAULT_COMMAND='ag --hidden --path-to-ignore ~/.ignore -U -f -g ""'
export TESTSHTUFF=testrunner


# Fix for Python in VIM:
# https://vi.stackexchange.com/questions/7644/use-vim-with-virtualenv/7654#7654
if [[ -n $VIRTUAL_ENV && -e "${VIRTUAL_ENV}/bin/activate" ]]; then
  source "${VIRTUAL_ENV}/bin/activate"
  touch ~/hack_worked
fi

source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

alias pytest py.test
#
# i3lock + suspend
function suspend {
    toggle_lamp.sh off
    if hash i3lock 2>/dev/null; then
        i3lock-fancy
        # i3lock -c 000000
    fi
    sleep 1
    systemctl suspend
}

function gnight {
    alacritty \
        -o font.size=16 \
        -o window.padding.x=16 \
        -o window.padding.y=16 \
        -o window.opacity=0.8 \
        -t 'scratchpad' \
        -e zsh -c 'sleep 0.1 && sleep_routine'
        #--class float \
    toggle_lamp.sh off
    /usr/bin/poweroff
}

alias poweroff gnight

function selectJira {
    FZF="fzf --height 7" jira-dmenu --snake | sed 's/:/_/g' || exit -1
}

function branch {
    branch_name=$(selectJira)
    if [ $branch_name ]; then
        git checkout -b $branch_name
    fi
}

function compton-toggle {
    if ps aux | grep "bash\s/.*/compton-blur"; then
        killall picom-kawase
    else
        compton-blur -b
    fi
}

function edsh {
    # Edits a script
    FILE_PATH=`which $1`
    $EDITOR $FILE_PATH
}

function nocaps {
    setxkbmap -option ctrl:nocaps
}

function checkout {
    git branch -a \
        | fzf \
        | sed 's/remotes\/origin\///' \
        | xargs git checkout
}

function vimjson {
    jq . $@| nvim -c 'set syntax=json' -
}

function freeze {
    pip freeze | grep $1
}

alias lg=lazygit

function fzf-pacman {
    pacman -Slq \
        | fzf --multi --preview 'pacman -Si {1}' \
        | xargs -ro sudo pacman -S
}

function fzf-yay {
    yay -Slq \
        | fzf --multi --preview 'yay -Si {1}' \
        | xargs -ro yay -S
}

function testhere {
    shtuff as $TESTSHTUFF
}

function saw {
    docker run --rm -it -v ~/.aws:~/.aws tbrock/saw $@
}

function tw {
    taskwarrior-tui
}

VPN_SERVICE=openvpn-client@ravenpack.service

function isvpnrunning {
    systemctl is-active --quiet $VPN_SERVICE
}

function shouldvpnrun {
    ! ping -c 1 -W 1 192.168.1.5 > /dev/null
}

function startvpn {
    if ! shouldvpnrun; then
        echo "VPN not needed"
        return
    fi
    if isvpnrunning; then
        echo "VPN is already running"
        return
    fi
    sudo systemctl start $VPN_SERVICE ||
}

function stopvpn {
    sudo systemctl stop $VPN_SERVICE
}

function screenoff {
    sleep 1 ; xset dpms force off
}

listprojects() {
    [ -d ~/git/ ] && \
        find ~/git/ -maxdepth 2 -mindepth 2 -type d \
        | grep forest -v \
        | grep '/hr/' -v
    [ -d ~/git/ ] && \
        find ~/git/python/ -maxdepth 2 -mindepth 2 -type d \
        | grep forest
    [ -d ~/git/ ] && \
        find ~/git/python/tools/apps/ -maxdepth 1 -mindepth 1 -type d
    [ -d ~/code/ ] && \
        find ~/code/ -maxdepth 1
}

code() {
    project=$(listprojects | fzf || exit)
    [[ -z "$project" ]] && return
    project_name=$(basename "$project")
    cd "$project"
    dirty_files=$(git status --porcelain | sed s/^...// | tr '\n' ' ')
    if [[ -n "$TMUX" ]]; then
        pyenv activate
        nvim
    else
        tmux new -d -s "$project_name"
        sleep 1
        tmux send-keys -t "$project_name.1" "vim $dirty_files" Enter
        tmux attach -t "$project_name"
    fi
}

tdd() {
    project=$(listprojects | fzf || exit)
    [[ -z "$project" ]] && return
    echo Testing in $project
    cd "$project"
    (sleep 1 && shtuff into $TESTSHTUFF "pyenv activate")&
    testhere
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
