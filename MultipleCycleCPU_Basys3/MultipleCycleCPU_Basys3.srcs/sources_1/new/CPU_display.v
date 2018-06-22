`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/20 18:14:38
// Design Name: 
// Module Name: bcd_scan_display
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


module CPU_display(
    input clk_fpga,
    input step_button,
    input Reset,
    input [1:0] sw_in,
    output reg [6:0] seven_seg,
    output reg [3:0] position,
    output reg [2:0] status
    );
    wire [6:0] seven_seg_temp;
    wire [3:0] position_temp;
    wire [2:0] status_temp;
    always@(seven_seg_temp) begin
        seven_seg = seven_seg_temp;
    end
    
    always@(position_temp) begin
        position = position_temp;
    end
    
    always@(status_temp) begin
        status = status_temp;
    end
    
    wire clk_cpu;
/*    module Debounce(
            input CLK,
            input signal,
            output out
        );*/
      Debounce db(.CLK(clk_fpga), 
                  .signal(step_button),
                  .out(clk_cpu));
/*module MultipleCycleCPU(
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
                      ); */   

       wire [31:0] curPC,nextPC,ALUResult,DB;
       wire [4:0] rs;
       wire [31:0] ReadData1;
       wire [4:0] rt;
       wire [31:0] ReadData2;

       MultipleCycleCPU cpu(.CLK(clk_cpu),
                          .RST(Reset),
                          .curPC(curPC),
                          .nextPC(nextPC),
                          .ALUResult(ALUResult),
                          .DB(DB),
                          .rs(rs),
                          .ADR_out(ReadData1),
                          .rt(rt),
                          .BDR_out(ReadData2),
                          .status(status_temp));
        reg [15:0] data_display;
        initial begin
            data_display = 0;
        end
        always@(sw_in or curPC or nextPC or ALUResult or DB or rs or ReadData1 or rt or ReadData2) begin
            case(sw_in) 
                0: 
                    begin
                        data_display[15:8] = curPC[7:0];
                        data_display[7:0] = nextPC[7:0];
                    end
                1:
                    begin
                        data_display[15:13] = 0;
                        data_display[12:8] = rs[4:0];
                        data_display[7:0] = ReadData1[7:0];
                    end                
                2:
                    begin
                        data_display[15:13] = 0;
                        data_display[12:8] = rt[4:0];
                        data_display[7:0] = ReadData2[7:0];
                    end   
                3:
                    begin
                        data_display[15:8] = ALUResult[7:0];
                        data_display[7:0] = DB[7:0];
                    end
            endcase
        end
/*
    module bcd_scan_display(
        input clk_fpga,
        input [15:0] data,
        output reg [6:0] seven_seg,
        output reg [3:0] position
    );*/
    bcd_scan_display scan(.clk_fpga(clk_fpga),
                          .data(data_display),
                          .seven_seg(seven_seg_temp),
                          .position(position_temp));
 
endmodule