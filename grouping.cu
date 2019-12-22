#include "grouping.h"

unsigned char matrix_h[3][7] =
{
  {1, 1, 0, 1, 1, 0, 0},
  {1, 0, 1, 1, 0, 1, 0},
  {0, 1, 1, 1, 0, 0, 1}
};

void grouping(unsigned char entry[7], cosets sub_g[16][8])
{
    int u, v;
    unsigned char syndrome[3];
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
        sub_g[u][v].bit[i] = entry[i];
    }
}