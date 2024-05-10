#include <stdio.h>

#include "./include/tokenizerf.h"
#include "./include/lexerf.h"
#include "./include/parserf.h"
#include "./include/astf.h"
#include "./include/cleanf.h"
#include "./include/inputf.h"
#include "./include/eval.h"


void repl() {
    read_string();
    if (strcmp(s, "q") == 0) return;

    token_t tokens = lex(s); 
    if (!tokens) return;

    parser_t parser = parser_init(tokens);
    node_t root = parse(parser);

    if (!root) {
        clean(&parser, &root);
        return;
    }

    EVALUATION_RESULT output = eval(root);

    if (output.type == ERROR) {
        printf("ERROR FOUND\n");
        return;
    } 
    
    printf("%.2f\n", output.result);
    clean(&parser, &root);
}


int main(void) {
    while (true) {
        repl();
        if (strcmp(s, "q") == 0) break;
    }
    return 0;
}