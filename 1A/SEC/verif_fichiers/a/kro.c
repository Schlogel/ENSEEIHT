#include <signal.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/types.h> 	//open
#include <sys/stat.h> 	//open
#include <fcntl.h>			//open

int main () {
    int i,fd,j=0;
    fd = open("temp", O_RDONLY, NULL);
    while (read(fd,&i,sizeof(i))> 0) j+=i;
    printf("%d\n",j);
    return 0;
}