Avertissement
-------------
Le script de vérification `verif.sh` doit être considéré comme un simple outil mis à votre
disposition, pour vous fournir une indication quant à la viabilité de vos réponses, et non 
comme une application de validation automatique de votre travail. Simplement, si vous passez
la vérification, vous pouvez avoir bon espoir quant à l'évaluation effective. Et inversement.

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

Pour que le script de vérification `verif.sh` puisse être appliqué :

  - le fichier source du programme à vérifier doit être **exactement** nommé `miniminishell.c`
  - le répertoire contenant `verif.sh` ne devra pas être modifié, en dehors de l'ajout du
    fichier source.
  

Appel et résultats du script de vérification
--------------------------------------------

Le script `verif.sh` doit être lancé depuis un terminal, le répertoire courant étant le
répertoire contenant `verif.sh`.

* Lorsqu'il est lancé sans  option, le script effectue une première vérification de 
la bonne exécution du binaire compilé à partir du fichier source`miniminishell.c`. 
Si la vérification échoue le script affiche `KO` ou `KOOK`, sinon il affiche `OK`. 
Le message `KOOK` doit être compris comme indiquant une forte présomption d'erreur, mais
pas comme une certitude d'erreur. Vous pouvez consulter le script pour voir le test qui
a levé ce (gros) soupçon...
Notez que la mention `OK` est une condition nécessaire pour que la réponse soit juste,
mais que ce n'est pas une condition suffisante.  
Lorsque le script `verif.sh` se termine, il affiche un message `OK`, `KO` ou `KOOK`.  
 Il est possible que la réponse fournie provoque le blocage du script. Dans ce cas, il faut
  tuer le processus exécutant le script.
  
  * Lorsqu'il est lancé avec l'option `-s` (pour soumettre), le script prépare l'archive qui
pourra être déposée sur Moodle. L'archive créée par l'appel de `verif.sh -s` se 
trouve au même niveau que `verif.sh`. Si la préparation échoue, un message indiquant 
la cause est affiché, et aucune archive n'est créée
