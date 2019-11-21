#include "grouping.h"
  
int main()
{
        int i;
        int p[7]={14,14,13,13,14,15,15};  //pixels
        int l[7];  //LSB
        int s[7];  //secret bits
        int z[3] = {0};  //syndrome
        for(i=0; i<7; i++)
                l[i] = p[i]&1;
        //HxL=z
        for(i=0; i<7; i++){
                z[0] = z[0]^(matrix_h[0][i]*l[i]);
                z[1] = z[1]^(matrix_h[1][i]*l[i]);
                z[2] = z[2]^(matrix_h[2][i]*l[i]);
        }
        s[0] = z[0];
        s[1] = z[1];
        s[2] = l[2];
        s[3] = z[2];
        s[4] = l[4];
        s[5] = l[5];
        s[6] = l[6];
        return 0;
}
