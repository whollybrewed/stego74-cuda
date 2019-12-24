#include <stdio.h>
#include <stdlib.h>
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
    // stego encoder
    unsigned char* bits = (unsigned char*)malloc(secret_size*sizeof(unsigned char));
    StringToBits(string, bits);
    printf("After String to bit\n");
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
    printf("secret size + %d\n",secret_size);
    cudaMalloc((void**)&data_cu, secret_size+1);
    cudaMalloc((void**)&secret_cu, secret_size);
    printf("size: %d\n",encoder.width*encoder.height);
    cudaMemcpy(data_cu, encoder.data, encoder.width*encoder.height, cudaMemcpyHostToDevice);
    cudaMemcpy(secret_cu, bits, secret_size, cudaMemcpyHostToDevice);
    cudaStream_t stream1, stream2;
    cudaStreamCreate(&stream1);
    cudaStreamCreate(&stream2);
    for(int n=0; n<10; n++)
	printf("%d ",encoder.data[n]);
    printf("\n");
    embed<<<dimGrid, dimBlock,0,stream1>>> (data_cu, encoder.data_size, secret_cu, secret_size-remain-b_remain, d_sub_g, 0);
    embed<<<1, b_remain,0,stream2>>> (data_cu, encoder.data_size, secret_cu, b_remain, d_sub_g, secret_size - remain - b_remain);
    //remain_embed(encoder.data, encoder.data_size, bits, secret_size, host_sub_g);
    cudaMemcpy(encoder.data, data_cu, encoder.height*encoder.width, cudaMemcpyDeviceToHost);
    //unsigned char* test = (unsigned char*)malloc(secret_size*sizeof(unsigned char));
    //cudaMemcpy(test, secret_cu, secret_size, cudaMemcpyDeviceToHost);
    //char* test_message = (char*)malloc((secret_size/8)*sizeof(char)+1);
    //BitsToString(test,secret_size,test_message);
    //printf("test\n%s\n",test_message);
    for(int n=0; n<10; n++)
	printf("%d ",encoder.data[n]);
    printf("\n");
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
    printf("end\n");
    printf("message = %s\n", message);

    // output txt file
    OutputTxt("message.txt", message);
    free(message);
    return 0;
}
