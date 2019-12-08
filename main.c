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
    char* string = "I am a handsome boy, but i don't have girlfriend. would you please be my wife?";
    char* bits = (char*)malloc(strlen(string)*8*sizeof(char));
    StringToBits(string, bits);
    printf("after\n");
    for(int n = 0; n < 16; n++) {
        printf("%d",bits[n]);
        if(n%8==7)
            printf("\n");
    }
    printf("\n");
    for(int n = 0; n < 10; n++) {
        printf("%d ",encoder.data[n]);
    }
    printf("\n");
    embed(encoder.data, encoder.data_size, bits, strlen(string)*8);
    for(int n = 0; n < 10; n++) {
        printf("%d ",encoder.data[n]);
    }
    printf("\n");
    OutputFile("photo/encode.png", &encoder);
    // stego decoder
    return 0;
}