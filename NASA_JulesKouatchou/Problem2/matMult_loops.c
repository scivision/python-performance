/*
 **********************************************************
 Given two nxn matrices A and B, we perform:
       C = A x B
 **********************************************************
*/

#include <sys/types.h>
#include <time.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>



int main( int argc, char *argv[] )
{
        double **A, **B, **C;
	int i, j, k;
	int dim;
        clock_t start, finish; 
	double maxr;

        // ---------------------------------------
        // Get the dimension from the command line
        // ---------------------------------------
        dim = atoi(argv[1]);

        // -------------------------------------
        // Allocate and initialize the matrices
        // -------------------------------------

        A = malloc(sizeof(double *) * dim);
        B = malloc(sizeof(double *) * dim);
        C = malloc(sizeof(double *) * dim);
        for (i = 0; i < dim; i++) {
            A[i] = malloc(sizeof(double) * dim);
            B[i] = malloc(sizeof(double) * dim);
            C[i] = malloc(sizeof(double) * dim);
        }

	srand(time(NULL));
	maxr = (double)RAND_MAX;
	for (i = 0; i < dim; i++) {
            for (j = 0; j < dim; j++) {
		A[i][j] = rand()/maxr;
		B[i][j] = rand()/maxr;
            }
        }

        // ---------------------------------
        // Compute the matrix multiplication
        // ---------------------------------
	start = clock();

	for (i = 0; i < dim; i++)
	{
		for (j = 0; j < dim; j++)
			C[i][j] = 0.;
		for (k = 0; k < dim; k++)
			for (j = 0; j < dim; j++)
				C[i][j] += A[i][k]*B[k][j];
	}
	finish = clock();

	printf("time for C(%d,%d) = A(%d,%d) B(%d,%d) is %lf s\n", dim, dim, dim, dim, dim, dim, (double) (finish - start)/CLOCKS_PER_SEC);	
	return 0;
}
