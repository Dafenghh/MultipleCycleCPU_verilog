`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/15 20:23:45
// Design Name: 
// Module Name: IR
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module IR(
        input CLK,
        input IRWre,
        input [31:0] instruction,
        output reg[31:0] out
    );
    initial begin
        out = 0;
    end
    always@(posedge CLK) begin
        if (IRWre) begin
            out <= instruction;
        end
        else begin
            out <= out;
        end
    end
endmodule
