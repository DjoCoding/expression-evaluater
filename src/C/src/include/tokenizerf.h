#ifndef TOKENIZERF_H
#define TOKENIZERF_H

#include <stdio.h>
#include <stdlib.h>

#include "./string_viewf.h"
#include "./convertf.h"
#include "./type.h"

typedef enum {
    SIN = 0, 
    COS, 
    EXP,
    SQRT,
    FN_COUNT,
    NO_FUNCTION 
} FUNCTION_NAME;

typedef enum {
    LEFT_PAR = 0, 
    RIGHT_PAR,
    PAR_COUNT
} PAR_TYPE;

typedef union {
    FUNCTION_NAME func_name;
    double number;
    char operator;
    PAR_TYPE par;
} TOKEN_DATA;

typedef enum {
    TT_NUMBER = 0,
    TT_OPERATOR,
    TT_FUNCTION, 
    TT_PAR,
    TT_COUNT,
} TOKEN_TYPE;

char *TOKEN_TYPES[TT_COUNT] = {"TT_NUMBER", "TT_OPERATOR", "TT_FUNCTION", "TT_PAR"};
char *FUNCTION_NAMES[FN_COUNT] = {"SIN", "COS", "EXP", "SQRT"};
char *PAR_TYPES[PAR_COUNT] = {"LEFT_PAR", "RIGHT_PAR"};

typedef struct token *token_t;

typedef struct token {
    TOKEN_DATA value;
    TOKEN_TYPE type;
    token_t next;
} token;

TOKEN_DATA get_func_name(char *func_name) {
    TOKEN_DATA value = {0};

    if (strcmp(func_name, "sin") == 0) value.func_name = SIN;
    else 
        if (strcmp(func_name, "cos") == 0) value.func_name = COS; 
        else 
            if (strcmp(func_name, "exp") == 0) value.func_name = EXP;
            else 
                if (strcmp(func_name, "sqrt") == 0) value.func_name = SQRT;
                else  {
                fprintf(stderr, "TOKEN NOT FOUND: %s\n", func_name);
                value.func_name = NO_FUNCTION;
            }
        
    return value;
}

TOKEN_DATA get_par_type(char c) {
    TOKEN_DATA value = {0};
    switch(c) {
        case '(':
            value.par = LEFT_PAR;
            break;
        case ')':
            value.par = RIGHT_PAR;
            break;
    }
    return value;
} 

token_t token_init(TOKEN_DATA value, TOKEN_TYPE type) {
    token_t result = (token_t) malloc(sizeof(token));
    result->type = type;
    result->value = value;
    result->next = NULL;
    return result;
}

// return NULL if an error is found!
token_t get_next_token(sv_t sv) {

    if (ispar(sv_peek(sv))) {
        return token_init(get_par_type(sv_consume(sv)), TT_PAR);
    }

    if (isoperator(sv_peek(sv))) {
        char operator = sv_consume(sv);
        TOKEN_DATA value = { .operator = operator };
        return token_init(value, TT_OPERATOR);
    }

    if (isnum(sv_peek(sv))) {
        // need to extract the number from the string view
        // then convert it to an integer
        // and then constructing the token!

        char *start = sv->content + sv->current;
        size_t size = 1;
        sv_consume(sv);

        while (!(sv_end(sv)) && (isnum(sv_peek(sv)))) {
            size++;
            sv_consume(sv);
        }

        TOKEN_DATA value = { .number = tonumber(start, size) };
        return token_init(value, TT_NUMBER);
    }

    if (isal(sv_peek(sv))) {
        char *start = sv->content + sv->current;
        size_t size = 1;
        sv_consume(sv);

        while (!(sv_end(sv)) && (isal(sv_peek(sv)))) {
            size++;
            sv_consume(sv);
        }

        char *func_name = NULL;

        func_name = (char *)malloc(sizeof(char) * (size + 1));
        strncpy(func_name, start, size);
        
        TOKEN_DATA value  = get_func_name(func_name);

        free(func_name);

        if (value.func_name == NO_FUNCTION) return NULL;

        return token_init(value, TT_FUNCTION);
    }
    
    fprintf(stderr, "TOKEN NOT FOUND: %c\n", sv_peek(sv));
    return NULL;
}

void token_print(token_t token) {
    switch(token->type) {
            case TT_NUMBER: 
                printf("TOKEN TYPE: %s , TOKEN VALUE: %f\n", TOKEN_TYPES[TT_NUMBER], token->value.number);
                break;
            case TT_OPERATOR: 
                printf("TOKEN TYPE: %s, TOKEN VALUE %c\n", TOKEN_TYPES[TT_OPERATOR], token->value.operator);
                break;
            case TT_FUNCTION: 
                printf("TOKEN TYPE: %s, TOKEN VALUE: %s\n", TOKEN_TYPES[TT_FUNCTION], FUNCTION_NAMES[token->value.func_name]);
                break;
            case TT_PAR: 
                printf("TOKEN TYPE: %s, TOKEN VALUE: %s\n", TOKEN_TYPES[TT_PAR], PAR_TYPES[token->value.par]);
                break;
            case TT_COUNT: 
                break;
        }   
}

void tokens_print(token_t head) {
    token_t current = head;
    while (current) {
        token_print(current);
        current = current->next;
    }
}

void tokens_remove(token_t *head) {
    token_t current;
    while (*head) {
        current = *head;
        *head = current->next;
        free(current);
    }
    *head = NULL;
}


#endif