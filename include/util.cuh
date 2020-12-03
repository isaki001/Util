#ifndef gpuprint_util_h
#define gpuprint_util_h

#include <stdio.h>
#include <iostream>
#include <stdarg.h>
#include <string>
#include <array>

template <class T, size_t numArrays>
void
display(size_t arraySize, ...)
{
    va_list params;
    va_start(params, arraySize);
    
    std::array<T*, numArrays> hArrays;
    
    for(int i=0; i<numArrays; i++){
        hArrays[i] = (T*)malloc(sizeof(T) * arraySize);
        cudaMemcpy(hArrays[i], va_arg(params, T*), sizeof(T) * arraySize, cudaMemcpyDeviceToHost);
    }
    
    va_end(params);
    
    for(size_t j = 0; j < arraySize; j++){
        for (size_t i = 0; i < numArrays; ++i) {
            std::cout<< hArrays[i][j] << "\t";
        }                
        std::cout << std::endl;
    }
    
    for(int j = 0; j < numArrays; j++)
        free(hArrays[j]);
}
#endif