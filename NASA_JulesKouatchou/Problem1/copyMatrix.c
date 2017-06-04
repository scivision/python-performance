
/*
 **********************************************************
 Given a nxnx3 matrix A, we want to perform the operations:

       A[i][j][0] = A[i][j][1]
       A[i][j][2] = A[i][j][0]
       A[i][j][1] = A[i][j][2]
 **********************************************************
*/

#include <sys/types.h>
#include <time.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

double*** Make3DDoubleArray(int arraySizeX, int arraySizeY, int arraySizeZ);

int main(int argc, char* argv[])
{
        double ***A;
	int dim, i, j, k;
        clock_t start, finish; 

	double maxr;

        // ---------------------------------------
        // Get the dimension from the command line
        // ---------------------------------------
        dim = atoi(argv[1]);

        // ------------------------------
        // Allocate the array and fill it
        // ------------------------------
        A = (double ***) malloc(dim * sizeof(double **));
        for (i = 0; i < dim; i++) {
            A[i] = (double **) malloc(dim * sizeof(double *));
            for (j = 0; j < dim; j++) {
                A[i][j] = (double *) malloc(3 * sizeof(double));
            }
        }

	srand(time(NULL));
	maxr = (double)RAND_MAX;
	for (i = 0; i < dim; i++)
		for (j = 0; j < dim; j++)
		    for (k = 0; k < 3; k++)
			A[i][j][k] = rand()/maxr;

        // ---------------------------
        // Perform the copy operations
        // ---------------------------
	start = clock();

	for (i = 0; i < dim; i++)
	{
            for (j = 0; j < dim; j++)
            {
                A[i][j][0] = A[i][j][1];
                A[i][j][2] = A[i][j][0];
                A[i][j][1] = A[i][j][2];
            }
	}
	finish = clock();

	printf("Time for matrix copy (%d): %lf s\n", dim, (double) (finish - start)/CLOCKS_PER_SEC);	
	return 0;
}

double*** Make3DDoubleArray(int arraySizeX, int arraySizeY, int arraySizeZ) {
     double*** theArray;
     int i, j;
     theArray = (double***) malloc(arraySizeX*sizeof(double**));
     for (i = 0; i < arraySizeX; i++){
        theArray[i] = (double**) malloc(arraySizeY*sizeof(double*));
        for (j = 0; j < arraySizeY; i++){
            theArray[i][j] = (double*) malloc(arraySizeZ*sizeof(double));
        }
     }
     return theArray;
}
