`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/11 10:43:12
// Design Name: 
// Module Name: InsMEM
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


module InsMEM(
    input [31:0]IAddr,
    input RW,
    output reg[31:0] IDataOut
    );

    reg [7:0] Memory[0:127];

    initial begin
        $readmemb("D:/NEW/vivado/MultipleCycleCPU/romData.txt", Memory);
    end
    
    always @(IAddr or RW) begin
        if (RW) begin
            IDataOut[31:24] <= Memory[IAddr];
            IDataOut[23:16] <= Memory[IAddr + 1];
            IDataOut[15:8] <=  Memory[IAddr + 2];
            IDataOut[7:0] <= Memory[IAddr + 3];
        end
    end
endmodule
