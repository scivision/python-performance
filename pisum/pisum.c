#include <stdint.h>
#define _USE_MATH_DEFINES  // needed for Windows
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

// need LL for Windows
#define BILLION 1000000000LL

int main(int argc, char** argv){
/* https://www.cs.rutgers.edu/~pxk/416/notes/c-tutorials/gettime.html */
    double volatile s = 0.;

    int N = 1000000;
    if (argc>1) {
        N = atoi(argv[1]);
    }

    int Nrun = 10;
    if (argc>2) {
       Nrun = atoi(argv[2]);
    }

    printf("--> C.  N=%d \n", N);

  #if (defined(__linux__))
    uint64_t tmin = BILLION;
    struct timespec start, end;
    uint64_t diff;
  #else
    double tmin = BILLION;
    clock_t start, end;
    double diff;
  #endif


  for (int i=1; i<=Nrun; i++) {

    s = 0.;

	  #if (defined(__linux__))
	    clock_gettime(CLOCK_MONOTONIC, &start);
    #else
      start = clock();
	  #endif

    for (int k=1; k<=N; k++) {
       s += pow(-1., k+1.) / (2.*k-1);
    }

    #if (defined(__linux__))
      clock_gettime(CLOCK_MONOTONIC, &end);
      diff = BILLION * (end.tv_sec - start.tv_sec) + end.tv_nsec - start.tv_nsec;
    #else
      end = clock();
      diff = end - start;
    #endif

    if (diff < tmin) tmin = diff;

  }

  s = 4*s;

  double err = fabs(s-M_PI);

  if (err>1e-4) {
      fprintf(stderr,"C pisum: large error magnitude %f",err);
      return EXIT_FAILURE;
  }

  #if (defined(__linux__))
    printf("%.3e seconds \n",(double) tmin / BILLION);
  #else
    printf("%.3e seconds \n",(double) tmin / CLOCKS_PER_SEC);
  #endif

  return EXIT_SUCCESS;
}


