export DISABLE_AUTO_TITLE="true"
# Part of the config added from https://github.com/dreamsofautonomy/zensh/blob/main/.zshrc
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings

# > Emacs
# > no VIM!
# bindkey -e

# > Let me fix that:
# > Emacs?
# > no, VIM!
bindkey -v
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region
autoload edit-command-line
zle -N edit-command-line
bindkey '^Xe' edit-command-line
bindkey '^X^e' edit-command-line

# History
HISTSIZE=999999999
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'


# Shell integrations
if command -v fzf 1>/dev/null 2>&1; then
    eval "$(fzf --zsh)"
fi
if command -v zoxide 1>/dev/null 2>&1; then
    #eval "$(zoxide init --cmd cd zsh)"
    eval "$(zoxide init zsh)"
fi
if command -v thefuck 1>/dev/null 2>&1; then
    eval $(thefuck --alias)
fi

# CUSTOM OPTIONS ADDED BY ME:
export TERMINFO="$HOME/.terminfo"
export TERM=xterm-256color
# This one makes ranger crash
# export TERM=screen-256color

# for neovim
export XDG_CONFIG_HOME="$HOME/.config/"

# if [ -n "$NVIM" ]; then
if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
    export VISUAL="nvr -cc split --remote-wait +'set bufhidden=wipe'"
    export EDITOR="nvr -cc split --remote-wait +'set bufhidden=wipe'"
    alias nvim=nvr -cc split --remote-wait +'set bufhidden=wipe'
elif type nvim >/dev/null; then
    export VISUAL="nvim"
    export EDITOR="nvim"
    # This is just because I am used to type $ vim instead of $ nvim
    alias vim=nvim
    alias v=nvim
elif type vim >/dev/null; then
    export EDITOR="vim"
else
    export EDITOR=${EDITOR:-vim}
fi
export SHELL="/bin/zsh"
bindkey -v

# Add this so we don't have to type cd
setopt AUTO_CD

# To solve the weird characters on ssh
export LC_ALL=en_US.UTF-8
export LANG="$LC_ALL"

source ~/.tokens

function add_path {
    [[ -e "$1" ]] && export PATH="$1:$PATH"
}

# -- JOSE --
# Deprecated:
# In reverse order of priority
add_path "$HOME/scripts/"
add_path "$HOME/.local/bin"
add_path "$HOME/bin/"
add_path "$HOME/apps/"
add_path "$HOME/.cargo/bin"
add_path "$HOME/.pyenv/bin"
add_path "$HOME/go/bin"

# Python
if command -v pyenv 1>/dev/null 2>&1; then
  #eval "$(pyenv virtualenv init -)"
  eval "$(pyenv init -)"
  #eval "$(pyenv init --path)"

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

export PYTHONPATH=.:..:./ravenpack:./python #:$PYTHONPATH

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
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

function nvm_lazyload {
    unalias nvm
    \. "$NVM_DIR/nvm.sh" # This loads nvm
    nvm $@
}
[ -s "$NVM_DIR/nvm.sh" ] && alias nvm='nvm_lazyload'

export JIRA_USER=jcano

HISTSIZE=999999999

# -U to Ignore VCS ignore files (.gitignore)
export FZF_DEFAULT_COMMAND='ag --hidden --path-to-ignore ~/.ignore -U -f -g ""'
export TESTSHTUFF=testrunner

source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# Aliases
alias ls='ls --color'
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
alias t='task -backlog'
# alias th="task priority:H"
# alias tl="task priority:H or priority:"
alias alamux='TERM=screen-256color tmux'
alias gs='git status'
alias ta="tmux attach"
alias tn="tmux new -s "
alias c='clear'
alias my-jiras="jira-get 'code,summary' assignee=$JIRA_USER status='Open' separator=' '"

#alias pytest py.test
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
    # Use Caps Lock as Ctrl
    setxkbmap -option ctrl:nocaps
    # Tap Caps Lock for Escape
    xcape -e '#66=Escape'
}

function checkout {
    git branch -a \
        | fzf \
        | sed 's/remotes\/origin\///' \
        | xargs git checkout
}

function vimjson {
    jq . $@| $EDITOR -c 'set syntax=json' -
}

function freeze {
    pip freeze | grep $1
}

alias lg=lazygit
alias tt="tt -quotes ~/Documents/en.txt"

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
    shtuff as "$(pwd -P)"
    # shtuff as "$TESTSHTUFF"
}

function saw {
    docker run --rm -it -v ~/.aws:~/.aws tbrock/saw $@
}

function tw {
    taskwarrior-tui
}

# OpenVPN
VPN_SERVICE=openvpn-client@ravenpack.service
# Wireguard
VPN_SERVICE=wg-quick@wg0

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

