#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cuda_profiler_api.h>
#include "bmp_parser.h"
#include "embed.h"
#include "decoder.h"
int main(int argc, char* argv[])
{
    // bmp reader
    struct BmpParser encoder;
    ReadFile(argv[2], &encoder);
    
    // read message from txt file
    int secret_size = (encoder.width*encoder.height-1);
    int string_size = secret_size/8;
    char* string = (char*)malloc(string_size*sizeof(unsigned char)+1);
    ReadTxt(argv[1], string, string_size);

    // stego grouping
    unsigned char* bits = (unsigned char*)malloc(secret_size*sizeof(unsigned char));
    StringToBits(string, bits);
    cosets *d_sub_g;
    dim3 BlockSize(128);
    dim3 GridSize(1);
    int sub_g_size = 128 * sizeof(cosets);
    cudaMalloc((void**)&d_sub_g, sub_g_size);
    grouping<<<GridSize, BlockSize>>>(d_sub_g);

    //stego embed
    unsigned char *data_cu, *secret_cu;
    int tile_width = 224;
    int remain = secret_size % 7;
    int b_remain = (secret_size-remain)%tile_width;
    dim3 dimBlock(tile_width);
    dim3 dimGrid(secret_size/tile_width);
    cudaMalloc((void**)&data_cu, secret_size + 1);
    cudaMalloc((void**)&secret_cu, secret_size);
    cudaStream_t stream1, stream2;
    cudaStreamCreate(&stream1);
    cudaStreamCreate(&stream2);
    printf("Embedding...");
    cudaMemcpyAsync(data_cu, encoder.data, encoder.width*encoder.height, cudaMemcpyHostToDevice, stream1);
    cudaMemcpyAsync(secret_cu, bits, secret_size, cudaMemcpyHostToDevice, stream1);
    embed<<<dimGrid, dimBlock,0,stream2>>>
        (data_cu, encoder.data_size, secret_cu, secret_size - remain - b_remain, d_sub_g, 0);
    embed<<<1, b_remain,0,stream1>>>
        (data_cu, encoder.data_size, secret_cu, b_remain, d_sub_g, secret_size - remain - b_remain);
    cudaMemcpyAsync(encoder.data, data_cu, encoder.height * encoder.width, cudaMemcpyDeviceToHost, stream2);
    OutputFile("photo/encode.bmp", &encoder);
    printf("Output embedded image\n");
    free(bits);
    free(string);
	cudaStreamDestroy(stream1);
	cudaStreamDestroy(stream2);
    cudaFree(data_cu);
    cudaFree(secret_cu);

    // stego decoder
    struct BmpParser decoder;
    ReadFile("photo/encode.bmp", &decoder);
    char* message = (char*)malloc((secret_size/8)*sizeof(char)+1);
    printf("Decoding...\n");
    decode(decoder.data, secret_size, message);

    // output txt file
    OutputTxt("message.txt", message);
    printf("Output decoded message\n");
    printf("secrets character count: %d\n", strlen(message));
	printf("==========================================================\n\n");
    free(message);
	cudaProfilerStop();
    return 0;
}
