#include "grouping.h"

__global__ void grouping(cosets *d_sub_g)
{
    unsigned char matrix_h[3][7] =
    {
        {1, 1, 0, 1, 1, 0, 0},
        {1, 0, 1, 1, 0, 1, 0},
        {0, 1, 1, 1, 0, 0, 1}
    };

    unsigned char syndrome[3];
    unsigned char entry[7];
    int u, v;
    int idx = blockIdx.x * blockDim.x + threadIdx.x;

    for (int j = 0; j < 7; j++){
        // store the decimal value in the binary format of one bit per entry
        entry[j] = (((idx >> j) & 1) == 0 ? 0 : 1);
    }
    __syncthreads();

    u = entry[2] * 8
      + entry[4] * 4
      + entry[5] * 2
      + entry[6] * 1;
   
    for (int i = 0; i < 3; i++){
        for (int j = 0; j < 7; j++){
            if (j == 0)
                syndrome[i] = entry[j] * matrix_h[i][j];
            else	
                syndrome[i] = syndrome[i] ^ (entry[j] * matrix_h[i][j]);
        }	
    }

    v = syndrome[0] * 4
      + syndrome[1] * 2
      + syndrome[2] * 1;

    for (int i = 0; i < 7; i++){
        d_sub_g[u * 8 + v].bit[i] = entry[i];
    }
}