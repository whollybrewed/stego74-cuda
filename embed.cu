#include "embed.h"
#include "grouping.h"

__global__ void embed(unsigned char *data, const int data_size, unsigned char *secrets, const int num_secret, cosets* sub_g, int start)
{
    printf("hello\n");
    unsigned char temp[7];
    uint8_t u=0, v=0; 
    int threadId = blockIdx.x * blockDim.x + threadIdx.x;
    int count = start+threadId/7;
    int start_pos = start + threadId;
    int stride = blockDim.x * gridDim.x;
    printf("hello3\n");
    for (int n=0; n < num_secret/stride; n++) {
	uint8_t i = threadId%7;
        temp[i] = secrets[count+i];   
	__syncthreads();
        u = temp[2] * 8
          + temp[4] * 4
          + temp[5] * 2
          + temp[6] * 1;
          
        v = temp[0] * 4
          + temp[1] * 2
          + temp[3] * 1;
    	printf("hello2\n");
        if (sub_g[u*8+v].bit[i] == 1){
            data[i + start_pos] |= (unsigned char)1; //0b00000001
        }
        else{
            data[i + start_pos] &= (unsigned char)254; //0b11111110
        }
        start_pos += stride;
    }
    printf("%d %d %d\n", threadId, u, v);
}

__host__ void remain_embed(unsigned char *data, const int data_size, unsigned char *secrets, const int num_secret, cosets* sub_g)
{
    unsigned char pixcel_mask = 0;
    const uint8_t remain = (num_secret) % 7;
    unsigned char data_mask = 255;
    unsigned char temp[7];
    uint8_t u, v; 
    for (uint8_t i = 0; i < 7; i++){
        temp[i] = 0;
        if (i < remain){
            temp[i] = secrets[i + num_secret - remain];
        }   
    }
    u = temp[2] * 8
      + temp[4] * 4
      + temp[5] * 2
      + temp[6] * 1;
    
    v = temp[0] * 4
      + temp[1] * 2
      + temp[3] * 1;
      
    for (uint8_t i = 0; i < remain; i++){
        if (sub_g[u*8+v].bit[i] == 1){
            data[i + num_secret - remain] |= (unsigned char)1; //0b0000001
        }
        else{
            data[i + num_secret - remain] &= (unsigned char)254; //0b1111110
        }
    }
    // extra n bits replace the smallest n bits of the last pixel 
    for (uint8_t i = remain; i < 7; i++){
        pixcel_mask |= sub_g[u*8+v].bit[i];
        if (i < 6){
            pixcel_mask <<= 1;
        }
        data_mask <<= 1;
    }
    data[num_secret] &= data_mask;
    data[num_secret] |= pixcel_mask;

}
