#include <stdio.h>
#include <stdlib.h>
#include "bmp_parser.h"
#include "embed.h"
#include "decoder.h"

int main(int argc, char* argv[])
{
    // bmp reader
    struct BmpParser encoder;
    ReadFile("photo/man.bmp", &encoder);
    
    // read message from txt file
    int secret_size = (encoder.width*encoder.height-1)*8;
    char* string = (char*)malloc((encoder.width*encoder.height-1)*sizeof(unsigned char)+1);
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
    char* message = (char*)malloc((secret_size/8)*sizeof(char)+1);
    decode(decoder.data, secret_size, message);
    printf("message = %s\n", message);

    // output txt file
    OutputTxt("message.txt", message);
    free(message);
    return 0;
}
