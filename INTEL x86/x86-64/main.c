#include <stdio.h> 
#include <string.h>
#include <stdlib.h>

char *formatdec(char *s, const char *format, long num);

int main(int argc, char *argv[])
{
	if (argc != 3)
	{
		printf("Wrong number of arguments");
		return -1;
	}
	
	char* buffer = malloc(1000 * sizeof(char));
	printf("%s", formatdec(buffer, argv[1],  atoi(argv[2])));
	free(buffer);
	return 0;
}

