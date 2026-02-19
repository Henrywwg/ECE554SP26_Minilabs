//////////////////////////////////////////////////////////////////////////////////
// Company:         UW
// Engineer:        Henry Wysong-Grass
// 
// Create Date:     2026-02-12
// Design Name:     SPART (Special Purpose Asynchronous Receiver/Transmitter)
// Module Name:     spart 
//
// Revision: 
// Revision 1.00 - Dummy implementation
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////


module spart(
    input clk,
    input rst,
    input iocs,
    input iorw,
    output rda,
    output tbr,
    input [1:0] ioaddr,
    inout [7:0] databus,
    output txd,
    input rxd
    );
    // basically we just hook this up like the schematic shows us :3


    // instantiate receiver


    // instantiate transmitter


    // instantiate bus interface
    bus_interface iBUS(
        .databus(databus),
        .rda(rda),
        .tbr(tbr),
        .iocs(iocs),
        .iorw(iorw),
        .receive_buffer(), // from receiver to bus interface
        .ioaddr(ioaddr),
        .data_out() // from bus interface to driver
    );


    // instantiate baud rate generator
    baud_rate_generator iBAUD(
        .clk(clk),
        .rst(rst),
        .IOADDR(ioaddr),
        .DATABUS(databus),
        .enable() // to receiver and transmitter
    );



endmodule
