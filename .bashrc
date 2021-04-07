# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

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
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi


if [ "$color_prompt" = yes ]; then
    # override default virtualenv indicator in prompt
    VIRTUAL_ENV_DISABLE_PROMPT=1

    prompt_color='\[\033[;32m\]'
    info_color='\[\033[1;34m\]'
    prompt_symbol=㉿
    if [ "$EUID" -eq 0 ]; then # Change prompt colors for root user
	prompt_color='\[\033[;94m\]'
	info_color='\[\033[1;31m\]'
	prompt_symbol=💀
    fi
    PS1=$prompt_color'┌──${debian_chroot:+($debian_chroot)──}${VIRTUAL_ENV:+(\[\033[0;1m\]$(basename $VIRTUAL_ENV)'$prompt_color')}('$info_color'\u${prompt_symbol}\h'$prompt_color')-[\[\033[0;1m\]\w'$prompt_color']\n'$prompt_color'└─'$info_color'\$\[\033[0m\] '
    # BackTrack red prompt
    #PS1='${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV)) }${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls, less and man, and also add handy aliases
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
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# My part ######################################################################################################


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

function is_in_git_repository()
{
	local result=0
	local dir=$(realpath $PWD)
	while [ "$dir" != "/" ]; do
		if [ -d "$dir/.git" ]; then
			result=1
		fi
		dir=$(realpath $dir/..)
	done
	echo $result
}

function run_on_prompt()
{
	local userHost="$bgblue[\u@\h \W]";
	#echo -e "\033]2;${USER}@${HOSTNAME}:${PWD/#$HOME/\~}"; #Set window title
	local _jobs='';
	local nJobs=$(jobs|wc -l);
	local isGit=$(is_in_git_repository)

	if [ "$nJobs" -gt 0 ]; then
		_jobs="$bgyellow[$nJobs]";
	fi
	local currentBranch='';
	if [ $isGit -eq 1 ]; then
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

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:.
shopt -s histverify lithist xpg_echo
