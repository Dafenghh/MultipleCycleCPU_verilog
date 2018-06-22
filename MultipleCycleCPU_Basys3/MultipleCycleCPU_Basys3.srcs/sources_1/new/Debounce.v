`timescale 1ns / 1ps

module Debounce(
        input CLK,
        input signal,
        output out
    );
    reg delay1,delay2,delay3;  
    assign out = delay1&delay2&delay3;
    always@(posedge CLK)
    begin
        delay1 <= signal;
        delay2 <= delay1;
        delay3 <= delay2;
    end
endmodule
