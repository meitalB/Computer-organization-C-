//311124283 Meital Birka

#include "ex1.h"
int is_little_endian(){
    long num=1;
    char* pointer;
    pointer=(char*)&num;
    if(pointer[0]==1){
        return 1;
    }
    return 0;
}
unsigned long merge_bytes(unsigned long x, unsigned long int y) {
    unsigned long newNum = x;
    unsigned long leastSignificantByteY;//data of least significant byte
    char *pointer = (char *) &newNum;
    if (is_little_endian() == 1) {//little endian
        leastSignificantByteY = *((char *) &y);
        pointer[0] = leastSignificantByteY;
        return newNum;
    } else {//big endian
        int sizeOfArrayNew = sizeof(pointer);
        char *pointerToY = (char *) &y;
        int sizeOfArrayY = sizeof(pointerToY);
        leastSignificantByteY = pointerToY[sizeOfArrayY - 1];
        pointer[sizeOfArrayNew - 1] = leastSignificantByteY;
    }
    return newNum;
}
unsigned long put_byte(unsigned long x, unsigned char b, int i){
    unsigned long newNum = x;
    char *pointer = (char *) &newNum;
    if (is_little_endian() == 1) {//little endian******
        pointer[i] = b;
        return newNum;
    } else {//big endian
        int sizeOfArrayNew = sizeof(pointer)-1;
        pointer[sizeOfArrayNew - i] = b;
    }
    return newNum;
}



