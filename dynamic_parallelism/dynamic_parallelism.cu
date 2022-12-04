#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <stdlib.h>

__global__ void dynamic_parallelism_check(int size, int depth)
{
    printf(" Depth : %d - tid : %d \n", depth, threadIdx.x);

    if (size == 1)
        return;

    if (threadIdx.x == 0)
    {
        dynamic_parallelism_check<<<1, size / 2>>>(size / 2, depth + 1);
    }
}

int main(int argc, char **argv)
{
    // nvcc -arch=sm_61 -rdc=true -o build/cuda_bin dynamic_parallelism.cu
    dynamic_parallelism_check<<<1, 16>>>(16, 0);
    cudaDeviceSynchronize();
    cudaDeviceReset();
    return 0;
}