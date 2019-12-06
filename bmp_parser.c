#include "bmp_parser.h"
void ReadFile(char* filename, struct BmpParser* parser)
{
    FILE* f = fopen(filename, "rb");
    fread(parser->header, sizeof(unsigned char), 54, f); // read the 54-byte header
    int data_offset = *(int*)&parser->header[10];
    parser->width = *(int*)&parser->header[18];
    parser->height = *(int*)&parser->header[22];
    int plane = *(int*)&parser->header[28];
    printf("offset = %d, w = %d, h = %d, p = %d\n", data_offset, parser->width, parser->height, plane);
    parser->palette_size = data_offset-54;
    if ( parser->palette_size ) {
        printf("Palatte\n");
        parser->palette = (unsigned char*) malloc(parser->palette_size); 
        fread(parser->palette, sizeof(unsigned char), parser->palette_size, f);
    }
    int size = plane * parser->width * parser->height;
    parser->data_size = size;
    parser->data = (unsigned char*) malloc(size*sizeof(unsigned char)); 
    fread(parser->data, sizeof(unsigned char), size, f); // read the rest of the data at once
    fclose(f);

    /*for(int i = 0; i < size; ++i)
    {
        if ( parser->data[i] > 250 )
            parser->data[i] = 230;
    }*/
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