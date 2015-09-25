#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tree.h"

node_t *alloc_node(const char *pValue) {
	node_t *result = malloc(sizeof(node_t));
	result->value = pValue;
	result->left = NULL;
	result->right = NULL;
	return result;
}

// returns a pointer to a node to abort walking the tree
// returns NULL to continue walking the tree
// return value is driven proc
node_t *walk_tree(node_t *pNode, node_t *(*pProc)(node_t *pNode))
{
	node_t* left = NULL;
	node_t* right = NULL;
	node_t* result = NULL;

	// pProc may be destructive
	// cache left and right
	if (NULL != pNode) {
		left = pNode->left;
		right = pNode->right;
	}

	// walk left if possible and not done
	if (NULL != left && NULL == result) {
		result = walk_tree(left, pProc);
	}

	// proc current node if possible and not done
	if (NULL != pProc && NULL == result) {
		result = pProc(pNode);
	}

	// walk right if possible and not done
	if (NULL != right && NULL == result) {
		result = walk_tree(right, pProc);
	}

	return result;
}

node_t *find_node(node_t *pNode, node_t *(*pProc)(node_t *pNode, const char *pValue), const char *pValue)
{
	// proc null root
	if (NULL == pNode) {
		return pProc(pNode, pValue);
	}

	int compare = strcmp(pValue, pNode->value);

	// proc this node
	if (0 == compare) {
		return pProc(pNode, pValue);
	}

	// if less than current value, left
	else if (compare < 0) {
		// if null the value would go here, proc and set
		if (NULL == pNode->left) {
			return pNode->left = pProc(pNode->left, pValue);
		// otherwise keep searching
		} else {
			return find_node(pNode->left, pProc, pValue);
		}
	}

	// if greater than current value, right
	else if (0 < compare) {
		// if null the value would go here, proc and set
		if (NULL == pNode->right) {
			return pNode->right = pProc(pNode->right, pValue);
		// otherwise keep searching
		} else {
			return find_node(pNode->right, pProc, pValue);
		}
	}

	// not a match
	return NULL;
}

node_t *insert_value(node_t *pNode, const char *pValue)
{
	// create new node
	if (NULL == pNode) {
		return alloc_node(pValue);
	}

	// node exists
	return pNode;
}

node_t *free_tree(node_t *pNode)
{
	// free node
	if (NULL != pNode) {
		free(pNode);
	}

	// keep walking tree
	return NULL;
}

node_t *print_tree(node_t *pNode)
{
	// print value
	if (NULL != pNode) {
		puts(pNode->value);
	}

	// keep walking tree
	return NULL;
}

