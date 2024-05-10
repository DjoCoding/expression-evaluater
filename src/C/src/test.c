#include <stdio.h>
#include <math.h>

#define TO_RADIANS(angle) \
    angle * 3.14 / 180 

int main(void) {
    float angle = TO_RADIANS(120);
    printf("%f\n", cos(angle));
}