`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SYSU
// Engineer: Dafeng
// 
// Create Date: 2018/05/31 13:29:48
// Design Name: 
// Module Name: SingleCycleCPU
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


module MultipleCycleCPU(
        input CLK,
        input RST,
        output [31:0] curPC,
        output [31:0] nextPC,
        output [31:0] DB,
        output [31:0] ALUResult,
        output [4:0] rs,
        output [4:0] rt,
        output [31:0] ADR_out,
        output [31:0] BDR_out,
        output [2:0] status  
    );

    wire [31:0] instruction;
    wire zero, sign, PCWre, ALUSrcA, ALUSrcB, DBDataSrc, RegWre, WrRegDSrc, InsMemRW, mRD, mWR, IRWre, ExtSel;   
    wire [1:0] PCSrc;
    wire [1:0] RegDst;// extend
    wire [2:0] ALUOp;   // modified 
    wire [5:0] op;
    wire [4:0] rd, sa;
    wire [15:0] immediate;
    wire [31:0] extendImmediate;
    wire [25:0] addr;
    
    assign op = instruction[31:26];
    assign rs = instruction[25:21];
    assign rt = instruction[20:16];
    assign rd = instruction[15:11];
    assign sa = instruction[10:6];
    assign immediate = instruction[15:0];
    assign addr = instruction[25:0];
    
    SignZeroExtend SignZeroExtend(.immediate(immediate),
                                  .ExtSel(ExtSel),
                                  .extendImmediate(extendImmediate));
    
/*
module RegisterFile(
       input CLK,               //clock
       input RegWre,
       input [4:0] rs,
       input [4:0] rt,
       input [4:0] rd,
       input [1:0] RegDst,
       input [31:0] WriteData, 
       output reg[31:0] ReadData1,
       output reg[31:0] ReadData2
    );

*/
    wire [31:0] ReadData1, ReadData2, PC4, IDataOut,ALUoutDR_out, DataOut;
    RegisterFile RegisterFile(.CLK(CLK),
                        .RegWre(RegWre),
                        .rs(rs),
                        .rt(rt),
                        .rd(rd),
                        .RegDst(RegDst),
                        .WriteData(WrRegDSrc ? DB : PC4),
                        .ReadData1(ReadData1),
                        .ReadData2(ReadData2));
/*
    module PC(
       input CLK,               //clock
       input Reset,             
       input PCWre,             
       input [1:0] PCSrc,            
       input [31:0] immediate,  
       input [25:0] addr,
       output reg [31:0] curPC, //current PC
       output reg [31:0] PC4,
       output reg [31:0] nextPC
    );
*/         
    PC PC(.CLK(CLK),
          .Reset(RST),
          .PCWre(PCWre),
          .PCSrc(PCSrc),
          .immediate(extendImmediate),
          .addr(addr),
          .curPC(curPC),
          .PC4(PC4),
          .nextPC(nextPC),
          .rs_val(ReadData1));     
          
          
    InsMEM InsMEM(.IAddr(curPC), 
          .RW(InsMemRW), 
          .IDataOut(IDataOut));    
/*
module IR(
        input CLK,
        input IRWre,
        input [31:0] instruction,
        output reg[31:0] out
    );
*/      
    IR IR(.CLK(CLK),
          .IRWre(IRWre),
          .instruction(IDataOut),
          .out(instruction));
    
/*
module DR(
  input CLK,
  input [31:0] data,
  output reg[31:0] out
  );*/ 
    DR ADR(.CLK(CLK), 
           .data(ReadData1),
           .out(ADR_out));
    DR BDR(.CLK(CLK), 
                  .data(ReadData2),
                  .out(BDR_out));
/*
module ALU(
    input [2:0] ALUOp,
    input [31:0] A,
    input [31:0] B,
    output reg [31:0] result,
    output zero,
    output sign
    );
*/

    ALU ALU(.ALUOp(ALUOp),
            .A(ALUSrcA ? sa : ADR_out),
            .B(ALUSrcB ? extendImmediate: BDR_out),
            .result(ALUResult),
            .zero(zero),
            .sign(sign));
            
    DR ALUoutDR(.CLK(CLK),
        .data(ALUResult),
        .out(ALUoutDR_out));
/*
module ControlUnit(
        input zero,
        input sign,
        input CLK,
        input RST,         
        input [5:0] op,     
        output reg PCWre, 
        output reg ALUSrcA,     
        output reg ALUSrcB,      
        output reg DBDataSrc, 
        output reg RegWre, 
        output reg WrRegDSrc, // new signal
        output reg InsMemRW, 
        output reg mRD,         
        output reg mWR, 
        output reg IRWre,  // new signal     
        output reg ExtSel,   
        output reg [1:0] PCSrc,  
        output reg [1:0] RegDst,  // extend
        output reg [2:0] ALUOp,    // modified 
        output reg [2:0] status  
    );
*/
                   
    ControlUnit ControlUnit(.zero(zero),
                            .sign(sign),
                            .CLK(CLK),
                            .RST(RST),
                            .op(op),
                            .PCWre(PCWre),
                            .ALUSrcA(ALUSrcA),
                            .ALUSrcB(ALUSrcB),   
                            .DBDataSrc(DBDataSrc),
                            .RegWre(RegWre),
                            .WrRegDSrc(WrRegDSrc),
                            .InsMemRW(InsMemRW),        
                            .mRD(mRD),
                            .mWR(mWR),
                            .IRWre(IRWre),
                            .ExtSel(ExtSel),
                            .PCSrc(PCSrc),
                            .RegDst(RegDst),
                            .ALUOp(ALUOp),
                            .status(status)
                            );
/*
module DataMEM(
    input CLK,
    input RD,
    input WR,
    input [31:0] DAddr,
    input [31:0] DataIn,
    output reg [31:0] DataOut
    );
*/

    DataMEM DataMEM(.RD(mRD),
                    .WR(mWR),
                    .CLK(CLK),
                    .DAddr(ALUoutDR_out),
                    .DataIn(BDR_out),
                    .DataOut(DataOut));
/*
module DR(
  input CLK,
  input [31:0] data,
  output reg[31:0] out
  );*/ 
    DR DBDR(.CLK(CLK),
            .data(DBDataSrc ? DataOut : ALUResult),
            .out(DB));
     
endmodule
