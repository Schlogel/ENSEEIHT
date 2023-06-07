# Définition des Variables

CC = c99
CFLAGS = -Wextra -pedantic -c
LDFLAGS = 
EXE = -o


# Règles

all: test_file exemple_file 

test_file: file.o test_file.o
	$(CC) $(LDFLAGS) $^ $(EXE) $@
    
exemple_file: file.o exemple_file.o
	$(CC) $(LDFLAGS) $^ $(EXE) $@
	
file.o: file.c
	$(CC) $(CFLAGS) $<
	
exemple_file.o: exemple_file.c
	$(CC) $(CFLAGS) $<
	
test_file.o: test_file.c
	$(CC) $(CFLAGS) $<
    
depend: 
	makedepend *.c -Y

clean:
	rm *.o exemple_file test_file

.PHONY: clean all makedepend

