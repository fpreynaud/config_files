#!/bin/bash
alias nohup='nohup >/dev/null 2>/dev/null'

for i in `ls /sbin`
do
	alias $i="sudo $i"
done

alias ac='apt-cache'
alias as='apt-cache search'
alias ag='sudo apt-get'

alias cdd='cd $OLDPWD'
alias cim='vim'
alias clntex='/bin/rm *.out *.aux *.log'
alias cq='cd ..'

alias du='du -h'

alias ebrc='vim ~/.zshrc'
alias eba='vim  ~/.bash_aliases'
alias evince='nohup evince'

alias ftpedago='sftp -i ~/.ssh/pedago francois.reynaud@pedago-etu.ensiie.fr'

alias graph_gen.sh='graph_gen.sh --nometric -v'
alias grep='grep --color=auto -n'

alias ippublique='wget -qO- icanhazip.com'
alias irc='ssh reynaud2012@perso.iiens.net'

alias jobs='jobs -l'

alias la='ls -A'
alias lx='ls -X'

alias mount='sudo mount'

alias pdf='evince'
alias pedago='ssh -i ~/.ssh/pedago francois.reynaud@pedago-etu.ensiie.fr'
alias popd='popd >/dev/null 2>/dev/null'

alias rm='~/bin/rm'
alias rmdir='rmdir --ignore-fail-on-non-empty'

alias sba='. ~/.bash_aliases'
alias sbrc='. ~/.zshrc'
#alias sf='echo montage des dossiers partagés; sudo mount -t vboxsf mes_documents ~/documents; sudo mount -t vboxsf mes_images ~/images && echo montage réussi'
alias sf='echo montage des dossiers partagés; ln -s /media/sf_mes_documents ~/documents && echo montage réussi'

alias vim='vim -n -c :loadview'
