`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/19 14:23:34
// Design Name: 
// Module Name: TestSingleCycleCpu
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

module TestSingleCycleCpu();
/*
module MultipleCycleCPU(
         CLK,
         RST,
        output [31:0] curPC,
        output [31:0] nextPC,
        output [31:0] instruction,
        output [31:0] DB,
        output [31:0] ALUResult,
        output [31:0] ADR_out,
        output [31:0] BDR_out,
        output zero,
        output sign,   
        output PCWre, 
        output ALUSrcA,     
        output ALUSrcB,      
        output DBDataSrc, 
        output RegWre, 
        output WrRegDSrc, // new signal
        output InsMemRW, 
        output mRD,         
        output mWR, 
        output IRWre,  // new signal     
        output ExtSel,   
        output [1:0] PCSrc,  
        output [1:0] RegDst,  // extend
        output [2:0] ALUOp,    // modified 
        output [2:0] status  
    );
*/

        reg CLK,RST;
        wire [31:0] curPC,nextPC,instruction,DB, ALUResult,ADR_out,BDR_out;
        wire zero, sign, PCWre, ALUSrcA, ALUSrcB, DBDataSrc, RegWre, WrRegDSrc, InsMemRW, mRD, mWR, IRWre, ExtSel;   
        wire [1:0] PCSrc;
        wire [1:0] RegDst;// extend
        wire [2:0] ALUOp;   // modified 
        wire [2:0] status;
	
	   
	  MultipleCycleCPU cpu(.CLK(CLK),
                .RST(RST),
                .curPC(curPC),
                .nextPC(nextPC),
                .instruction(instruction),
                .DB(DB),
                .ALUResult(ALUResult),
                .ADR_out(ADR_out),
                .BDR_out(BDR_out),
                .zero(zero),
                .sign(sign),   
                .PCWre(PCWre), 
                .ALUSrcA(ALUSrcA),     
                .ALUSrcB(ALUSrcB),      
                .DBDataSrc(DBDataSrc), 
                .RegWre(RegWre), 
                .WrRegDSrc(WrRegDSrc), // new signal
                .InsMemRW(InsMemRW), 
                .mRD(mRD),         
                .mWR(mWR), 
                .IRWre(IRWre),  // new signal     
                .ExtSel(ExtSel),   
                .PCSrc(PCSrc),  
                .RegDst(RegDst),  // extend
                .ALUOp(ALUOp),    // modified 
                .status(status));
	
    initial begin
 // Initialize s
           CLK = 1;
           RST = 0;
           CLK = !CLK;  // 下降沿，使PC先清零
           RST = 1;  // 清除保持信号
           forever #5
           begin // 产生时钟信号，周期为50s
                CLK = !CLK;
           end
    end
endmodule

