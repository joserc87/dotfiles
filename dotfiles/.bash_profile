#  ---------------------------------------------------------------------------
#
#  Description:  This file holds all my BASH configurations and aliases
#
#  Found in http://natelandau.com/my-mac-osx-bash_profile/
#
#  Sections:
#  1.   Environment Configuration
#  2.   Make Terminal Better (remapping defaults and adding functionality)
#  3.   File and Folder Management
#  4.   Searching
#  5.   Process Management
#  6.   Networking
#  7.   System Operations & Information
#  8.   Web Development
#  9.   Reminders & Notes
#
#  ---------------------------------------------------------------------------

#   -------------------------------
#   1.  ENVIRONMENT CONFIGURATION
#   -------------------------------

#   Change Prompt
#   ------------------------------------------------------------
    #export PS1="________________________________________________________________________________\n| \w @ \h (\u) \n| => "
    #export PS2="| => "
    export PS1="TCF ~ jose$ "
    export PS2=" > "

#   Set Paths
#   ------------------------------------------------------------
    # For MacPorts
    export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
    export PATH="$PATH:/usr/local/bin/"
    # For MAMP
    export PATH="/Applications/MAMP/Library/bin:/Applications/MAMP/bin/php/php5.6.7/bin:~/.composer/vendor/bin:$PATH"

#   Set Default Editor (change 'Nano' to the editor of your choice)
#   ------------------------------------------------------------
    export EDITOR=/usr/bin/vim

#   Set default blocksize for ls, df, du
#   from this: http://hints.macworld.com/comment.php?mode=view&cid=24491
#   ------------------------------------------------------------
    export BLOCKSIZE=1k

#   Add color to terminal
#   (this is all commented out as I use Mac Terminal Profiles)
#   from http://osxdaily.com/2012/02/21/add-color-to-the-terminal-in-mac-os-x/
#   ------------------------------------------------------------
    export CLICOLOR=1
    export LSCOLORS=ExFxBxDxCxegedabagacad

#   It would continue with aliases
