# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples


# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]
then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null 
	then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
		color_prompt=yes
    else
		color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
#case "$TERM" in
#xterm*|rxvt*)
#    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
#    ;;
#*)
#    ;;
#esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto --group-directories-first'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi


# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias lad='la -Ad'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# My part ######################################################################################################

#droits par défaut d'un fichier : rwx r-x ---
umask 027

#associate names with console codes
black=30
bgblack=40
red=31
bgred=41
green=32
bggreen=42
brown=33
bgbrown=43
blue=34
bgblue=44
magenta=35
bgmagenta=45
cyan=36
bgcyan=46
white=37
bgwhite=47
bold=1
nobold=21
defaultDispAtt=0

# exports
export PATH=$PATH:~/bin:./:~/Téléchargements/android-sdk-linux/platform-tools/:~/Téléchargements/android-sdk-linux/tools/
export HISTTIMEFORMAT='%d/%m/%y %H:%M '
export CDPATH=$CDPATH:~/.bookmarks
export PS1="\[\e[${bgwhite};${blue};${bold}m\]\w\[\e[${defaultDispAtt}m\]\n\r\[\e[${bgwhite};${blue};${bold}m\]\u@\h(\t)\$\[\e[${defaultDispAtt}m\]\n"
export trash=~/.local/share/Trash/files

# functions
# "Go to directory containing the file" function
function cdirlink
{
	cd $(dirname `readlink -e $1`)
}

unalias cd 2> /dev/null
# synopsis: cs [dir]
# go into dir and list its contents immediatly
function cs
{
	pushd . >/dev/null
	cd -P "$@" && ls
}
alias cd=cs

# synopsis: bookmark bookmark_name [target]
# creates a symbolic link to target in ~/.bookmarks. The default value for
# target is $PWD 
function bookmark
{
	getopts ":vs" opt
	case $opt in
		s)ls ~/.bookmarks;
		OPTIND=1;
		shift;;
		v)ls -l ~/.bookmarks;
		OPTIND=1;
		shift;;
	esac

	if [ $# -eq 1 ]
	then
		ln -f -s $PWD ~/.bookmarks/$1
	fi

	if [ $# -eq 2 ]
	then
		ln -f -s `readlink -f $2` ~/.bookmarks/$1
	fi

	OPTIND=1
}

# synopsis: display display_attribute[(;display_attribute)...] text
# print text with the given display attributes
function display
{
	echo -e "\033[${1}m$2"
	echo -ne "\033[${defaultDispAtt}m"
}

function savefiche
{
	OPTIND=1
	getopts ":vus" opt
	case $opt in
		u)cp -Lu ~/fiches/* ~/documents/fiches;
		shift;;
		s)ls ~/fiches;
		return;;
		v)ls -l ~/fiches;
		return;;
	esac

	if [ $# -ge 1 ]
	then
		echo $1
		ln -s -f `readlink -f $1` ~/fiches
	fi
	OPTIND=1
	
}

# define custom colors for ls
dircolors ~/ls_couleurs 2>/dev/null >/dev/null
eval `dircolors ~/.ls_couleurs`
bind -x '"\C-\M-T":terminator'
