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

    cosets *d_sub_g;
    cosets host_sub_g[128];
    dim3 BlockSize(128);
    dim3 GridSize(1);
    int sub_g_size = 128 * sizeof(cosets);
    cudaMalloc((void**)&d_sub_g, sub_g_size);
    grouping<<<GridSize, BlockSize>>>(d_sub_g);
    cudaMemcpy(host_sub_g, d_sub_g, sub_g_size, cudaMemcpyDeviceToHost);
    //cudaBindTexture(0, d_tex, d_sub_g, sub_g_size);
    //texture <cosets, 1, cudaReadModeElementType> d_tex;
    unsigned char *data_cu, *secret_cu;
    int tile_width = 224;
    int remain = secret_size % 7;
    int b_remain = (secret_size-remain)%tile_width;
    dim3 dimBlock(tile_width);
    dim3 dimGrid(secret_size/tile_width);
    cudaMalloc((void**)&data_cu, secret_size+1);
    cudaMalloc((void**)&secret_cu, secret_size);
    cudaMemcpy(data_cu, encoder.data, encoder.data_size, cudaMemcpyHostToDevice);
    cudaMemcpy(secret_cu, bits, secret_size, cudaMemcpyHostToDevice);
    cudaStream_t stream1, stream2;
    //cudaStreamCreate(&stream1);
    //cudaStreamCreate(&stream2);
    //embed<<<dimGrid, dimBlock, 0, stream1>>> (encoder.data, encoder.data_size, bits, secret_size-remain-b_remain, d_sub_g, 0);
    //embed<<<1, b_remain, 0, stream2>>> (encoder.data, encoder.data_size, bits, secret_size, d_sub_g, secret_size - remain - b_remain);
    embed<<<dimGrid, dimBlock>>> (encoder.data, encoder.data_size, bits, secret_size-remain-b_remain, d_sub_g, 0);
    embed<<<1, b_remain>>> (encoder.data, encoder.data_size, bits, secret_size, d_sub_g, secret_size - remain - b_remain);
    remain_embed(encoder.data, encoder.data_size, bits, secret_size, host_sub_g);
    cudaMemcpy(encoder.data, data_cu, encoder.data_size-remain, cudaMemcpyDeviceToHost);
    printf("\nAfter encode\n");
    OutputFile("photo/encode.bmp", &encoder);
    free(bits);
    free(string);
    cudaFree(data_cu);
    cudaFree(secret_cu);
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
