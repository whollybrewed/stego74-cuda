#include <stdio.h>
#include <stdlib.h>
#include "bmp_parser.h"
#include "embed.h"
#include "decoder.h"

int main(int argc, char* argv[])
{
    // bmp reader
    struct BmpParser encoder;
    ReadFile("photo/fruit.bmp", &encoder);
    
    // read message from txt file
    int secret_size = (encoder.width*encoder.height-1)*8;
    unsigned char* string = (unsigned char*)malloc((encoder.width*encoder.height-1)*sizeof(unsigned char)+1);
    ReadTxt(argv[1], string, encoder.width*encoder.height-1);

    // stego encoder
    unsigned char* bits = (unsigned char*)malloc(secret_size*sizeof(unsigned char));
    StringToBits(string, bits);
    embed(encoder.data, encoder.data_size, bits, secret_size);
    printf("\nAfter encode\n");
    OutputFile("photo/encode.bmp", &encoder);
    free(bits);
    free(string);

    // stego decoder
    struct BmpParser decoder;
    ReadFile("photo/encode.bmp", &decoder);
    decode(decoder.data, secret_size);
 
    return 0;
}