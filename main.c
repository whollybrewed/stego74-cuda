#include <stdio.h>
#include <stdlib.h>
#include "bmp_parser.h"
#include "embed.h"


int main(int argc, char* argv[])
{
    // bmp reader
    struct BmpParser encoder;
    ReadFile("photo/fluit.bmp", &encoder);
    // stego encoder
    char* string = "ok";
    char* bits = (char*)malloc(strlen(string)*8*sizeof(char));
    StringToBits(string, bits);
    printf("after\n");
    for(int n = 0; n < 16; n++) {
        printf("%d",bits[n]);
        if(n%8==7)
            printf("\n");
    }
    printf("\n");
    //embed(encoder.data, "Hello world, I am a handsome guy");
    // stego decoder
    return 0;
}