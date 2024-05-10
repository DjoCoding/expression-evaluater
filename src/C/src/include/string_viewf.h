#ifndef STRING_VIEWF_H
#define STRING_VIEWF_H


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

typedef struct {
    char *content;
    size_t count;
    size_t current;
} string_view;

typedef string_view *sv_t;

sv_t sv_init(char *content) {
    sv_t result = (sv_t) malloc(sizeof(string_view));
    result->content = content;
    result->count = strlen(content);
    result->current = 0;
    return result;
}

char sv_peek(sv_t sv) {
    return sv->content[sv->current];
}

char sv_consume(sv_t sv) {
    sv->count--; 
    return sv->content[sv->current++];
}

bool sv_end(sv_t sv) {
    return (sv->count == 0);
}

void sv_remove(sv_t *sv) {
    // free the content of the string view
    // free((*sv)->content);
    // (*sv)->content = NULL;
    free(*sv);
    *sv = NULL;
}

#endif