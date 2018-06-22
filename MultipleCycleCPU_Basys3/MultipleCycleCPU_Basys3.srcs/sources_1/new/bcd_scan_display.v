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


module bcd_scan_display(
    input clk_fpga,
    input [15:0] data,
    output reg [6:0] seven_seg,
    output reg [3:0] position
    );

    
    wire [3:0] A, B, C, D;
    assign A = data[15:12];
    assign B = data[11:8];
    assign C = data[7:4];
    assign D = data[3:0];
    reg [3:0] counter;
    reg [3:0] digit;
    parameter zero = 7'b100_0000;
    parameter one = 7'b111_1001;
    parameter two = 7'b010_0100;
    parameter three = 7'b011_0000;
    parameter four = 7'b001_1001;
    parameter five = 7'b001_0010;
    parameter six = 7'b000_0010;
    parameter seven = 7'b111_1000;
    parameter eight = 7'b000_0000;
    parameter nine = 7'b001_0000;
    parameter ten = 7'b000_1000;
    parameter eleven = 7'b001_0011;
    parameter twelve = 7'b100_0110;
    parameter thirteen = 7'b010_0001;
    parameter fourteen = 7'b000_0110;
    parameter fifteen = 7'b000_1110;
    
    parameter MAX_COUNT = 99999;
    wire    counter_en;
    reg [27:0] counter_100M;

    always@ (posedge clk_fpga)
    begin
        if (counter_100M == MAX_COUNT)
            counter_100M <= 0;
        else
            counter_100M <= counter_100M + 1'b1;    
    end
    
    assign counter_en = counter_100M == 0;
    
    always @(digit)
    begin
        case(digit)
            0: seven_seg = zero;
            1: seven_seg = one;
            2: seven_seg = two;
            3: seven_seg = three;
            4: seven_seg = four;
            5: seven_seg = five;
            6: seven_seg = six;
            7: seven_seg = seven;
            8: seven_seg = eight;
            9: seven_seg = nine;
            10: seven_seg = ten;
            11: seven_seg = eleven;
            12: seven_seg = twelve;
            13: seven_seg = thirteen;
            14: seven_seg = fourteen;
            15: seven_seg = fifteen;
            default: seven_seg = 7'b111_1111;
        endcase
    end

    always @(posedge clk_fpga)
    begin
      if(counter_en)
        if (counter == 3)
               counter = 0;
        else
           counter = counter + 1'b1; 
    end

    always @(counter)
    begin
        case(counter)
            0: position = 4'b0111;
            1: position = 4'b1011;
            2: position = 4'b1101;
            3: position = 4'b1110;
            default: position = 4'b0111;
        endcase
    end

    always @(counter, A, B, C, D)
    begin
        case(counter)
            0: digit = A;
            1: digit = B;
            2: digit = C;
            3: digit = D;
            default: digit = A;
        endcase
    end   

endmodule