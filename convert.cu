#include "convert.h"

void BitsToString(unsigned char* bits, int bits_size, char* string)
{
    for(int n=0; n<bits_size; n++) {
        string[n] = 0;
        for (int j = 0; j < 8; j++){
            string[n] += bits[8*n+j];
            if(j != 7)
                string[n] = string[n] << 1;
        }
    }
}

void StringToBits(char* string, unsigned char* bits)
{
    for (int n = 0; n < strlen(string); n++){
        int tmp = string[n];
        for (int j = 7; j >= 0; j--){
            bits[8*n+j] = tmp%2;
            tmp = tmp >> 1;
        }
    }
}