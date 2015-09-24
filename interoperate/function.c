#include <stdio.h>

int function(int (*pFunction)(const char *), const char *pMessage)
{
	if (EOF != puts("[C Function]"))
	{
		return pFunction(pMessage);
	}
	return EOF;
}

