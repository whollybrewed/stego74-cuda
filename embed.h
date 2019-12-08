#ifndef EMBED_H
#define EMBED_H

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "dummy.h" // for debug purpos

typedef struct subgroup{ unsigned char bit[7]; }cosets;

void embed(unsigned char *data, const int data_size, unsigned char *secret, const int num_secret);
void StringToBits(char* string, char* bits);
#endif