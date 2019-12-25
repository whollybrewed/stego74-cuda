#include "bmp_parser.h"
int ReadFile(char* filename, struct BmpParser* parser)
{
    FILE* f = fopen(filename, "rb");
    fread(parser->header, sizeof(unsigned char), 54, f); // read the 54-byte header
    int data_offset = *(int*)&parser->header[10];
    parser->width = *(int*)&parser->header[18];
    parser->height = *(int*)&parser->header[22];
    int plane = *(int*)&parser->header[28];
    int compress = *(int*)&parser->header[30];
    if (compress) {
        printf("Compress!! Can not encode\n\n");
        return 0;
    }
    //printf("offset = %d, w = %d, h = %d, p = %d\n", data_offset, parser->width, parser->height, plane);
    parser->palette_size = data_offset-54;
    if ( parser->palette_size ) {
        parser->palette = (unsigned char*) malloc(parser->palette_size); 
        fread(parser->palette, sizeof(unsigned char), parser->palette_size, f);
    }
    int size = plane * parser->width * parser->height;
    parser->data_size = size;
    parser->data = (unsigned char*) malloc(size*sizeof(unsigned char)); 
    fread(parser->data, sizeof(unsigned char), size, f); // read the rest of the data at once
    fclose(f);
    return 1;
}

void OutputFile(char* filename, struct BmpParser* parser)
{
    FILE* f = fopen(filename, "wb");
    fwrite(parser->header, sizeof(unsigned char), 54, f);
    if ( parser->palette_size ) {
        fwrite(parser->palette, 1, parser->palette_size, f);
    }
    fwrite(parser->data, sizeof(unsigned char), parser->data_size, f);
    fclose(f);
}

void ReadTxt(char* filename, char* string, int size) 
{
    char tmp[10000];
    string[0] = '\0';
    FILE *file;
    file = fopen(filename, "r");
    if (file) {
        while (fgets(tmp, size, file) != NULL) {
            size -= strlen(tmp);
            if (size == 0 || strlen(tmp) == 0) break;
            strncat(string,tmp,10000);
        }
        fclose(file);
    }
}

void OutputTxt(char* filename, char* string)
{
    FILE *file;
    file = fopen(filename, "w");
    if (file) {
        fputs(string, file);
        fclose(file);
    }
}
