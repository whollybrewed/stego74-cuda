#ifndef _CONVERT_H
#define _CONVERT_H

#include <string.h>
//decode
void BitsToString(unsigned char* bits, int bits_size, unsigned char* string);
//encode
void StringToBits(unsigned char* string, unsigned char* bits);
#endif