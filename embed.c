#include "embed.h"

#define width 1024
#define height 1024

void embed(unsigned char *data, unsigned char *secret)
{
    cosets sub_g[16][8]; 
    unsigned char entry[7], temp[7];
    int u, v, count = 0;
    for (int i = 0; i < 128; i++){
        for (int j = 0; j < 7; j++){
            entry[j] = (((i >> j) & 1) == 0 ? 0 : 1);
        }
        grouping(entry, sub_g);
    }
    while (count < height * height - 1){
        for (int i = 0; i < 7; i++){
            temp[i] = secret[i + count];   
        }
        u = temp[2] * 8
          + temp[4] * 4
          + temp[5] * 2
          + temp[6] * 1;
          
        v = temp[0] * 4
          + temp[1] * 2
          + temp[3] * 1;
        
        for (int i = 0; i < 7; i++){
            if (sub_g[u][v].bit[i] == 1){
                data[i + count] |= 1; //0b0000001
            }
            else{
                data[i + count] &= 126; //0b1111110
                
            }
        }
        count += 7;
    }


}