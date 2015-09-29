@ Working with C structures and GAS
@ http://blackfin.uclinux.org/doku.php?id=toolchain:gas:structs

.set offsetof_node_t_value,  0 // offsetof(node_t->value)
.set offsetof_node_t_left,   4 // offsetof(node_t->left)
.set offsetof_node_t_right,  8 // offsetof(node_t->right)
.set sizeof_node_t_value,    4 // sizeof(node_t->value)
.set sizeof_node_t_left,     4 // sizeof(node_t->left)
.set sizeof_node_t_right,    4 // sizeof(node_t->right)
.set sizeof_node_t,         12 // sizeof(node_t)

