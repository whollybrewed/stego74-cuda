#ifndef EMBED_H
#define EMBED_H

#include <stdlib.h>

typedef struct subgroup{ unsigned char bit[7]; }cosets;

void embed(unsigned char *data, unsigned char *secret);

#endif