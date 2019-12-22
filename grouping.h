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

__global__ void grouping(cosets *d_sub_g);

#endif