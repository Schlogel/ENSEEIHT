# Ce Makefile est là pour vous aider 
# Vous pouvez le modifier, ajouter des règles, en enlever ...
# Vous pouvez ne pas vous en servir, mais ce serait un tort

# Compilateur a utilliser
CC=gcc 

# Fichier à contruire
EXE=minishell

# Quelles options pour le compilateur ? 
CFLAGS=-Wall -Wextra -std=c99

# Options pour l'édition de liens
LDFLAGS=

# Nom du fichier de test
TEST_FILE=test_readcmd

# Les fichiers .o nécessaires pour contruire le fichier EXE :
# Ils sont obtenus à partir de tous les fichiers .c du répertoire auquel on enlève le programme de test
OBJECTS = $(patsubst %c,%o,$(filter-out test_readcmd.c, $(wildcard *.c)))

all: $(EXE)

test: $(TEST_FILE)

$(EXE): $(OBJECTS)

$(TEST_FILE): test_readcmd.o readcmd.o

clean:
	\rm -f *.o *~
	\rm -f $(EXE)
	\rm -f $(TEST_FILE)

archive: clean
	(cd .. ; tar cvf minishell-`whoami`.tar minishell)

help:
	@echo "Makefile for minishell."
	@echo "Targets:"
	@echo " all             Build the minishell"
	@echo " archive	 Archive the minishell"
	@echo " clean           Clean artifacts"