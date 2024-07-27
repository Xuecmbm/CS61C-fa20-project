/************************************************************************
**
** NAME:        imageloader.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**              Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-15
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <string.h>
#include "imageloader.h"

//Opens a .ppm P3 image file, and constructs an Image object. 
//You may find the function fscanf useful.
//Make sure that you close the file with fclose before returning.
Image *readData(char *filename) 
{
	//YOUR CODE HERE
    FILE *file = fopen(filename, "r");
    if (file == NULL) {
        printf("Error opening file %s\n", filename);
        return NULL;
    }

    char header[3];
    int width, height, maxval;

    // Read and check the header
    if (fgets(header, sizeof(header), file) == NULL) {
        printf("Failed to read file header\n");
        fclose(file);
        return NULL;
    }
    if (strncmp(header, "P3", 2) != 0) {
        printf("Invalid file format: %s\n", header);
        fclose(file);
        return NULL;
    }

    // Read the next three integers
    if (fscanf(file, "%d %d %d", &width, &height, &maxval) != 3) {
        printf("Failed to read width, height, and maxval\n");
        fclose(file);
        return NULL;
    }
    
    Image *image = (Image *)malloc(sizeof(Image));
    image->rows = height;
    image->cols = width;
    image->image = (Color **)malloc(sizeof(Color *) * width * height);
    Color **now = image->image;
    
    for(int i = 0; i < height; i++){
        for(int j = 0; j < width; j++){
            Color* p = (Color *)malloc(sizeof(Color));
            int r, g, b;
            fscanf(file, "%d %d %d", &r, &g, &b);
            p->R = r;
            p->G = g;
            p->B = b;
            *now = p;
            now++;
        }
    }

    fclose(file);
    return image;
}

//Given an image, prints to stdout (e.g. with printf) a .ppm P3 file with the image's data.
void writeData(Image *image)
{
	//YOUR CODE HERE
    int width = image->cols, height = image->rows;
    printf("P3\n%d %d\n255\n", width, height);
    Color **color = image->image;

    for(int i = 0; i < height; i++){
        for(int j = 0; j < width; j++){
	    Color *temp = *color;
	    color++;
	    if(j != 0)printf("   ");
	    printf("%3d %3d %3d", temp->R, temp->G, temp->B);
	}
	printf("\n");
    }
}

//Frees an image
void freeImage(Image *image)
{
	//YOUR CODE HERE
    int width = image->cols, height = image->rows;
    Color **color = image->image;

    for(int i = 0; i < height; i++){
        for(int j = 0; j < width; j++){
	    Color *temp = *color;
	    free(temp);
	    color++;
	}
    }
    free(image->image);
    free(image);
}
