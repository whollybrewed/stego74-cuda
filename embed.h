#ifndef EMBED_H
#define EMBED_H

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "dummy.h" // for debug purpos

typedef struct subgroup{ unsigned char bit[7]; }cosets;

void embed(unsigned char *data, unsigned char *secret);
char* StringToBits(char* string);
#endif