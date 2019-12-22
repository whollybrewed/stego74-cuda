#ifndef _CONVERT_H
#define _CONVERT_H

#include <string.h>
//decode
void BitsToString(unsigned char* bits, int bits_size, char* string);
//encode
void StringToBits(char* string, unsigned char* bits);
#endif