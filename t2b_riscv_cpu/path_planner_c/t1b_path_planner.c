#include <stdlib.h>
#include <stdint.h>

#define START_POINT         (* (volatile uint32_t * ) 0x02000000)
#define END_POINT           (* (volatile uint32_t * ) 0x02000004)
#define NODE_POINT          (* (volatile uint32_t * ) 0x02000008)
#define CPU_DONE            (* (volatile uint32_t * ) 0x0200000c)
#define MAP                 ((volatile uint32_t * )  0x02000010)


int main() {
    // Wire values 10 and 30 to START_POINT and END_POINT respectively
    START_POINT = 10;
    END_POINT = 30;

    CPU_DONE =   0x00000000; // Initialize CPU_DONE to 0

    // Initialize the map pointer to start at memory location 3
    volatile uint32_t *map = MAP;

    uint8_t idx = 120;
    for (int i = 0; i < idx; i++) {
        map[i] = i; // store data starting from memory location 3
    }

    // the node values are written into data memory sequentially.
    for (int i = 0; i < idx; ++i) {
        NODE_POINT = map[i];
    }

    // Path Planning Computation Done Flag
    CPU_DONE =  0xFFFFFFFF;

    return 0;
}
