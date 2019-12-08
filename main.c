#include <stdio.h>
#include <stdlib.h>
#include "bmp_parser.h"
#include "embed.h"


int main(int argc, char* argv[])
{
    // bmp reader
    struct BmpParser encoder;
    ReadFile("photo/fluit.bmp", &encoder);
    // stego encoder
    embed(encoder.data, "Hello world, I am a handsome guy");
    // stego decoder
    return 0;
}