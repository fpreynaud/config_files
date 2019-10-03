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

PROMPT_COMMAND="\
	userHost=\"\$bgblue[\u@\h \W]\";\
	echo -e \"\033]2;\${USER}@\${HOSTNAME}:\${PWD/#\$HOME/~}\007\";\
	_jobs='';\
	nJobs=\$(jobs|wc -l);\
	if [ \"\$nJobs\" -gt 0 ]; then\
		_jobs=\"\$bgyellow[\$nJobs]\";\
	fi
	currentBranch='';\
	branches=\$(git branch --no-color 2>/dev/null);\
	if [ -n \"\$branches\" ]; then\
		branchName=\"\$(git branch --no-color 2>/dev/null|\grep '*'|cut -f 2 -d ' ')\";\
		currentBranch=\"\$bggreen[\$branchName]\";\
	fi
	PS1=\"\$white\$bold\$userHost\$_jobs\$currentBranch\$nocol \";"

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
	version=$(python --version |& \grep -o "[0-9]\.[0-9]")	
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
