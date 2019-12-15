#ifndef GROUPING_H
#define GROUPING_H

#include <stdlib.h>
#include "embed.h"

/*
 * G matrix (7, 4):
 * 1 0 0 0 1 1 0
 * 0 1 0 0 1 0 1
 * 0 0 1 0 0 1 1
 * 0 0 0 1 1 1 1
 * 
 * H matrix:
 * 1 1 0 1 1 0 0
 * 1 0 1 1 0 1 0
 * 0 1 1 1 0 0 1
 */

unsigned char matrix_h[3][7];

void grouping(unsigned char entry[7] cosets sub_g[16][8]);

#endif