`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/23/2025 06:30:17 PM
// Design Name: 
// Module Name: i2c_top
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


module i2c_top(
input clk,input rst,input [6:0]addr_top,input [3:0]data_in_top,input enable,input rd_wr, //top module signal
input clk_rst,
output [3:0] data_out,
output [3:0] slave_data_out,
inout sda, inout scl);

wire [3:0] master_data_out;
wire [3:0] rec_data_slave;
wire clk1;
clock_divider clk_div(clk,clk_rst,clk1);

i2c_master master(clk1,rst,addr_top,data_in_top,enable,rd_wr,master_data_out,sda,scl);
i2c_slave slave(sda,scl,rec_data_slave);

assign data_out = master_data_out;
assign slave_data_out = rec_data_slave;

endmodule
