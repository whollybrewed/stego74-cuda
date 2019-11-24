#include "grouping.h"
  
void decode(unsigned char *p)
{
        int i;
        const int num_secret = height * width - 1;
        const int num_group = (height * width - 1)/7;
        const int remain = (height * width - 1) % 7;
        //int p[7]={14,14,13,13,14,15,15};  //pixels
        unsigned char l[num_secret];  //LSB
        unsigned char s[num_secret];  //secret bits
        unsigned char z[num_group*3+remain] = {0};  //syndrome
        for(i=0; i<num_secret; i++)
                l[i] = p[i]&1;
        //HxL=z
        for(j=0; j<num_group; j++){
                for(i=0; i<7; i++){
                        z[j*3] = z[j*3]^(matrix_h[0][i]*l[j*7+i]);
                        z[j*3+1] = z[j*3+1]^(matrix_h[1][i]*l[j*7+i]);
                        z[j*3+2] = z[j*3+2]^(matrix_h[2][i]*l[j*7+i]);
                }
        }
        for(j=0; j<num_group; j++){
                s[j*7] = z[j*3];
                s[j*7+1] = z[j*3+1];
                s[j*7+2] = l[j*7+2];
                s[j*7+3] = z[j*3+2];
                s[j*7+4] = l[j*7+4];
                s[j*7+5] = l[j*7+5];
                s[j*7+6] = l[j*7+6];
        }

        //deal with remainder, not yet completed
        if(remain>0) s[num_secret-remain] =
        if(remain>1) s[num_secret-remain+1] =
        if(remain>2) s[num_secret-remain+2] =
        if(remain>3) s[num_secret-remain+3] =
        if(remain>4) s[num_secret-remain+4] =
        if(remain>5) s[num_secret-remain+5] =

        return 0;
}
