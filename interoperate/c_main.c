#include <stdio.h>

int function(int (*pFunction)(const char *), const char *pMessage);
int subroutine(int (*pFunction)(const char *), const char *pMessage);
int inline_asm(int (*pFunction)(const char *), const char *pMessage);

int main(int argc, char **argv)
{
	const char *message = "[C Caller]";
	if (EOF != function(puts, message) && EOF != subroutine(puts, message) && EOF != inline_asm(puts, message))
	{
		return 0;
	}
	return 1;
}

