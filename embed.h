#ifndef EMBED_H
#define EMBED_H

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

typedef struct subgroup{ unsigned char bit[7]; }cosets;

void embed(unsigned char *data, const int data_size, unsigned char *secrets, const int num_secret);
void StringToBits(unsigned char* string, unsigned char* bits);
#endif