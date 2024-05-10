#ifndef ASTF_H
#define ASTF_H

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <math.h>

#include "./tokenizerf.h"


/* 
    THE TOKEN DATA STRUCT IS ALREADY IN THE "tokenizerf.h"
    I'LL RE-USE IT HERE TO SET UP MY NODES!
*/

typedef enum {
    PLUS, 
    MINUS, 
    MULT, 
    DIV,
    MOD,
} OPERATOR_T;

typedef enum {
    GOOD_RESULT, 
    ERROR,
} EVALUATION_RESULT_TYPE;

typedef struct {
    EVALUATION_RESULT_TYPE type;
    double result;
} EVALUATION_RESULT;

typedef struct {
    TOKEN_DATA value;
} NODE_DATA;

typedef struct {
    TOKEN_TYPE type;
} NODE_TYPE;

typedef struct Node *node_t;

typedef struct Node {
    NODE_DATA data;
    NODE_TYPE type;
    node_t left, right;
} Node;

node_t node_create(NODE_DATA data, NODE_TYPE type) {
    node_t result = (node_t) malloc(sizeof(Node));
    result->data = data;
    result->type = type;
    result->left = NULL;
    result->right = NULL;
    return result;
}

NODE_DATA data_init(token_t token) {    
    NODE_DATA result =  { .value = token->value };
    return result;
}

NODE_TYPE type_init(token_t token) {
    NODE_TYPE result = { .type = token->type };
    return result;
}

node_t node_init(token_t token) {
    return node_create(data_init(token), type_init(token));
}


void print_node(node_t node) {
    switch(node->type.type) {
        case TT_NUMBER: 
            printf("%f", node->data.value.number);
            break;
        case TT_OPERATOR: 
            printf("%c", node->data.value.operator);
            break;
        case TT_FUNCTION: 
            printf("%s", FUNCTION_NAMES[node->data.value.func_name]);
            break;
        case TT_PAR: 
            printf("%s", PAR_TYPES[node->data.value.par]);
            break;
        case TT_COUNT: 
            break;
    }
}

void printBinaryTree(node_t root, int space, int height) {
    if (!root) return;

    space += height;

    printBinaryTree(root->right, space, height);
    printf("\n");

    for (int i = height; i < space; i++) {
        printf(" ");
    }

    print_node(root);

    printf("\n");
    printBinaryTree(root->left, space, height);
}


void print_tree(node_t root) {
    printBinaryTree(root, 0, 10);
    printf("-------------------------------\n");
}

void remove_tree(node_t *root) {
    if (*root) {
        remove_tree(&((*root)->left));
        remove_tree(&((*root)->right));
        free(*root);
        *root = NULL;
    }
}

#endif