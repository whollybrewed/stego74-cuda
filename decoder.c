#include <stdio.h>
#include <stdlib.h>

int main()
{
        int i;
        int p[7];
        int l[7];
        int s[7];
        int H[3][7];
        int z[3] = {0};
        H[0] = {1,0,1,0,1,0,1};
        H[1] = {0,1,1,0,0,1,1};
        H[2] = {0,0,0,1,1,1,1};
        for(i=0; i<7; i++)
                l[i] = p[i]&1;
        //HxL=z
        for(i=0; i<7; i++){
                z[0] = z[0]^(H[0][i]*l[i]);
                z[1] = z[1]^(H[1][i]*l[i]);
                z[2] = z[2]^(H[2][i]*l[i]);
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
