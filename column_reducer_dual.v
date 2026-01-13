module column_reducer_dual (
    input  wire        clk,
    input  wire        rst,

    input  wire        num_valid,
    input  wire [31:0] num_in,

    input  wire        op_valid,
    input  wire        op_in,   // 0 = add, 1 = mul

    input  wire        done,

    output reg         result_valid,
    output reg  [63:0] result
);

    reg [63:0] sum_acc;
    reg [63:0] prod_acc;
    reg        started;
    reg        op;

    always @(posedge clk) begin
        if (rst) begin
            sum_acc      <= 0;
            prod_acc     <= 1;
            started      <= 0;
            op           <= 0;
            result       <= 0;
            result_valid <= 0;
        end else begin
            result_valid <= 0;

            if (op_valid)
                op <= op_in;

            if (num_valid) begin
                if (!started) begin
                    sum_acc  <= num_in;
                    prod_acc <= num_in;
                    started  <= 1;
                end else begin
                    sum_acc  <= sum_acc + num_in;
                    prod_acc <= prod_acc * num_in;
                end
            end

            if (done) begin
                result       <= (op) ? prod_acc : sum_acc;
                result_valid <= 1;

                // reset for next column
                sum_acc  <= 0;
                prod_acc <= 1;
                started  <= 0;
            end
        end
    end
endmodule
