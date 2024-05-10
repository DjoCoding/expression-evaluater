#ifndef INPUTF_H
#define INPUTF_H 

#define STRING_SIZE 100

char s[STRING_SIZE] = {0};

void read_string() {
    printf("> ");
    int size = 0;
    char c;
    while ((size < STRING_SIZE) && ((c = getchar()) != '\n')) {
        s[size++] = c;
    }
    s[size] = '\0';
}

#endif