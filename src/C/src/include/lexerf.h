#ifndef LEXERF_H
#define LEXERF_H


#include "./tokenizerf.h"
#include "./type.h"
#include "./string_viewf.h"

token_t lex(char *content) {

    if (!content) {
        return NULL;
    }

    sv_t sv = sv_init(content);

    token_t head = {0};
    token_t current = {0};

    while (!sv_end(sv)) {
        if (iswhitespace(sv_peek(sv))) sv_consume(sv);
        else {
            token_t next_token = get_next_token(sv);
            if (!next_token) {
                tokens_remove(&head);
                break;
            }

            if (!head) {
                head = next_token;
                current = next_token;
            } else {
                current->next = next_token;
                current = next_token;
            }
        }
    }
    sv_remove(&sv);
    return head;
}


#endif