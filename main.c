#include <stdio.h>
#include <stdlib.h>
#include "bmp_parser.h"
#include "embed.h"
#include "decoder.h"

int main(int argc, char* argv[])
{
    // bmp reader
    struct BmpParser encoder;
    ReadFile("photo/fluit.bmp", &encoder);
    
    // stego encoder
    unsigned char* string = "Last Christmas, I gave you my heart But the very next day you gave it away This year, to save me from tears I'll give it to someone special";
    int secret_size = strlen(string)*8;
    if (secret_size > encoder.height*encoder.width-1) {
        printf("secret is too large\n");
        return 0;
    }
    unsigned char* bits = (unsigned char*)malloc(secret_size*sizeof(unsigned char));
    StringToBits(string, bits);
    embed(encoder.data, encoder.data_size, bits, secret_size);
    printf("\nAfter encode\n");
    OutputFile("photo/encode.bmp", &encoder);
    free(bits);

    // stego decoder
    struct BmpParser decoder;
    ReadFile("photo/encode.bmp", &decoder);
    decode(decoder.data, secret_size);
    printf("after decode\n");
 
    return 0;
}