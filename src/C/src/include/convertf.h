#ifndef CONVERTF_H
#define CONVERTF_H

int tonumber(char *string, size_t size) {
    int result = 0;

    for (size_t i = 0; i < size; i++) {
        result = result * 10 + (int) *string - (int) '0';
        string++;
    }

    return result;
}


#endif