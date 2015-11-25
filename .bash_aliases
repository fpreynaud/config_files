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
alias ftpedago='sftp -i ~/.ssh/pedago francois.reynaud@pedago-etu.ensiie.fr'

alias grep='grep --color=auto -n'

alias ippublique='wget -qO- icanhazip.com'
alias irc='ssh reynaud2012@perso.iiens.net'

alias jobs='jobs -l'

alias lx='ls -X'

#pour tout fichier .pdf dans le dossier, créer un sous-dossier du même nom, y
#placer le pdf, y créer un dossier fiche, et placer le template de fiche dans ce
#dernier
alias makecoffee='
OLDIFS=$IFS;
for i in `ls *.pdf`;
do
	IFS=;
	repname=`echo $i | cut -f1 -d"."`;
	mkdir -p $repname/fiche;
	mv $i $repname;
	cp ~/.bookmarks/stage/template_fiche/template_fiche.tex $repname/fiche/fiche_${repname}.tex;
	IFS=$OLDIFS;
done'

alias pedago='ssh -i ~/.ssh/pedago francois.reynaud@pedago-etu.ensiie.fr'
alias popd='popd >/dev/null 2>/dev/null'
alias preludestart='sudo service prelude-manager start; sudo service prelude-lml start; sudo service prelude-correlator start; sudo prewikka-httpd &'
alias preludestop='sudo service prelude-manager stop; sudo service prelude-lml stop; sudo service prelude-correlator stop; sudo pkill prewikka'
alias pwof='sudo shutdown -P now'
alias pyth='python3.4'

alias rm='~/bin/dump 2>/dev/null'
alias rmdir='rmdir --ignore-fail-on-non-empty'

#alias sf='echo montage des dossiers partagés; sudo mount -t vboxsf mes_documents ~/documents; sudo mount -t vboxsf mes_images ~/images && echo montage réussi'
alias sf='echo montage des dossiers partagés; ln -s /media/sf_mes_documents ~/documents && echo montage réussi'

alias terminator='nohup terminator --working-directory=. 2>/dev/null >/dev/null &'

alias vim='vim -n -c :loadview'
