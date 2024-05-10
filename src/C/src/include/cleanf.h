#ifndef CLEANF_H
#define CLEANF_H

#include "./parserf.h"
#include "./astf.h"

void clean(parser_t *parser, node_t *root) {
    parser_remove(parser);
    remove_tree(root);
}


#endif