`timescale 1 ps / 1 ps

module m_tb();

    parameter NUM_ITERATIONS = 10;

    reg [7:0] A [0:7] [0:7];
    reg [7:0] B [0:7];
    wire [23:0] actualC [0:7];
    wire [23:0] expectedC [0:7];
    reg [23:0] zeroedC [0:7] = {24'h0, 24'h0, 24'h0, 24'h0, 24'h0, 24'h0, 24'h0, 24'h0};
    reg start;
    wire done;
    reg clk;
    reg rst_n;
    reg Clr;

    reg [9:0] timeout_counter;

    reg failed;

    // Instantiate DUT
    matvec_mult iDUT (
        .clk(clk), 
        .rst_n(rst_n), 
        .Clr(Clr), 
        .start(start), 
        .done(done), 
        .results(actualC));

    // Checker - see below
    matrix_mult expectedOutput(.A(A), .B(B), .C(expectedC), .clk(clk), .rst_n(rst_n));

    initial begin
        $display("Begin testing");

        // Reset Signals
        clk = 1'b0;
        rst_n = 1'b0;
        failed = 1'b0; // Innocent until proven guilty
        Clr = 1'b0;
        start = 1'b0;
        timeout_counter <= 0;
        //Only one test to run since we are given assigned matrices
        // Get ready for testing
        @(negedge clk);
        rst_n = 1'b1;
        @(negedge clk);
        Clr = 1'b1;
        @(negedge clk);
        Clr = 1'b0;
        start = 1'b1;
        @(negedge clk);
        start = 1'b0;

        // Wait for done signal to be asserted or until a timeout occurs
        while(!done && timeout_counter < 1000) begin
            @(negedge clk);
            timeout_counter <= timeout_counter + 1;
        end

        $display("Timeout Counter: %0d", timeout_counter);

        if(timeout_counter == 1000) begin
            $display("Test Failed: Timeout occurred before completion");
            failed = 1'b1;
        end
        else begin
            // Check results
            for (integer i = 0; i < 8; i = i + 1) begin
                if (actualC[i] !== expectedC[i]) begin
                    $display("Test Failed: Mismatch at index %0d. Expected: %h, Got: %h", i, expectedC[i], actualC[i]);
                    failed = 1'b1;
                end
            end
        end
        if (!failed) begin
            $display("Yahoo!! Test Passed!");
        end


        $stop();
    end

    always #5 clk = ~clk;


endmodule

module matrix_mult(
    input [7:0] A [0:7][0:7],
    input [7:0] B [0:7],
    input clk,
    input rst_n,
    output reg [23:0] C [0:7]
);
    integer i, j;

    reg [23:0] temp;

    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 8; i = i + 1) begin
                C[i] <= 24'h0;
            end
        end
        else begin
            for (i = 0; i < 8; i = i + 1) begin
                temp = 24'h000000;
                for (j = 0; j < 8; j = j + 1) begin
                    temp = temp + (A[i][j] * B[j]);
                end
                C[i] = temp;
            end 
        end
    end

endmodule