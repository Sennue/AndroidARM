#include <stdio.h>
#include "tree.h"

int main(int argc, char **argv)
{
	node_t *root;
	char *argvn;

	// print program name
	argvn = *(argv++); // program name
	printf("[C Caller] %s\n", argvn);

	// build root
	argvn = *(argv++); // root arg
	if (NULL != argvn) {
		root = alloc_node(argvn); // root node
		argvn = *(argv++); // first loop arg
	}

	// build tree
	while (NULL != argvn) {
		find_node(root, insert_value, argvn);
		argvn = *(argv++); // next loop arg
	}

	// print and free tree
	walk_tree(root, print_tree);
	walk_tree(root, free_tree);

	// done
	return 0;
}

