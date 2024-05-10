#ifndef TYPE_H
#define TYPE_H

#include <stdio.h>
#include <stdbool.h>

bool iswhitespace(char c) {
    return (c == ' ');
}

bool isnum(char c) {
    return (c >= '0') && (c <= '9');
}

bool isal(char c) {
    return (c >= 'a') && (c <= 'z');
}

bool ispar(char c) {
    return (c == '(') || (c == ')');
}

bool isoperator(char c) {
    return (c == '+') || (c == '-') || (c == '/') || (c == '*') || (c == '%');
}

#endif