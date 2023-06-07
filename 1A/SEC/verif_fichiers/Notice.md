Avertissement
-------------
Le script de vérification `verif_fichiers.sh` doit être considéré comme un simple outil mis
 à votre disposition, pour vous fournir une indication quant à la viabilité de vos réponses,
  et non  comme une application de validation automatique de votre travail. Simplement, 
  si vous passez la vérification, vous pouvez avoir bon espoir quant à l'évaluation 
  effective. Et inversement.

En particulier :

  - il est inutile de modifier le script pour qu'il donne une réponse `OK` : la validation
  se fera sur nos propres outils.
  - le script n'est pas protégé contre les erreurs résultant de (mauvaises) actions liées
  à l'exécution de vos programmes. Par exemple si votre programme détruit des fichiers
  de manière intempestive, le script de vérification peut devenir invalide.
  Il est donc prudent de prévoir une sauvegarde de l'original, si vous voulez être prémunis
   contre ce genre d'accidents.
  - en revanche, le script de vérification fonctionne bien avec des réponses correctes.
    Par conséquent, si une erreur est signalée sur une ligne du script, vous pouvez être
    quasi-certains que cela ne découle pas d'une erreur dans le script de test.

Conventions de nommage
----------------------

Pour que le script de vérification `verif_fichiers.sh` puisse être appliqué :

  - les fichier source des programmes à vérifier doivent être **exactement** nommés `copier.c`
    et `scruter.c`,  et ils doivent être rangés dans le répertoire `etu`, situé au 
    même niveau que `verif_fichiers.sh`
  - le répertoire contenant `verif_fichiers.sh` ne devra pas être modifié, en dehors de 
    l'ajout des fichiers sources `copier.c` et `scruter.c`.
  

Appel et résultats du script de vérification
--------------------------------------------

Le script `verif_fichiers.sh` doit être lancé depuis un terminal, le répertoire courant 
étant le répertoire contenant `verif_fichiers.sh`.

* Lorsqu'il est lancé sans option, `verif_fichiers.sh` effectue un diagnostic sur les 
programmes `copier.c` puis `scruter.c`.  
Si la vérification échoue pour l'un des programmes, le script affiche `KO`, sinon il affiche `OK`. 
Notez que la mention `OK` est une condition nécessaire pour que la réponse soit juste,
mais que ce n'est pas une condition suffisante.    
En particulier, vous êtes laissés juges de leur pertinence, mais a priori la vérification
ne devrait afficher aucun warning suite à la compilation.   
Lorsque le script `verif_fichiers.sh` se termine, il affiche un message `OK` ou `KO`.   
 Il est possible que la réponse fournie provoque le blocage du script. Dans ce cas, il faut
  tuer le processus exécutant le script.  
Pour le programme `scruter.c` il se peut que la vérification affiche `??`. Cela signifie
que la vérification n'a pas pu se faire, mais pas forcément que le programme est erroné.
(Ce n'est cependant pas un très bon signe.)
* Lorsqu'il est lancé avec l'option `-s` (pour soumettre), le script prépare l'archive qui
pourra être déposée sur Moodle. L'archive créée par l'appel de `verif_fichiers.sh -s` se 
trouve au même niveau que `verif_fichiers.sh`  
Notez qu'il n'est pas nécessaire d'avoir obtenu des `OK` pour soumettre votre travail. Mais c'est
clairement préférable.