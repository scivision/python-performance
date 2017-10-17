#include <stdint.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define BILLION 1000000000L

int main(int argc, char** argv){
/* https://www.cs.rutgers.edu/~pxk/416/notes/c-tutorials/gettime.html */
    double volatile s = 0.;

    int N = 1000000;
    if (argc>1) {
        N = atoi(argv[1]);
    }

    printf("--> C\n");

	struct timespec start, end;
	
	#if (!defined(__APPLE__))
	  clock_gettime(CLOCK_MONOTONIC, &start);
	#endif  
	    
    for (int k=1; k<=N; k++) {
       s += pow(-1., k+1.) / (2.*k-1);
    }
    
    #if (!defined(__APPLE__))
      clock_gettime(CLOCK_MONOTONIC, &end);
    #endif
    
    uint64_t diff = BILLION * (end.tv_sec - start.tv_sec) + end.tv_nsec - start.tv_nsec;

    s = 4*s;

    if (fabs(s-M_PI)>1e-4) {
        fprintf(stderr,"C pisum: large error magnitude");
        return EXIT_FAILURE;
    }

    #if (!defined(__APPLE__))
      printf("pisum: %.2f milliseconds   pi=%f\n",(float) diff/1000000,s);
    #endif

    return EXIT_SUCCESS;
}


