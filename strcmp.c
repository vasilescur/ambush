#include <string.h>

/*
 * Compare strings.
 */
int strcmp(s1, s2) register const char *s1, *s2;
{
	while (*s1 == *s2++) 
    {
		if (*s1++ == 0) 
        {
			return (0);
        }
    }

	return (*(const unsigned char *)s1 - *(const unsigned char *)(s2 - 1));
}

https://godbolt.org/z/EuM6k8