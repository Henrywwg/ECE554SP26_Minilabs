module grayscale(
    r,
    g,
    b,
    gray
);

input wire [11:0] r;
input wire [11:0] g;
input wire [11:0] b;
output wire [11:0] gray;    //width may have to be changed

// rough averaging - r/2 + g/4 + b/4
assign gray = r[11:1] + g[11:2] + b[11:2];

endmodule