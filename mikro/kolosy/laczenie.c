#include <stdio.h>
#include <stdlib.h>


char * fun(char * buf, char * a, char * b);


int main(){
	
	char * buf;
	buf = malloc(sizeof(char)*20);
	char buf1[20];
	char buf2[20];
	printf("Argumenty: \"%s\", \"%s\": \"%s\"\n","123","abcdefg", fun(buf,"123","abcdefg"));

printf("Argumenty: \"%s\", \"%s\": \"%s\"\n","123","a", fun(buf1,"123","a"));

printf("Argumenty: \"%s\", \"%s\": \"%s\"\n","123","abc", fun(buf2,"123","abc"));


return 0;
}
