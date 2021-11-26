# .bashrc

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
	local _jobs=''
	local nJobs=$(jobs|wc -l)
	local gitBranch=''
	local symbol='@'
	local prompt_color="$green"

	if [ "$EUID" -eq 0 ]; then
		symbol=$(printf "\U1F480")
		prompt_color="$red"
	fi

	if [ "$nJobs" -gt 0 ]; then
		_jobs="─[${bgred}${bold}${white}${nJobs}${nocol}${prompt_color}]"
	fi

	if [ "$(is_git_repository)" -eq 1 ]; then
		local branchName="$(git branch --no-color|\grep '*'|cut -f 2 -d ' ')";
		gitBranch="─[${bggreen}${white}${bold}${branchName}${nocol}${prompt_color}]"
	fi;

	local identity="${blue}${bold}\u ${symbol} \h${prompt_color}"
	local workingDir="${nocol}\w${prompt_color}"

	PS1="$prompt_color\
┌─(${identity})─[${workingDir}]${gitBranch}${_jobs}
└─${nocol}\$ "

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
export LESS_TERMCAP_md=$(tput bold; tput setaf 3)
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

# define custom colors for ls
eval `dircolors ~/.dircolors`

# Enable autocd
shopt -s autocd

export PATH=/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin:/root/bin:.
source /etc/bash_completion.d/git

superpopd () 
{ 
    for n in $(seq 0 $1);
    do
        \popd -n;
    done
}

shopt -s histverify lithist xpg_echo
