#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>
int main(int argc,char *argv[])
{
   int myproc,numproc;
   MPI_Init(&argc,&argv);
 
   MPI_Comm_rank(MPI_COMM_WORLD,&myproc);
   MPI_Comm_size(MPI_COMM_WORLD,&numproc);
 
   printf("%d %d\n",myproc,numproc);

   MPI_Finalize();
   fflush(stdout);
}
