#ifndef TREE_H
#define TREE_H

typedef struct node_t {
	const char *	value;
	struct node_t *	left;
	struct node_t *	right;
} node_t;

node_t *alloc_node(const char *pValue);
node_t *walk_tree(node_t *pNode, node_t *(*pProc)(node_t *pNode));
node_t *find_node(node_t *pNode, node_t *(*pProc)(node_t *pNode, const char *pValue), const char *pValue);
node_t *insert_value(node_t *pNode, const char *pValue);
node_t *free_tree(node_t *pNode);
node_t *print_tree(node_t *pNode);

#endif // TREE_H

