/************************************************************************
**
** NAME:        steganography.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**				Justin Yokota - Starter Code
**				YOUR NAME HERE
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

//Determines what color the cell at the given row/col should be. This should not affect Image, and should allocate space for a new Color.
Color *evaluateOnePixel(Image *image, int row, int col)
{
	//YOUR CODE HERE
    int height = image->cols, width = image->rows;
    Color **color = image->image;
    color += (row * width + col);

    Color white = {255, 255, 255};
    Color black = {0, 0, 0};

    Color *res = (Color *)malloc(sizeof(Color));
    if (res == NULL) {
        printf("Failed to allocate memory for Color\n");
        return 1;
    }
    *res = black;
    if((*color)->B & 0x1) *res = white;

    return res;
}

//Given an image, creates a new image extracting the LSB of the B channel.
Image *steganography(Image *image)
{
	//YOUR CODE HERE
    int height = image->cols, width = image->rows;
    Color **color = image->image;

    Image *new_image = (Image *)malloc(sizeof(Image));
    new_image->rows = image->rows;
    new_image->cols = image->cols;
    new_image->image = (Color **)malloc(sizeof(Color *) * height * width);
    Color **new_color = new_image->image;

    for(int i = 0; i < height; i++){
        for(int j = 0; j < width; j++){
            Color *extract = evaluateOnePixel(image, i, j);        
            *new_color = extract;
            new_color++;
        }
    }    
    
    return new_image;
}

/*
Loads a file of ppm P3 format from a file, and prints to stdout (e.g. with printf) a new image, 
where each pixel is black if the LSB of the B channel is 0, 
and white if the LSB of the B channel is 1.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a file of ppm P3 format (not necessarily with .ppm file extension).
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!
*/
int main(int argc, char **argv)
{
	//YOUR CODE HERE
    if(argc < 2){
        printf("please input filename\n");
        return -1;
    }

    Image* image = readData(argv[1]);    
    if(!image){
        printf("read ppm file failed\n");
        return -1;
    }

    Image* new_image = steganography(image);
    writeData(new_image);

    freeImage(image);
    freeImage(new_image);
    return 0;
}
