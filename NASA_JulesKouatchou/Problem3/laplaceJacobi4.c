/*
 	This program solves Laplace's equation on the unit square.
        It relies on a fourth-order compact finite difference scheme and
 	uses the Jacobi iterative solver.
 
 	The BCs are Dirichlet with u(B) = 0 except u(x = 1, y) = 1.
 
 	In u(x_i,y_j) = u_ij = u[j][i], x[i] runs from xmin to xmax & y[j] runs
 	from ymin to ymax:
 		x = xmin + i*dx;
 		y = ymin + j*dy;
*/

#include <sys/types.h>
#include <time.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define MAX_SWEEPS	10000000

typedef struct {
	int N;
	double dx, xmin, xmax;
	double dy, ymin, ymax;
	double h;
	double omega, EPSILON;
} GRID;


double **allocate2d(int x, int y);
double timeStep4_Jacobi(GRID *grid, double *u[]);
void zero_matrix(GRID *grid, double *u[]);
void implement_BCs(GRID *grid, double *u[]);

int main( int argc, char *argv[] )
{
	double **u;
	GRID grid;
	double xmin = 0., xmax = 1.;
	double ymin = 0., ymax = 1.;
	double err, h, mu;
	double epsilon = 1.e-6;
	int N, i, sweep;
	char c[100];
        clock_t start, finish;

        // --------------------------------------------------
        // Get the number of grid points along each dimension
        // --------------------------------------------------
        if (argc == 2)
        {
           N = atoi(argv[1]);
        }
        else
        {
           printf("Usage: \n");
           printf("    %s dim \n", argv[0]);
           exit(-1);
        }

        start = clock();

        // ------------------------------
        // Allocate and initialize arrays
        // ------------------------------
	grid.N = N;
	grid.dx = (xmax-xmin)/N;
	grid.dy = (ymax-ymin)/N;
	h = grid.h = grid.dx;
	grid.xmin = xmin;
	grid.xmax = xmax;
	grid.ymin = ymin;
	grid.ymax = ymax;
	grid.EPSILON = epsilon*sqrt(h);

        u = allocate2d(N, N);

	zero_matrix(&grid, u);
	implement_BCs(&grid, u);
 
        err = 1000.0;

        // -----------------------------
        // Perform the Jacobi iterations
        // -----------------------------
        for (sweep = 0; sweep<MAX_SWEEPS && err > grid.EPSILON; sweep++) {
                  err = timeStep4_Jacobi(&grid, u);
        }

        finish = clock();
        printf("     Number of sweeps (%d): \n", sweep);
        printf("Time Jacobi Iteration (%d): %lf s\n", N, (double) (finish - start)/CLOCKS_PER_SEC);

	return 0;
}

double **allocate2d(int x, int y)
{
  int i;
  double **array = malloc(sizeof(double *) * x + sizeof(double) * x * y);
  for (i = 0; i < x; i++)
  {
    array[i] = ((double *)(array + x)) + y * i;
  }
  return array;
}

void zero_matrix(GRID *grid, double *u[])
{
	int N = grid->N, i, j;

	for (i = 0; i < N; i++) {
	    for (j = 0; j < N; j++) {
		u[i][j] = 0.;
            }
	}
}

void implement_BCs(GRID *grid, double *u[])
{
        int N = grid->N, i, j;
        double xmin = grid->xmin;
        double h = grid->h;
        double x;
        const double pi = 4. * atan(1.);

        for (j = 0; j < N; j++) {
                x = xmin + j*h;
                u[j][0] = sin(pi*x);
                u[j][N] = sin(pi*x)*exp(-pi);
        }
}

double timeStep4_Jacobi(GRID *grid, double *u[])
{
	int N = grid->N;
	double tmp, diff;
        int i, j;
        double err;

        err = 0.;

	for (i = 1; i < N-1; i++) {
		for (j = 1; j < N-1; j++) {
                        tmp = u[j][i];
                        u[j][i] = ( 4.*(u[j-1][i] + u[j+1][i] +
                                        u[j][i-1] + u[j][i+1]) + 
                                        u[j-1][i-1] + u[j+1][i+1] +
                                        u[j+1][i-1] + u[j-1][i+1])/20.;          
                        diff = u[j][i] - tmp;
                        err += diff*diff;
		}
	}
        return err;
}
