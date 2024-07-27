/************************************************************************
**
** NAME:        gameoflife.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"
#include <string.h>

#define BITS 24
#define MOD(a, bit) ((a + bit) % (bit))
#define GET_BIT(value, position) (((value) >> (position)) & 1)

#define PACK_COLOR(color) \
    (((color).R << 16) | ((color).G << 8) | (color).B)

#define UNPACK_COLOR(packedColor, color) \
    do { \
        (color).R = ((packedColor) >> 16) & 0xFF; \
        (color).G = ((packedColor) >> 8) & 0xFF; \
        (color).B = (packedColor) & 0xFF; \
    } while (0)

int countsAlive(int *a, int bit){
    int res = 0;
    for(int i = 0; i < 8; i++){
	if (GET_BIT(a[i], bit)) res++;
    }
    return res;
}

//Determines what color the cell at the given row/col should be. This function allocates space for a new Color.
//Note that you will need to read the eight neighbors of the cell in question. The grid "wraps", so we treat the top row as adjacent to the bottom row
//and the left column as adjacent to the right column.
Color *evaluateOneCell(Image *image, int row, int col, uint32_t rule)
{
	//YOUR CODE HERE
    int directions[8][2] = {
        {-1, 0}, // 上
        {1, 0},  // 下
        {0, -1}, // 左
        {0, 1},  // 右
        {-1, -1}, // 上左
        {-1, 1},  // 上右
        {1, -1},  // 下左
        {1, 1}    // 下右
    };

    int width = image->cols, height = image->rows;
    Color **color = image->image;
    int colors_neighbors[8];

    for (int i = 0; i < 8; i++) {
        int tempRow = MOD(row + directions[i][0], height);
        int tempCol = MOD(col + directions[i][1], width);
	colors_neighbors[i] = PACK_COLOR(**(color + tempRow * width + tempCol));
    }
    
    int oldColor = PACK_COLOR(**(color + row * width + col));

    int newColor = 0;
    for(int i = 0; i < BITS; i++){
	int counts_alive = countsAlive(colors_neighbors, i);
	//rule中alive和dead间隔9
	int oldState = GET_BIT(oldColor, i) ? 9 : 0;
	int newState = GET_BIT(rule, oldState + counts_alive);
	
	newColor |= (newState << i);
    }

    Color *res = (Color *)malloc(sizeof(Color));
    UNPACK_COLOR(newColor, *res);
    return res;
}

//The main body of Life; given an image and a rule, computes one iteration of the Game of Life.
//You should be able to copy most of this from steganography.c
Image *life(Image *image, uint32_t rule)
{
	//YOUR CODE HERE
    int width = image->cols, height = image->rows;

    Image *new_image = (Image *)malloc(sizeof(Image));
    new_image->rows = image->rows;
    new_image->cols = image->cols;
    new_image->image = (Color **)malloc(sizeof(Color *) * height * width);
    Color **new_color = new_image->image;

    for(int i = 0; i < height; i++){
        for(int j = 0; j < width; j++){
            Color *iteration = evaluateOneCell(image, i, j, rule);        
            *new_color = iteration;
            new_color++;
        }
    }    
    
    return new_image;
}

/*
Loads a .ppm from a file, computes the next iteration of the game of life, then prints to stdout the new image.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a .ppm.
argv[2] should contain a hexadecimal number (such as 0x1808). Note that this will be a string.
You may find the function strtol useful for this conversion.
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!

You may find it useful to copy the code from steganography.c, to start.
*/
int main(int argc, char **argv)
{
	//YOUR CODE HERE
    if(argc < 3){
        printf("usage: ./gameOfLife filename rule\nfilename is an ASCII PPM file (type P3) with maximum value 255.\
	\nrule is a hex number beginning with 0x; Life is 0x1808.");
        return -1;
    }

    char *hexStr = argv[2];
    if (strncmp(hexStr, "0x", 2) != 0) {
        printf("Error: The input does not start with '0x'\
	        \nusage: ./gameOfLife filename rule\nfilename is an ASCII PPM file (type P3) with maximum value 255.\
		\nrule is a hex number beginning with 0x; Life is 0x1808.");
        return -1;
    }

    hexStr += 2;
    uint32_t rule = (uint32_t)strtoul(hexStr, NULL, 16);

    Image* image = readData(argv[1]);    
    if(!image){
        printf("read ppm file failed\n");
        return -1;
    }
    Image* new_image = life(image, rule);
    writeData(new_image);

    freeImage(image);
    freeImage(new_image);
    return 0;
}
