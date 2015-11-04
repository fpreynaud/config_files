#!/bin/bash
alias banshee='ssh fpr163@banshee.cs.uow.edu.au'

alias cdd='cd $OLDPWD'
alias cim='vim'
alias clntex='/bin/rm *.out *.aux *.log'
alias cq='cd ..'

alias del='/bin/rm'

alias evince='nohup evince'

alias firefox='nohup firefox & > /dev/null 2> /dev/null'
alias ftpbanshee='sftp fpr163@banshee.cs.uow.edu.au'
alias ftpedago='sftp -i ~/.ssh/pedago francois.reynaud@pedago.ensiie.fr'

alias grep='grep --color=auto -n'

alias ippublique='wget -qO- icanhazip.com'
alias irc='ssh reynaud2012@perso.iiens.net'

alias jobs='jobs -l'

alias lx='ls -X'

alias pedago='ssh -i ~/.ssh/pedago francois.reynaud@pedago.ensiie.fr'
alias preludestart='sudo service prelude-manager start; sudo service prelude-lml start; sudo service prelude-correlator start; sudo prewikka-httpd &'
alias preludestop='sudo service prelude-manager stop; sudo service prelude-lml stop; sudo service prelude-correlator stop; sudo pkill prewikka'
alias pwof='sudo shutdown -P now'
alias pyth='python3.4'

alias rm='~/bin/dump 2>/dev/null'
alias rmdir='rmdir --ignore-fail-on-non-empty'

alias sf='echo montage des dossiers partagés; sudo mount -t vboxsf mes_documents ~/documents; sudo mount -t vboxsf mes_images ~/images && echo montage réussi'

alias vim='vim -n -c :loadview'
