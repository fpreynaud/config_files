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

# enable color support of ls
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

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
export CDPATH=$CDPATH:~/.bookmarks
export DEFAULTPATH=/usr/local/bin:/usr/bin:/bin
export HISTTIMEFORMAT='%d/%m/%y %H:%M '
export PATH=$DEFAULTPATH:./:/usr/local/sbin:/usr/sbin:/sbin
export PDF_READER='apvlv'
export PS1="\[\e[${bgwhite};${red};${bold}m\]\w\[\e[${defaultDispAtt}m\]\n\r\[\e[${bgwhite};${red};${bold}m\]\u@\h(\t)\$\[\e[${defaultDispAtt}m\]\n"
export trash=~/.local/share/Trash/files
export PAGER=less

# colors for less
export LESS_TERMCAP_mb=$(tput bold; tput setaf 2)
export LESS_TERMCAP_md=$(tput bold; tput setaf 8)
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4)
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
export LESS_TERMCAP_us=$(tput smul; tput setaf 6)
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
export LESS_TERMCAP_mr=$(tput rev)
export LESS_TERMCAP_mh=$(tput dim)
export LESS_TERMCAP_ZN=$(tput ssubm)
export LESS_TERMCAP_ZV=$(tput rsubm)
export LESS_TERMCAP_ZO=$(tput ssupm)
export LESS_TERMCAP_ZW=$(tput rsupm)
export LESS="--RAW-CONTROL-CHARS"

# functions
#
# "Go to directory containing the file" function (ocf = 'Open Containing Folder')
function ocf
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
	getopts ":vsh" opt
	case $opt in
		s)ls ~/.bookmarks;
		OPTIND=1;
		shift;;
		v)ls -l ~/.bookmarks;
		OPTIND=1;
		shift;;
		h)echo -e "Synopsis: bookmark bookmark_name [target]

creates a symbolic link named bookmark_name to target in ~/.bookmarks. The default value for target is \$PWD

Options:
-s show bookmarks
-v show bookmarks in long format
-h display this help";
	OPTIND=1
		return;;
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

# define custom colors for ls
eval `dircolors ~/.dircolors`

# enable autochdir: typing <directoryname> is the same as typing cd <directoryname>
shopt -s autocd
