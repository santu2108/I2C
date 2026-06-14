`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/23/2025 08:40:33 PM
// Design Name: 
// Module Name: clock_divider
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

module clock_divider(input clk,input res,output reg clk2);
reg [31:0]count;
 always@(posedge clk)
 if(res==1) begin
 count <=0; clk2 <=0;
 end
 else if(count==49999999) begin
 count <=0; clk2 <=~clk2;
 end
 else count <=count+1;
endmodule
