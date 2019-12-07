#ifndef _BMP_PARSER
#define _BMP_PARSER

#include <stdio.h>
#include <stdlib.h>

struct BmpParser {
    int width, height, data_size, palette_size;
    unsigned char header[54];
    unsigned char *palette;
    unsigned char *data;
};

bool ReadFile(char* filename, struct BmpParser* parser);
void OutputFile(char* filename, struct BmpParser* parser);

#endif
