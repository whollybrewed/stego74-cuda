#include "embed.h"
#include "grouping.h"

void StringToBits(unsigned char* string, unsigned char* bits)
{
    for (int n = 0; n < strlen(string); n++){
        int tmp = string[n];
        for (int j = 7; j >= 0; j--){
            bits[8*n+j] = tmp%2;
            tmp = tmp >> 1;
        }
    }
    // printf("after\n");
    // for(int n = 0; n < strlen(string)*8; n++) {
    //     printf("%d",bits[n]);
    //     if(n%8==7)
    //         printf("\n");
    // }
    // printf("\n");
}

void embed(unsigned char *data, const int data_size, unsigned char *secrets, const int num_secret)
{
    cosets sub_g[16][8]; 
    unsigned char pixcel_mask = 0;
    unsigned char data_mask = 255;
    unsigned char entry[7], temp[7];
    //const int num_secret = height * width - 1;
    const int remain = (num_secret) % 7;
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
                data[i + count] |= (unsigned char)1; //0b00000001
            }
            else{
                data[i + count] &= (unsigned char)254; //0b11111110
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
            data[i + num_secret - remain] |= (unsigned char)1; //0b0000001
        }
        else{
            data[i + num_secret - remain] &= (unsigned char)254; //0b1111110
        }
    }
    // extra n bits replace the smallest n bits of the last pixel 
    for (int i = remain; i < 7; i++){
        pixcel_mask |= sub_g[u][v].bit[i];
        if (i < 6){
            pixcel_mask <<= 1;
        }
        data_mask <<= 1;
    }
    data[num_secret] &= data_mask;
    data[num_secret] |= pixcel_mask;
}