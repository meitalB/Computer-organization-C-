//311124283 Meital Birka
#include <stdio.h>
#include <stdlib.h>
#include <memory.h>

void  funcToReadAndWriteMission2(FILE* src, FILE* writeFile,
     char* writeNamefile, char* srcOsFlag, char* writeOsFlag, char* swap) {
    writeFile = fopen(writeNamefile, "wb");
    if (writeFile == NULL) {
        printf("open writing file is wrong");
    }
    int isWin = 0;
    char *readTemp = NULL;
    char *writeTemp = NULL;
    if ((srcOsFlag != NULL) && (writeOsFlag != NULL)) {
        if (strcmp(srcOsFlag, "-unix") == 0) {
            readTemp = (char *) "\n";
            if (strcmp(writeOsFlag, "-mac") == 0) {
                writeTemp = (char *) "\r";
            } else if (strcmp(writeOsFlag, "-win") == 0) {
                writeTemp = (char *) "\r\n";
                isWin = 1;
            } else if (strcmp(writeOsFlag, "-unix") == 0) {
                writeTemp = (char *) "\n";
            }

        } else if ((strcmp(srcOsFlag, "-mac") == 0)) {
            readTemp = (char *) "\r";
            if (strcmp(writeOsFlag, "-unix") == 0) {
                writeTemp = (char *) "\n";
            } else if (strcmp(writeOsFlag, "-win") == 0) {
                writeTemp = (char *) "\r\n";
                isWin = 1;
            } else if (strcmp(writeOsFlag, "-mac") == 0) {
                writeTemp = (char *) "\r";
            }
        } else if ((strcmp(srcOsFlag, "-win") == 0)) {
            readTemp = (char *) "\r\n";
            if (strcmp(writeOsFlag, "-unix") == 0) {
                writeTemp = (char *) "\n";
            } else if (strcmp(writeOsFlag, "-mac") == 0) {
                writeTemp = (char *) "\r";
            } else if (strcmp(writeOsFlag, "-win") == 0) {
                writeTemp = (char *) "\r\n";
                isWin = 1;
            }
        }
    }
        char *arr = (char *) malloc(2 * sizeof(char));
        if (arr == NULL) {
            printf("wrong");
            exit;
        }
        while ((fread(arr, 2, 1, src)) == 1) {
            if (writeTemp != NULL) {
                if (arr[0] == readTemp[0]) {
                    int i;
                    for (i = 0; i <= strlen(writeTemp); i = i + 2) {
                        if (isWin == 0) {
                            arr[i] = writeTemp[i];
                            arr[i + 1] = writeTemp[i + 1];
                        } else if (isWin == 1) {
                            if (i == 0) {
                                arr[0] = writeTemp[0];
                                arr[1] = 0;
                            } else if (i == 2) {
                                arr[0] = writeTemp[1];
                                arr[1] = 0;
                            }
                        }
                        if (swap != NULL) {
                            if (strcmp(swap, "-swap") == 0) {
                                char temp = arr[0];
                                arr[0] = arr[1];
                                arr[1] = temp;
                            }
                        }
                        fwrite(arr, 2, 1, writeFile);
                    }
                }else if((arr[0]==0)&&(isWin=1)){
                    if((strcmp(srcOsFlag,"-mac")||(strcmp(srcOsFlag,"-unix"))&&(arr[1]==readTemp[0]))){
                        int i;
                        for (i = 0; i <= strlen(writeTemp); i = i + 2) {
                            if (isWin == 0) {
                                arr[i] = writeTemp[i+1];
                                arr[i + 1] = writeTemp[i];
                            } else if (isWin == 1) {
                                if (i == 0) {
                                    arr[0] = 0;
                                    arr[1] = writeTemp[0];
                                } else if (i == 2) {
                                    arr[0] = 0;
                                    arr[1] = writeTemp[1];
                                }
                            }
                            if (swap != NULL) {
                                if (strcmp(swap, "-swap") == 0) {
                                    char temp = arr[0];
                                    arr[0] = arr[1];
                                    arr[1] = temp;
                                }
                            }
                            fwrite(arr, 2, 1, writeFile);
                        }
                    }else if((strcmp(srcOsFlag,"-mac")||(strcmp(srcOsFlag,"-unix"))&&(arr[1]!=readTemp[0]))) {
                        int i;
//                                char temp = arr[0];
//                                arr[0] = arr[1];
//                                arr[1] = temp;
                        if (swap != NULL) {
                            if (strcmp(swap, "-swap") == 0) {
                                char temp = arr[0];
                                arr[0] = arr[1];
                                arr[1] = temp;
                            }
                        }
                        fwrite(arr, 2, 1, writeFile);


                    }
                } else if (arr[0] != readTemp[1]) {
                    if (swap != NULL) {
                        if (strcmp(swap, "-swap") == 0) {
                            char temp = arr[0];
                            arr[0] = arr[1];
                            arr[1] = temp;
                        }
                    }
                    fwrite(arr, 2, 1, writeFile);

                }
            } else {
                if (swap != NULL) {
                    if (strcmp(swap, "-swap") == 0) {
                        char temp = arr[0];
                        arr[0] = arr[1];
                        arr[1] = temp;
                    }
                }
                fwrite(arr, 2, 1, writeFile);
            }
        } free(arr);


        fclose(writeFile);


}
int main(int argc, char *argv[]) {

    int numOfPArameters = argc;
    if (numOfPArameters == 1) {
        return 0;
    }
    if (numOfPArameters == 4) {
        return 0;
    }
    if (numOfPArameters >= 3) {
        FILE *srcFile;
        srcFile = fopen(argv[1], "rb");
        if (srcFile == NULL) {
            return 0;
        }
        FILE *writeFile = NULL;

        if (numOfPArameters == 3) {
            funcToReadAndWriteMission2(srcFile, writeFile,
                                       argv[2], NULL, NULL, NULL);
        } else if (numOfPArameters == 5) {
            char *srcOsFlag = argv[3];
            char *writeOsFlag = argv[4];
            funcToReadAndWriteMission2(srcFile, writeFile,
                                       argv[2], srcOsFlag, writeOsFlag, NULL);
        } else if (numOfPArameters == 6) {
            char *srcOsFlag = argv[3];
            char *writeOsFlag = argv[4];
            char *swap = argv[5];
            funcToReadAndWriteMission2(srcFile, writeFile,
                                       argv[2], srcOsFlag, writeOsFlag, swap);
        }
        fclose(srcFile);
    }

    return 0;
}