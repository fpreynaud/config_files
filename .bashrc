# .bashrc

# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=2000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

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

# My part ######################################################################################################

#droits par défaut d'un fichier : rwx r-x ---
umask 027

#associate names with console codes
black="\[\e[30m\]"
red="\[\e[31m\]"
green="\[\e[32m\]"
yellow="\[\e[33m\]"
blue="\[\e[34m\]"
magenta="\[\e[35m\]"
cyan="\[\e[36m\]"
white="\[\e[37m\]"
bgblack="\[\e[40m\]"
bgred="\[\e[41m\]"
bggreen="\[\e[42m\]"
bgyellow="\[\e[43m\]"
bgblue="\[\e[44m\]"
bgmagenta="\[\e[45m\]"
bgcyan="\[\e[46m\]"
bgwhite="\[\033[47m\]"
bold="\[\e[1m\]"
nocol="\[\e[0m\]"

function is_git_repository()
{
	local path=$PWD

	if [ -d "$path/.git" ]; then
		echo 1
		return 1
	else
		while [ "$(realpath $path)" != "/" ]
		do
			if [ -d "$path/.git" ]; then
				echo 1
				return 1
			fi
			path=$path/..
		done
	fi
	echo 0
	return 0
}

function run_on_prompt()
{
	local userHost="$bgblue[\u@\h \W]";
	#echo -e "\033]2;${USER}@${HOSTNAME}:${PWD/#$HOME/\~}"; #Set window title
	local _jobs='';
	local nJobs=$(jobs|wc -l);
	if [ "$nJobs" -gt 0 ]; then
		_jobs="$bgyellow[$nJobs]";
	fi
	local currentBranch='';
	if [ "$(is_git_repository)" -eq 1 ]; then
		local branchName="$(git branch --no-color|\grep '*'|cut -f 2 -d ' ')";
		currentBranch="$bggreen[$branchName]";
	fi;
	PS1="\n$white$bold$userHost$_jobs$currentBranch$bgwhite$black[\!]$nocol " # [user@host workingDirectory][backGroundJobsCount][currentGitBranch][nextCommandHistoryNumber]
	local lastCommand=$(history 1|sed s/"\(\s\+\)"/" "/g|cut -f5- -d " ")
	if [ "$lastCommand" != "$PERSISTENT_HISTORY_LAST" ]; then
		echo $lastCommand >> ~/.persistent_history
		export PERSISTENT_HISTORY_LAST=$lastCommand
	fi
}

PROMPT_COMMAND="run_on_prompt"

# exports
export HISTTIMEFORMAT='%d/%m/%y %H:%M '
export trash=~/.local/share/Trash/files

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
function pyv
{
	local version=$(python --version |& \grep -o "[0-9]\.[0-9]")
	case $version in
		2.7) ln -sf /usr/local/bin/python2.6 /usr/local/bin/python;;
		2.6) ln -sf /usr/local/bin/python2.7 /usr/local/bin/python;;
	esac
	echo $(python --version)
}

# "Go to directory containing the file" function (ocf = 'Open Containing Folder')
function ocf
{
	cd $(dirname `readlink -e $1`)
}

function rm
{
	local therm
	if [ -e "$HOME/bin/rm" ]; then
		therm="$HOME/bin/rm"
	else
		therm="/bin/rm"
	fi
	eval $therm "$@"
}

# synopsis: cs [dir]
# go into dir and list its contents immediatly
function cs
{
	pushd . >/dev/null
	\cd -P "$@" && ls --group-directories-first
}

function findcommit
{
	git log --branches=* --oneline -i --grep="$1" --pretty=format:"%H %s" | cat
}

. ~/.aliases
export http_proxy=http://www-cache-nrs.si.fr.intraorange:3128
export https_proxy=http://www-cache-nrs.si.fr.intraorange:3128


# define custom colors for ls
eval `dircolors ~/.dircolors`

# Enable autocd
shopt -s autocd

# Start network if OS is Kali
if [ -e "/etc/os-release" ] && [ -n "$(grep "NAME=\"Kali" /etc/os-release)" ]; then
	ifconfig eth0 up
	dhclient eth0
	service smbd start
fi
export PATH=/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin:/root/bin:.
source /etc/bash_completion.d/git

superpopd () 
{ 
    for n in $(seq 0 $1);
    do
        \popd -n;
    done
}

pydoc ()
{
	python -c "import $1;help($1)"
}
shopt -s histverify lithist xpg_echo
