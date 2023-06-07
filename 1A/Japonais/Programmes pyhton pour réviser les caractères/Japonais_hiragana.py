# -*- coding: utf-8 -*-
"""
Created on Wed Nov 23 19:53:07 2022

@author: Test
"""

import random

from hiragana import Hiragana

Tableau_1 = ['a','i','u','e','o',
             'ka','ki','ku','ke','ko',
             'ta','chi','tsu','te','to',
             'sa','shi','su','se','so',
             'na','ni','nu','ne','no',
             'ha','hi','fu','he','ho',
             'ma','mi','mu','me','mo',
             'ya','yu','yo',
             'ra','ri','ru','re','ro',
             'wa','wo',
             'n']

Tableau_2 = ['ga','gi','gu','ge','go',
             'da','dji','dzu','de','do',
             'za','ji','zu','ze','zo',
             'ba','bi','bu','be','bo',
             'pa','pi','pu','pe','po',]

Tableau_3 = ['kya','kyu','kyo',
             'sha','shu','sho',
             'cha','chu','cho',
             'nya','nyu','nyo',
             'hya','hyu','hyo',
             'mya','myu','myo',
             'rya','ryu','ryo',
             'gya','gyu','gyo',
             'ja','ju','jo',
             'bya','byu','byo',
             'pya','pyu','pyo']

Texte_aléatoire = ['T\'es con ou quoi ?','Nan t\'abuse',
                   'T\'es sérieux là ?','T\'as pas révisé en fait',
                   'Fumier','Essaie encore connard','Qui aura 0/20 au DS ???',
                   'T\'es mal barré là','なに ?!','Non mais là...',
                   'Vas réviser stp','Quoi? Ta soeur?','Sale Merde',
                   'Sous merde','']

def Test_connaissance ():
    Tableau=input('Quel tableau à réviser ? (1/2/3/tout) ')
    Nombre=input('Combien de hiragana à réviser ? ')
    Nb_bonnes_rep = 0
    if Tableau == '1':
        Syllabes = Tableau_1
    elif Tableau == '2':
        Syllabes = Tableau_2
    elif Tableau == '3':
        Syllabes = Tableau_3
    else:
        Syllabes = Tableau_1 + Tableau_2 + Tableau_3
    for Essai in range(int(Nombre)):        
        syllabe = Syllabes[random.randint(0,len(Syllabes)-1)]         
        Hira = Hiragana().hiragana[syllabe]
        Réponse=input("{}. {} = ".format(Essai+1,Hira))
        if Réponse != syllabe:
            print(Texte_aléatoire[random.randint(0,len(Texte_aléatoire)-1)])
            print("{} c'est \"{}\"".format(Hira,syllabe))
            while Réponse != syllabe:
                Réponse=input("Réessaie : {} = ".format(Hira))
        else:
            print("Ok")
            Nb_bonnes_rep += 1
    if Nb_bonnes_rep == int(Nombre):
        print("\nCa va, tu connais")
    else:
        print("\nRévise tes morts, {} mauvaises réponses sur {}".format(int(Nombre)-Nb_bonnes_rep, int(Nombre)))

Test_connaissance()