`timescale 1ns/1ps

module tb_column_reducer_dual;

    reg clk = 0;
    always #5 clk = ~clk;

    reg rst;
    reg num_valid;
    reg [31:0] num_in;
    reg op_valid;
    reg op_in;
    reg done;

    wire result_valid;
    wire [63:0] result;

    column_reducer_dual dut (
        .clk(clk),
        .rst(rst),
        .num_valid(num_valid),
        .num_in(num_in),
        .op_valid(op_valid),
        .op_in(op_in),
        .done(done),
        .result_valid(result_valid),
        .result(result)
    );

    initial begin
        $dumpfile("waves_dual.vcd");
        $dumpvars(0, tb_column_reducer_dual);

        rst = 1;
        num_valid = 0;
        op_valid  = 0;
        done      = 0;
        #20 rst = 0;

        // 123 * 45 * 6
        num_valid = 1; num_in = 123; #10;
        op_valid  = 1; op_in  = 1;   #10; op_valid = 0;

        num_in = 45; #10;
        num_in = 6;  #10;
        num_valid = 0;

        done = 1; #10;
        done = 0;

        #50;
        $finish;
    end
endmodule
