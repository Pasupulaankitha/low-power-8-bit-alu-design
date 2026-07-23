module alu (
    input  [7:0] A,
    input  [7:0] B,
    input  [3:0] sel,
    input        en,
    output reg [7:0] Result,
    output reg Carry,
    output reg Zero,
    output reg Overflow
);

reg [8:0] temp;

always @(*) begin
    // Default values
    Result   = 8'b00000000;
    Carry    = 1'b0;
    Zero     = 1'b0;
    Overflow = 1'b0;
    temp     = 9'b000000000;

    if (en) begin
        case(sel)

            4'b0000: begin          // Addition
                temp = A + B;
                Result = temp[7:0];
                Carry = temp[8];
                Overflow = (~(A[7]^B[7])) & (A[7]^Result[7]);
            end

            4'b0001: begin          // Subtraction
                temp = A - B;
                Result = temp[7:0];
                Carry = temp[8];
                Overflow = (A[7]^B[7]) & (A[7]^Result[7]);
            end

            4'b0010: Result = A & B;      // AND
            4'b0011: Result = A | B;      // OR
            4'b0100: Result = A ^ B;      // XOR
            4'b0101: Result = ~A;         // NOT
            4'b0110: Result = A << 1;     // Left Shift
            4'b0111: Result = A >> 1;     // Right Shift
            4'b1000: Result = A + 1;      // Increment
            4'b1001: Result = A - 1;      // Decrement
            4'b1010: Result = ~(A & B);   // NAND
            4'b1011: Result = ~(A | B);   // NOR
            4'b1100: Result = ~(A ^ B);   // XNOR
            4'b1101: Result = {A[6:0],A[7]}; // Rotate Left
            4'b1110: Result = {A[0],A[7:1]}; // Rotate Right
            4'b1111: Result = 8'b00000000;   // Clear

            default: Result = 8'b00000000;

        endcase

        if(Result == 8'b00000000)
            Zero = 1'b1;
    end
end

endmodule