function restartvpn {
    stopvpn && startvpn
}

function screenoff {
    sleep 1 ; xset dpms force off
}

# Moved to its own script
# listprojects() {
#     [ -d ~/git/ ] && \
#         find ~/git/ -maxdepth 2 -mindepth 2 -type d \
#         | grep forest -v \
#         | grep '/hr/' -v
#     [ -d ~/git/ ] && \
#         find ~/git/python/ -maxdepth 2 -mindepth 2 -type d \
#         | grep forest
#     [ -d ~/git/ ] && \
#         find ~/git/python/tools/apps/ -maxdepth 1 -mindepth 1 -type d
#     [ -d ~/git/ ] && \
#         find ~/git/python/tools/libs/ -maxdepth 1 -mindepth 1 -type d
#     [ -d ~/git/ ] && \
#         find ~/git/python/smart-topics/lambda/ -maxdepth 1 -mindepth 1 -type d
#     [ -d ~/git/ ] && \
#         find ~/git/python/smart-topics/lambda/ -maxdepth 3 -mindepth 3 -type d | grep /libs/
#     [ -d ~/git/ ] && \
#         find ~/git/python/smart-topics/lambda/shared/ -maxdepth 1 -mindepth 1 -type d
#     [ -d ~/code/ ] && \
#         find ~/code/ -maxdepth 1
# }
# 
code() {
    project=$(listprojects | fzf || exit)
    [[ -z "$project" ]] && return
    project_name=$(basename "$project")
    cd "$project"
    dirty_files=$(git status --porcelain . | sed s/^...// | tr '\n' ' ')
    if [[ -n "$TMUX" ]]; then
        pyenv activate
        $EDITOR
    else
        tmux new -d -s "$project_name"
        sleep 1
        tmux send-keys -t "$project_name.1" "$EDITOR $dirty_files\n" Enter
        tmux attach -t "$project_name"
    fi
}

tdd() {
    project=$(listprojects | fzf || exit)
    [[ -z "$project" ]] && return
    echo Testing in $project
    cd "$project"
    export TESTSHTUFF="$(pwd)"
    [ -e .python-version ] && (sleep 1 && shtuff into $TESTSHTUFF "pyenv activate")&
    testhere
}

#######
# AWS #
#######

ddb_list_tables() {
	aws dynamodb list-tables | jq -r '.TableNames[]' | fzf
}
ddb_select_table() {
	export LAST_DDB_TABLE=$(ddb_list_tables)
}
ddb_ensure_has_table_selected() {
	[[ -z "$LAST_DDB_TABLE" ]] && ddb_select_table
}
ddb_describe_table() {
	ddb_ensure_has_table_selected
	aws dynamodb describe-table --table-name "$LAST_DDB_TABLE"
}
ddb_get_item() {
	ddb_ensure_has_table_selected
	aws dynamodb query \
	    --table-name "$LAST_DDB_TABLE" \
	    --key-condition-expression 'id = :value' \
	    --expression-attribute-values '{
	        ":value": {"S": "'"$1"'"}
	    }'
}
ddb_preview() {
	ddb_ensure_has_table_selected
	aws dynamodb scan --table-name "$LAST_DDB_TABLE" | jq -r '.Items[].id.S'
}
check_job_status() {
    curl -X 'GET' \
      "https://dumpy-api.prod.nvirginia.delivery.ravenpack.com/datafiles/$1" \
      -H 'accept: application/json' \
      -H "api_key: $RP_API_KEY" \
      -s \
     | jq -r '.datafile.status'
}
pyrepl() {
    tempfile="$(mktemp -t pyrepl.XXXXXX)"
    nvim "$tempfile" +'Codi python'
}
jsrepl() {
    tempfile="$(mktemp -t pyrepl.XXXXXX)"
    nvim "$tempfile" +'Codi javascript'
}
athome() {
    lsusb | grep DisplayLink > /dev/null
}
back2desk() {
    profile=$(athome && echo "usb-only" || echo "ofi")
    nocaps
    xset r rate 180 80
    autorandr $profile
}
curlbench() {
    # Fill in the curl-format.txt file with mulitple lines
    cat <<EOF > /tmp/curl-format.txt
   time_namelookup:  %{time_namelookup}s\n
      time_connect:  %{time_connect}s\n
   time_appconnect:  %{time_appconnect}s\n
  time_pretransfer:  %{time_pretransfer}s\n
     time_redirect:  %{time_redirect}s\n
time_starttransfer:  %{time_starttransfer}s\n
        ----------   ---------\n
        time_total:  %{time_total}s\n
EOF
    curl -w "@/tmp/curl-format.txt" -o /dev/null -s "$1"
}
