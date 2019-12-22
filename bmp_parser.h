#ifndef _BMP_PARSER
#define _BMP_PARSER

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct BmpParser {
    int width, height, data_size, palette_size;
    unsigned char header[54];
    unsigned char *palette;
    unsigned char *data;
};

int ReadFile(char* filename, struct BmpParser* parser);
void OutputFile(char* filename, struct BmpParser* parser);
void ReadTxt(char* filename, char* string, int size);
void OutputTxt(char* filename, char* string);

#endif
