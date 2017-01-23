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

alias cdd='popd'
alias cim='vim'
alias clntex='/bin/rm *.out *.aux *.log'
alias cq='cd ..'

alias du='du -h'

alias ebrc='vim ~/.bashrc'
alias eba='vim  ~/.bash_aliases'
alias evince='nohup evince'

alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias ftpedago='sftp -i ~/.ssh/pedago francois.reynaud@pedago-etu.ensiie.fr'

alias graph_gen.sh='graph_gen.sh --nometric -v'
alias grep='grep --color=auto -n'
alias  grep='grep'

alias ippublique='wget -qO- icanhazip.com'
alias irc='ssh reynaud2012@perso.iiens.net'

alias jobs='jobs -l'

alias l='ls -CF'
alias la='ls -A'
alias lad='la -Ad'
alias ll='ls -alF'
alias ls='ls --color=auto --group-directories-first'
alias lx='ls -X'

alias mount='sudo mount'

alias pdf='evince'
alias pedago='ssh -i ~/.ssh/pedago francois.reynaud@pedago-etu.ensiie.fr'
alias popd='popd >/dev/null 2>/dev/null'

alias rmdir='rmdir --ignore-fail-on-non-empty'

alias sba='. ~/.bash_aliases'
alias sbrc='. ~/.bashrc'
#alias sf='echo montage des dossiers partagés; sudo mount -t vboxsf mes_documents ~/documents; sudo mount -t vboxsf mes_images ~/images && echo montage réussi'
alias sf='echo montage des dossiers partagés; ln -s /media/sf_mes_documents ~/documents && echo montage réussi'

alias vim='vim -n -c :loadview'
