package snakePkg;
    parameter N_1039 = $clog2(1039);
    parameter N_665 = $clog2(665);

    parameter N_800 = $clog2(800);
    parameter N_600 = $clog2(600);

    typedef logic[7:0] byte_t;
    
    typedef enum {EQ, GT, LT, GE, LE} cmp_t; 
    
    typedef struct packed {
        logic[9:0] x;
        logic[9:0] y;
    }pt2D;

endpackage