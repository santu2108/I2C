`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/23/2025 06:31:28 PM
// Design Name: 
// Module Name: i2c_top_tb
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


module i2c_top_tb();
reg clk,rst,enable,rd_wr;
reg [6:0]addr_top;
reg [3:0]data_in_top;
wire [3:0]data_out;
wire [3:0]slave_data_out;
//wire ready;
wire sda,scl;
 
// sda,scl
// Added clk_res in the main module
i2c_top test(clk,rst,addr_top,data_in_top,enable,rd_wr,data_out,slave_data_out,sda,scl);    

//clk<=0; rst <=1; addr_top <=7'b1010100; data_in_top <= 8'b01100110; enable <=0; rd_wr <=1;

initial begin
clk<=0; rst <=0; addr_top <=7'b0000110; data_in_top <= 4'b1101; enable <=0; rd_wr <=1;
end

always
#10 clk<=~clk;

//#70 enable <=1;rst <=0;
//#330 $finish;

initial begin
#40 rst <=1; enable <=1;
#140 rst <=0;
#420 $finish;
end

endmodule
