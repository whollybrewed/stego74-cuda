#include "embed.h"
#include "dummy.h" // for debug purpos

void embed(unsigned char *data, unsigned char *secrets)
{
    cosets sub_g[16][8]; 
    unsigned char pixcel_mask = 255;
    unsigned char entry[7], temp[7];
    const int num_secret = height * width - 1;
    const int remain = (height * width - 1) % 7;
    int u, v, count = 0;
    // all possible codewords
    for (int i = 0; i < 128; i++){
        for (int j = 0; j < 7; j++){
            // store the decimal value in the binary format of one bit per entry
            entry[j] = (((i >> j) & 1) == 0 ? 0 : 1);
        }
        grouping(entry, sub_g);
    }
    while (count < num_secret - remain){
        for (int i = 0; i < 7; i++){
            temp[i] = secrets[i + count];   
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
    // dealing with the remainder secrect bits
    for (int i = 0; i < 7; i++){
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

    for (int i = 0; i < remain; i++){
        if (sub_g[u][v].bit[i] == 1){
            data[i + num_secret - remain] |= 1; //0b0000001
        }
        else{
            data[i + num_secret - remain] &= 126; //0b1111110
        }
    }
    // extra n bits replace the smallest n bits of the last pixel 
    for (int i = remain; i < 7; i++){
        pixcel_mask |= sub_g[u][v].bit[i];
        pixcel_mask <<= 1;
    }
    data[num_secret + 1] &= pixcel_mask;
}