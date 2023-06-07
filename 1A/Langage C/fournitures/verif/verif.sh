#!/bin/sh
# PM, le 31/3/21
# PM, le 30/3/22 : ajout option -s
# PM, le 2/4/22 : compléments aux tests

export PATH=.:$PATH
rep=`pwd`
res=OK

gcc -Wall miniminishell.c -o ms 2> msg

if [ \( "a$1" = 'a-s' \) ] ; then
	echo "préparation de l'archive à soumettre"
	rep=`whoami|cut -d' ' -f 1`-tpProcessus
	mkdir "$rep" 2> /dev/null
	if [ ! \( -f miniminishell.c \) ] ; then 
		echo "abandon : fichier source miniminishell.c non trouvé"
		exit 1
	else
		x=`wc -l msg | sed -e 's/^[[:space:]]*//'| cut -d' ' -f 1`
		if [ $x -ne 0 ] ; then 
			echo "abandon : echec de la compilation du fichier source sans warnings"
			exit 2
		else
			cp miniminishell.c "$rep"
		fi
	fi
	
	cp a/kro.o "$rep"
	tar -cf "$rep".tar "$rep"
	rm -r "$rep"
	echo "prêt : vous pouvez déposer l'archive $rep.tar sous Moodle"
	exit 0
fi

ms < a/bar > foo

if [ ! \( -f foo \) ] ; then 
res=KO
fi

grep -v '>>>' foo | grep -v 'Salut'| grep -v 'SUCCES'| grep -v 'ECHEC'| sort > a/b/core
sort lala.o > a/s
diff a/b/core  a/s
if [ $? -ne 0 ] ; then 
res=KO
fi

if [ \( `grep '^>>>' foo | wc -l` -lt 3 \) -o  \( `grep 'SUCCES' foo | wc -l` -lt 2 \) -o \
\( `grep 'ECHEC' foo | wc -l` -lt 1 \) ] ; then
res=KO
fi

if [ `grep '^Salut' foo | wc -l` -ne 1 ] ; then
res=KOOK
fi

echo $res
