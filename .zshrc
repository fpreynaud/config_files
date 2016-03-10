export PATH=$PATH:~/.local/bin
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
underline=4
nounderline=24
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
	target="\033[${cyan};${underline}mtarget\033[${defaultDispAtt}m"
	bookmark_name="\033[${cyan};${underline}mbookmark_name\033[${defaultDispAtt}m"
	bookmark_folder="$HOME/.bookmarks"

	option_value=
	for option
	do
		if [ -n "$option_value" ]; then
			eval "$option_value=\$option"
			option_value=
			continue
		fi

		case "$option" in
			-t|--target)option_value="target_bookmark";;
			-l|--list)
				ls $bookmark_folder;
				return;;
			-v|--long-listing)
				ls -l $bookmark_folder;
				return;;
			-h|--help)
				echo -e "\033[${bold}mSynopsis:\033[${defaultDispAtt}m bookmark [options] [$bookmark_name] [$target]";
				echo -e "\033[${bold}mDescription:\033[${defaultDispAtt}m";
				echo -e \
"    Creates a symbolic link to $target named $bookmark_name in $bookmark_folder. If no argument is supplied, it is equivalent to bookmark -l.
    If only $bookmark_name is supplied, $target defaults to the current directory.";
				echo -e "\033[${bold}m
Options
    -l\033[${defaultDispAtt}m   Display list of bookmarks
    \033[${bold}m-v\033[${defaultDispAtt}m   Display list of bookmarks in long-listing format
    \033[${bold}m-h\033[${defaultDispAtt}m   Display this help";
				return;;
		esac
	done

	if [ -n "$target_bookmark" ]; then
		eval "readlink -f $bookmark_folder/$target_bookmark"
	else
		case "$#" in
			"0") ls $bookmark_folder;;
			"1") ln -f -s $PWD $bookmark_folder/$1;;
			"2") ln -f -s `readlink -f $2` $bookmark_folder/$1;;
		esac
	fi

}

function hide
{
	for file in $*; do
		name=`/usr/bin/basename $file`
		path=`echo $file|/bin/sed s/"$name"//`
		if [ -z "$path" ]; then
			path="./"
		fi
		/bin/mv $file $path.$name
	done
}

unhide ()
{
	for file in $*; do
		name=`/usr/bin/basename $file`
		path=`echo $file|/bin/sed s/"$name"//`
		if [ -e $file ]; then
			revealed_name=`echo $name | /bin/sed s/^\.\(.\+\)/\1/`
			/bin/mv $path$name $path$revealed_name
		else
			dot_name=.$name

			if [ -z "$path" ]; then
				path="./"
			fi

			if [ -e $path$dot_name ]; then
				/bin/mv $path$dot_name $path$name
			else
				echo "Error: $path$dot_name does not exist"
				return 1
			fi

		fi
	done
}

# define custom colors for ls
[ -f ~/.dircolors ] && \
	eval `dircolors ~/.dircolors`

. ~/.bash_aliases
