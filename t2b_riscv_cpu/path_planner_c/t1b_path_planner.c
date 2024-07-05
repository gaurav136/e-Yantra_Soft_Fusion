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
    // for (int i = 0; i < idx; i++) {
    //     map[i] = i; // store data starting from memory location 3
    // }
    map[0] = 1; map[1] = 1; map[2] = 1; map[3] = 1;
    map[4] = 0; map[5] = 2; map[6] = 29; map[7] = 29;
    map[8] = 1; map[9] = 3; map[10]= 8; map[11] =8;
    map[12] = 2; map[13] = 2; map[14] = 4; map[15] = 28;
    map[16] = 3; map[17] = 5; map[18] = 6; map[19] = 6;
    map[20] = 4; map[21] = 4; map[22]= 4; map[23] =4;
    map[24] = 4; map[25] = 7; map[26] = 7; map[27] = 7;
    map[28] = 6; map[29] = 8; map[30] = 8; map[31] = 8;
    map[32] = 2; map[33] = 7; map[34]= 9; map[35] = 12;
    map[36] = 8; map[37] = 10; map[38] = 11; map[39] = 11;
    map[40] = 9; map[41] = 9; map[42] = 9; map[43] = 9;
    map[44] = 9; map[45] = 9; map[46]= 9; map[47] =9;
    map[48] = 8; map[49] = 13; map[50] = 19; map[51] = 19;
    map[52] = 12; map[53] = 14; map[54] = 14; map[55] = 14;
    map[56] = 13; map[57] = 15; map[58]= 16; map[59] =16;
    map[60] = 14; map[61] = 14; map[62] = 14; map[63] = 14;
    map[64] = 14; map[65] = 17; map[66] = 18; map[67] = 18;
    map[68] = 16; map[69] = 16; map[70]= 16; map[71] =16;
    map[72] = 16; map[73] = 19; map[74] = 19; map[75] = 19;
    map[76] = 12; map[77] = 18; map[78] = 20; map[79] = 20;
    map[80] = 19; map[81] = 21; map[82]= 24; map[83] =29;
    map[84] = 20; map[85] = 22; map[86] = 23; map[87] = 23;
    map[88] = 21; map[89] = 21; map[90] = 21; map[91] = 21;
    map[92] = 21; map[93] = 21; map[94]= 21; map[95] =21;
    map[96] = 20; map[97] = 25; map[98] = 25; map[99] = 25;
    map[100] = 24; map[101] = 26; map[102] = 26; map[103] = 26;
    map[104] = 25; map[105] = 27; map[106]= 28; map[107] =28;
    map[108] = 26; map[109] = 26; map[110] = 26; map[111] = 26;
    map[112] = 3; map[113] = 26; map[114] = 29; map[115] = 29;
    map[116] = 1; map[117] = 20; map[118]= 28; map[119] = 28;

    // the node values are written into data memory sequentially.
    for (int i = 0; i < idx; ++i) {
        NODE_POINT = map[i];
    }

    // Path Planning Computation Done Flag
    CPU_DONE =  0xFFFFFFFF;

    return 0;
}
