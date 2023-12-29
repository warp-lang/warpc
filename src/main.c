/*
 *  @author: dwclake
 */

#include <stdio.h>
#include <stdlib.h>
#include <sys/errno.h>
#include "../includes/compiler.h"

const char* prompt = "Cosmic compiler\n"
                     "version: 0.1.0\n"
                     "\n"
                     "Usage: cosmic-c [options] source\n";

int main(int argc, const char** argv) {
    /* Check if first argument was provided (required) */
    if (argv[1]) {
        const char* output = NULL;
        
        /* Check if second argument was provided (optional) */
        if (argv[2]) {
            output = argv[2];
        }

        int result = compile(argv[1], output, 0);
        switch (result) {
            case COMPILER_FILE_COMPILED_OK:
                printf("Compiled successfully\n");
                break;
            case COMPILER_FAILED_WITH_ERRORS:
                printf("Compilation failed with errors\n");
                break;
            case ENOENT:
                printf("Compilation failed. File not found: %s\n", argv[1]);
                return ENOENT;
                break;
            default: 
                printf("File compiled with unknown response\n");
                break;
        }
    } else {
        printf("%s", prompt);
    }
    
    return EXIT_SUCCESS;
}
