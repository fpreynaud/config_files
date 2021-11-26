#!/bin/bash
alias nohup='nohup >/dev/null 2>/dev/null'
alias ls='ls --group-directories-first --color=always'
alias ù='%'

for i in `\ls /sbin`
do
	alias $i="sudo $i"
done

alias ac='apt-cache'
alias as='apt-cache search'
alias ag='sudo apt-get'

alias cd='cs'
alias cdd='popd'
alias cim='vim'
alias clntex='/bin/rm *.out *.aux *.log'
alias cq='cd ..'

alias dirbuster='nohup dirbuster >/dev/null 2>&1 &'
alias du='du -h'

alias ebrc='vim ~/.bashrc'
alias eba='vim  ~/.bash_aliases'
alias evince='nohup evince'

alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias firefox='nohup firefox >/dev/null 2>&1 &'

alias graph_gen.sh='graph_gen.sh --nometric -v'
alias grep='grep --color=auto -n'

alias ippublique='wget -qO- icanhazip.com'
alias irc='ssh reynaud2012@perso.iiens.net'

alias jobs='jobs -l'

alias l='ls -CF'
alias la='ls -A'
alias lad='la -Ad'
alias ll='ls -AlF'
alias ls='ls --color=auto --group-directories-first'
alias lx='ls -X'

alias metasploit='msfconsole'
alias mount='sudo mount'

alias pdf='evince'
alias popd='popd >/dev/null 2>/dev/null'

alias rmdir='rmdir --ignore-fail-on-non-empty'

alias sba='. ~/.bash_aliases'
alias sbrc='. ~/.bashrc'
alias script='script -T typescript_timing_$(date +"%d%m%Y") typescript_$(date +"%d%m%Y")'
#alias sf='echo montage des dossiers partagés; sudo mount -t vboxsf mes_documents ~/documents; sudo mount -t vboxsf mes_images ~/images && echo montage réussi'
alias sf='echo montage des dossiers partagés; ln -s /media/sf_mes_documents ~/documents && echo montage réussi'

alias vim='vim -n -c :loadview'
