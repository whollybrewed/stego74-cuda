#include "decoder.h"
  
void decode(unsigned char *p, const int secret_size)
{
    int i,j;
    const int num_secret = secret_size;
    const int num_group = secret_size/7;
    const int remain = secret_size % 7;
    //int p[7]={14,14,13,13,14,15,15};  //pixels
    unsigned char l[num_secret-remain+7];  //LSB
    unsigned char s[num_secret-remain+7];  //secret bits
    unsigned char z[num_group*3+3];  //syndrome
	// initialize z to 0
	for(i=0; i<num_group*3+3; i++)
		z[i] = 0;
    
    for(i=0; i<num_secret-remain; i++) {
        //printf("%d ",p[i]);
        l[i] = p[i]&1;
        //printf("%d\n",l[i]);
    }
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
    //deal with the remainder
    if(remain>0){
        for(j=num_secret-remain+6; j>=num_secret-remain; j--){
            l[j] = p[num_secret-1]&1;
            p[num_secret-1] = p[num_secret-1]>>1;
        }
        for(i=0; i<7; i++){
            z[num_group*3] = z[num_group*3]^(matrix_h[0][i]*l[num_secret-remain+i]);
            z[num_group*3+1] = z[num_group*3+1]^(matrix_h[1][i]*l[num_secret-remain+i]);
            z[num_group*3+2] = z[num_group*3+2]^(matrix_h[2][i]*l[num_secret-remain+i]);
        }
        s[num_group*7] = z[num_group*3];
        s[num_group*7+1] = z[num_group*3+1];
        s[num_group*7+2] = l[num_group*7+2];
        s[num_group*7+3] = z[num_group*3+2];
        s[num_group*7+4] = l[num_group*7+4];
        s[num_group*7+5] = l[num_group*7+5];
        s[num_group*7+6] = l[num_group*7+6];
    }
    printf("in after\n");
    printf("%d\n",secret_size);
    char* message = (char*)malloc((secret_size/8)*sizeof(char)+1);
    for(int n=0; n<50; n++) {
        printf("%d ",s[n]);
    }
    printf("\n");
    BitsToString(s, secret_size, message);
    printf("string after\n");
    message[secret_size/8] = '\0';
    printf("message = %s\n", message);
    free(message);
    return;
}

void BitsToString(unsigned char* bits, int bits_size, unsigned char* string)
{
    for(int n=0; n<bits_size; n++) {
        string[n] = 0;
        // for (int j = 0; j < 8; j++)
        //     printf("%d",bits[8*n+j]);
        // printf("\n");
        for (int j = 0; j < 8; j++){
            string[n] += bits[8*n+j];
            if(j != 7)
                string[n] = string[n] << 1;
            //printf("%d ",string[n]);
        }
    }
}