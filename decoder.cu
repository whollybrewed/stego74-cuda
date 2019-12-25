#include "decoder.h"
#include "convert.h"
#include "grouping.h"
#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>

__global__ void decodekernel(unsigned char *dp, unsigned char *dl, unsigned char *ds)
{
   	unsigned char matrix_h[3][7] =
 	{
          {1, 1, 0, 1, 1, 0, 0},
          {1, 0, 1, 1, 0, 1, 0},
          {0, 1, 1, 1, 0, 0, 1}
 	};
	int i;
   	int tx = blockIdx.x*blockDim.x+threadIdx.x;
        ds[tx*7] = 0;
        ds[tx*7+1] = 0;
        ds[tx*7+3] = 0;
        for(i=0; i<7; i++){
                dl[tx*7+i] = dp[tx*7+i]&1;
                ds[tx*7] = ds[tx*7]^(matrix_h[0][i]*dl[tx*7+i]);
                ds[tx*7+1] = ds[tx*7+1]^(matrix_h[1][i]*dl[tx*7+i]);
                ds[tx*7+3] = ds[tx*7+3]^(matrix_h[2][i]*dl[tx*7+i]);
        }
        ds[tx*7+2] = dl[tx*7+2];
        ds[tx*7+4] = dl[tx*7+4];
        ds[tx*7+5] = dl[tx*7+5];
        ds[tx*7+6] = dl[tx*7+6];
}

void decode(unsigned char *p, const int secret_size, char* message)
{
	unsigned char matrix_h[3][7] =
	{
	  {1, 1, 0, 1, 1, 0, 0},
	  {1, 0, 1, 1, 0, 1, 0},
	  {0, 1, 1, 1, 0, 0, 1}
	};
	int i, j;
        const int num_secret = secret_size;
        const int num_group = (secret_size)/7;
        const int remain = (secret_size) % 7;
        unsigned char l[num_secret-remain+7];  //LSB
        unsigned char s[num_secret-remain+7];  //secret bits
	int size = num_group*7*sizeof(unsigned char);
	int tilewid = 7;
	unsigned char *dp, *dl, *ds;
        cudaMalloc(&dp, size);
        cudaMemcpy(dp, p, size, cudaMemcpyHostToDevice);
	cudaMalloc(&dl, size);
        cudaMemcpy(dl, l, size, cudaMemcpyHostToDevice);
        cudaMalloc(&ds, size);
	dim3 dimBlock(tilewid);
        dim3 dimGrid(num_group/tilewid);
        decodekernel<<<dimGrid, dimBlock>>>(dp, dl, ds);
        printf("Printing final results...\n");
        cudaMemcpy(s, ds, size, cudaMemcpyDeviceToHost);
	cudaFree(dp);
	cudaFree(dl);
        cudaFree(ds);
        //deal with the remainder
        if(remain>0){
		for(j=num_group*7; j<num_secret; j++)
			l[j] = p[j]&1;
                for(j=num_secret-remain+6; j>=num_secret; j--){
                        l[j] = p[num_secret]&1;
                        p[num_secret] = p[num_secret]>>1;
                }
		s[num_group*7] = 0;
		s[num_group*7+1] = 0;
		s[num_group*7+3] = 0;
                for(i=0; i<7; i++){
                        s[num_group*7] = s[num_group*7]^(matrix_h[0][i]*l[num_secret-remain+i]);
                        s[num_group*7+1] = s[num_group*7+1]^(matrix_h[1][i]*l[num_secret-remain+i]);
                        s[num_group*7+3] = s[num_group*7+3]^(matrix_h[2][i]*l[num_secret-remain+i]);
                }
                s[num_group*7+2] = l[num_group*7+2];
                s[num_group*7+4] = l[num_group*7+4];
                s[num_group*7+5] = l[num_group*7+5];
                s[num_group*7+6] = l[num_group*7+6];
        }
    BitsToString(s, secret_size/8+1, message);
    message[secret_size/8] = '\0';
}
