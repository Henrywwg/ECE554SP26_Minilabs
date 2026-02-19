module receiver(
    input clk,
    input rst,
    input [1:0] IOADDR,
    input enable,
    input IOCS,
    input IORW,
    input RxD,
    output RDA,
    output [7:0] dout
);

    logic clk_baud;

    // Baud rate
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            clk_baud <= 0;
        end
        else begin
            if (enable) begin
                clk_baud <= !clk_baud;
            end
        end
    end

    always @(posedge clk_baud) begin

    end

endmodule