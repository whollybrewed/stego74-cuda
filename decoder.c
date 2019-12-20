#include "decoder.h"
#include "convert.h"
#include "grouping.h"
  
void decode(unsigned char *p, const int secret_size)
{
        int i, j;
        const int num_secret = secret_size;
        const int num_group = (secret_size)/7;
        const int remain = (secret_size) % 7;
        unsigned char l[num_secret-remain+7];  //LSB
        unsigned char s[num_secret-remain+7];  //secret bits
        //unsigned char z[num_group*3+3];  //syndrome
        for(i=0; i<num_secret-remain+7; i++)
                s[i] = 0;
        for(i=0; i<num_secret; i++)
                l[i] = p[i]&1;
        //HxL=z
        for(j=0; j<num_group; j++){
                for(i=0; i<7; i++){
                        s[j*7] = s[j*7]^(matrix_h[0][i]*l[j*7+i]);
                        s[j*7+1] = s[j*7+1]^(matrix_h[1][i]*l[j*7+i]);
                        s[j*7+3] = s[j*7+3]^(matrix_h[2][i]*l[j*7+i]);
                }
        }
        for(j=0; j<num_group; j++){
                s[j*7+2] = l[j*7+2];
                s[j*7+4] = l[j*7+4];
                s[j*7+5] = l[j*7+5];
                s[j*7+6] = l[j*7+6];
        }
        //deal with the remainder
        if(remain>0){
                for(j=num_secret-remain+6; j>=num_secret; j--){
                        l[j] = p[num_secret]&1;
                        p[num_secret] = p[num_secret]>>1;
                }
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
    char* message = (char*)malloc((secret_size/8)*sizeof(char)+1);
    BitsToString(s, secret_size, message);
    message[secret_size/8] = '\0';
    printf("message = %s\n", message);
}
