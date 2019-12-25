#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "bmp_parser.h"
#include "embed.h"
#include "decoder.h"

int main(int argc, char* argv[])
{
    //timer
    clock_t start, end;
    double embed_time, decode_time;

    // bmp reader
    struct BmpParser encoder;
    ReadFile(argv[2], &encoder);
    
    // read message from txt file
    int secret_size = (encoder.width*encoder.height-1);
    int string_size = secret_size/8;
    char* string = (char*)malloc(string_size*sizeof(unsigned char)+1);
    ReadTxt(argv[1], string, string_size);

    // stego encoder
    unsigned char* bits = (unsigned char*)malloc(secret_size*sizeof(unsigned char));
    StringToBits(string, bits);
    printf("Embedding...\n");
    start = clock();
    embed(encoder.data, encoder.data_size, bits, secret_size);
    end = clock();
    embed_time = ((double) (end - start)) / CLOCKS_PER_SEC;
    OutputFile("photo/encode.bmp", &encoder);
    printf("Output embedded image\n");
    free(bits);
    free(string);

    // stego decoder
    struct BmpParser decoder;
    ReadFile("photo/encode.bmp", &decoder);
    char* message = (char*)malloc((secret_size/8)*sizeof(char)+1);
    printf("Decoding...\n");
    start = clock();
    decode(decoder.data, secret_size, message);
    end = clock();
    decode_time = ((double) (end - start)) / CLOCKS_PER_SEC;
    OutputTxt("message.txt", message);
    printf("Output decoded message\n");
    free(message);
    printf("==================================================\n");
    printf("embed time: %f ms\n", embed_time/1000);
    printf("decode time: %f ms\n", decode_time/1000);
    return 0;
}
