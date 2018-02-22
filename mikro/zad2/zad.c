#include <stdlib.h>
#include <stdio.h>

#define BUFSIZE 100

char* generate_str(char* s, int c, int n, int inc);

int main(){
	char* buf = malloc(BUFSIZE*sizeof(char));
	
	printf("%s \n", generate_str(buf, 65, 15, 0));
	
	free(buf);

	return 0;
}
