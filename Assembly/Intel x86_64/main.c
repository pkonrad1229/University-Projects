#include <stdio.h>
#include <stdlib.h>
#include "find_markers.h"
int main(int argc, char *argv[])
{
    FILE *file = fopen("source.bmp", "rb");
    if ( file == NULL )
    {
        printf ("Couldn't open input file\n" ) ;
        return -1 ;
    }
    fseek(file,0,SEEK_END);
    unsigned int size = ftell(file);
    rewind(file);
    unsigned char *bitmap = malloc(size);
    fread(bitmap, 1, size, file);
    rewind(file);
    fclose(file);

    unsigned int *x_pos = malloc(50*sizeof(int));
    unsigned int *y_pos = malloc(50*sizeof(int));
    int num_of_markers = find_markers(bitmap, x_pos, y_pos);
    int i;
    for (i=0; i<num_of_markers; i++)
    {
        printf("%d, %d\n", *(x_pos+i),*(y_pos+i));
    }
    return 0;
}
