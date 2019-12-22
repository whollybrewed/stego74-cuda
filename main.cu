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
    char* string = (char*)malloc((encoder.width*encoder.height-1)*sizeof(unsigned char)+1);
    ReadTxt(argv[1], string, encoder.width*encoder.height-1);

    // stego encoder
    unsigned char* bits = (unsigned char*)malloc(secret_size*sizeof(unsigned char));
    StringToBits(string, bits);

    //debug purpose
    cosets temp_sub_g[16 * 8];

    cosets *d_sub_g;
    dim3 BlockSize(128);
    dim3 GridSize(1);
    int sub_g_size = 128 * sizeof(cosets);
    cudaMalloc((void**)&d_sub_g, sub_g_size);
    texture <cosets, 1, cudaReadModeElementType> d_tex;
    grouping<<<GridSize, BlockSize>>>(d_sub_g);
    cudaMemcpy(temp_sub_g, d_sub_g, sub_g_size, cudaMemcpyDeviceToHost);
    cudaBindTexture(0, d_tex, d_sub_g, sub_g_size);

    embed(encoder.data, encoder.data_size, bits, secret_size, temp_sub_g);
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