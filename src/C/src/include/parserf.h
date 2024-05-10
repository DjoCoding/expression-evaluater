#ifndef PARSERF_H
#define PARSERF_H

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#include "./tokenizerf.h"
#include "./astf.h"

typedef struct parser {
    token_t tokens;
    token_t current;    
} parser;

typedef parser *parser_t;

node_t parse_addition(parser_t parser);

parser_t parser_init(token_t tokens) {
    parser_t result = (parser_t) malloc(sizeof(parser));
    result->tokens = tokens;
    result->current = tokens;
    return result;
}

token_t parser_peek(parser_t parser) {
    return parser->current;
}

token_t parser_consume(parser_t parser) {
    token_t current = parser->current;
    parser->current = current->next;
    return current;
}

bool parser_end(parser_t parser) {
    return (parser->current == NULL);
}

void parser_remove(parser_t *parser) {
    tokens_remove(&((*parser)->tokens));
    free(*parser);
    *parser = NULL;
}

bool at_addition(parser_t parser) {
    if (parser_end(parser)) return false;
    return (parser_peek(parser)->type == TT_OPERATOR) 
                        && 
    ((parser_peek(parser)->value.operator == '+') || (parser_peek(parser)->value.operator == '-'));
}

bool at_multiplication(parser_t parser) {
    if (parser_end(parser)) return false;
    return (parser_peek(parser)->type == TT_OPERATOR) 
                        && 
    ((parser_peek(parser)->value.operator == '*') || (parser_peek(parser)->value.operator == '/') || (parser_peek(parser)->value.operator == '%'));
}

bool is_left_par(parser_t parser) {
    if (parser_end(parser)) return false;
    return (parser_peek(parser)->type == TT_PAR) 
                    &&
    (parser_peek(parser)->value.par == LEFT_PAR);
}

bool is_right_par(parser_t parser) {
    if (parser_end(parser)) return false;
    return (parser_peek(parser)->type == TT_PAR) 
                    && 
    (parser_peek(parser)->value.par == RIGHT_PAR);
}

bool is_operator(parser_t parser) {
    if (parser_end(parser)) return false;
    return (parser_peek(parser)->type == TT_OPERATOR);
}

node_t parse_paren(parser_t parser) {

    if (parser_end(parser)) {
        printf("ERROR: EXPECTED MORE TOKENS\n");
        return NULL;
    }

    if(!is_left_par(parser)) {
        node_t node = node_init(parser_consume(parser));

        if (node->type.type == TT_FUNCTION) {

            if (!is_left_par(parser)) {
                printf("ERROR: UNEXPECTED TOKEN, EXPECTED '(' BUT TOKEN OF TYPE: %s FOUND\n", TOKEN_TYPES[parser_peek(parser)->type]);
                remove_tree(&node);
                return NULL;
            }

            // consuming the token (
            parser_consume(parser);

            // parsing the rest of args!
            node_t func_input = parse_addition(parser); 
            if (!func_input) {
                remove_tree(&node);
                return NULL;
            }

            node->left= func_input;
            node->right = NULL;

            parser_consume(parser);
        } 

        return node;
    }

    parser_consume(parser);

    node_t left = parse_paren(parser);

    if (!left) return NULL;

    while (!is_right_par(parser)) {

        if (!is_operator(parser)) {
            printf("ERROR: EXPECTED TOKEN OF TYPE OPERATION BUT FOUND TOKEN OF TYPE: %s\n", TOKEN_TYPES[parser_peek(parser)->type]);
            remove_tree(&left);
            return NULL;
        }

        node_t root = node_init(parser_consume(parser));

        if (parser_end(parser)) {
            printf("ERROR: EXPECTED MORE TOKENS BUT END OF TOKENS FOUND!\n");
            remove_tree(&left);
            remove_tree(&root);
            return NULL;
        }

        node_t right = parse_addition(parser);

        if (!right) {
            remove_tree(&left);
            remove_tree(&root);
            return NULL;
        }

        root->left = left;
        root->right = right;

        left = root;
    }

    // consuming the ) token
    if (!parser_end(parser)) parser_consume(parser);

    return left;
}

node_t parse_multiplication(parser_t parser) {
    node_t left = parse_paren(parser);

    while (at_multiplication(parser)) {
        node_t root = node_init(parser_consume(parser));

        if (parser_end(parser)) {
            printf("EXPECTED MORE TOKENS!\n");
            remove_tree(&left);
            remove_tree(&root);
            return NULL;
        }

        node_t right = parse_multiplication(parser);

        if (!right) {
            remove_tree(&left);
            remove_tree(&root);
            return NULL;
        }

        root->left = left;
        root->right = right;

        left = root;
    }     

    return left;
}

node_t parse_addition(parser_t parser) {

    node_t left = parse_multiplication(parser);

    // print_tree(left);

    if (!left) return NULL;

    while (at_addition(parser)) {
        node_t root = node_init(parser_consume(parser));

        // print_tree(root);

        node_t right = parse_addition(parser);

        // print_tree(right);

        if (right) {
            root->left = left;
            root->right = right;
            left = root;

            // print_tree(left);
        } else {
            remove_tree(&root);
            remove_tree(&left);
            return NULL;
        }
    }

    return left;
}


node_t parse(parser_t parser) {
    return parse_addition(parser);
}


#endif