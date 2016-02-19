[ -r $HOME/.dotfiles/shell/commonrc ] && \
    source $HOME/.dotfiles/shell/commonrc zsh


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
export DEFAULTPATH=/usr/local/bin:/usr/bin:/bin:/home/francois/bin:/home/francois/.local/bin:/home/francois/.dotfiles/bin:.
export HISTTIMEFORMAT='%d/%m/%y %H:%M '
export MULVALROOT=/home/francois/cybercaptor/mulval
export PATH=$DEFAULTPATH:$MULVALROOT/XSB/bin:$MULVALROOT/bin:$MULVALROOT/utils

export PDF_READER='apvlv'
export trash=~/.local/share/Trash/files

# colors for less and man
# md = start bold mode
# me = end all mode like so, us, mb, md and mr
# so = start standout mode
# se = end standout mode
# us = start underlining
# ue = stop underlining
# mr = start reverse mode
# mh = start bright mode
# setaf <number>: number % 8 = 0:black; 1:red; 2:green; 3:yellow; 4:blue; 5:magenta; 6:cyan; 7:yellow;
export LESS_TERMCAP_mb=$(tput bold; tput setaf 2)
export LESS_TERMCAP_md=$(tput bold; tput setaf 3)
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4)
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
export LESS_TERMCAP_us=$(tput smul; tput setaf 6)
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
export LESS_TERMCAP_mr=$(tput rev)
export LESS_TERMCAP_mh=$(tput dim)
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

# define custom colors for ls
[ -f ~/.dircolors ] && \
	eval `dircolors ~/.dircolors`

. ~/.bash_aliases
