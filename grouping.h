#ifndef GROUPING_H
#define GROUPING_H

#include <stdlib.h>

/*
 * G matrix (7, 4):
 * 1 0 0 0 1 1 0
 * 0 1 0 0 1 0 1
 * 0 0 1 0 0 1 1
 * 0 0 0 1 1 1 1
 */

unsigned char matrix_h[3][7] =
{
    {1, 1, 0, 1, 1, 0, 0},
    {1, 0, 1, 1, 0, 1, 0},
    {0, 1, 1, 1, 0, 0, 1}
};

#endif