`timescale 1ns / 1ps
module PC(
       input CLK,               //clock
       input Reset,             
       input PCWre,             
       input [1:0] PCSrc,            
       input [31:0] immediate,  
       input [25:0] addr,
       input [31:0] rs_val,
       output reg [31:0] curPC, //current PC
       output reg [31:0] PC4,
       output reg [31:0] nextPC
    );
    initial begin
        curPC <= 0;
        nextPC <= 0; 
    end
    

    always@(Reset or curPC or PCSrc or immediate or addr or rs_val)
    begin
        PC4 = curPC + 4;
        if(!Reset) begin
            nextPC = 0;
        end
        else begin
            case(PCSrc)
                2'b00: nextPC = curPC + 4;
                2'b01: nextPC = curPC + 4 + immediate * 4;
                2'b10: nextPC = rs_val;
                2'b11: nextPC = {PC4[31:28],addr,2'b00};
            endcase
            //$display("curPC, nextPC %x %x\n", curPC, nextPC);
        end
    end
    
    always@(posedge CLK or negedge Reset)
    begin
    
        if(!Reset) // Reset == 0
            begin
                curPC <= 0;
            end
        else 
            begin
                if(PCWre) // PCWre == 1
                    begin 
                        curPC <= nextPC;
                    end
                else    // PCWre == 0, halt
                    begin
                        curPC <= curPC;
                    end
            end
    end
endmodule