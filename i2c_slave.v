`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/23/2025 06:30:59 PM
// Design Name: 
// Module Name: i2c_slave
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


module i2c_slave(
inout sda, inout scl, output reg [3:0]recieved_data_slave);

//Adrress not synchronising by one bit
//See address
parameter address_slave = 7'b0000110;
parameter read_addr_state = 0;
parameter send_ack_state = 1;
parameter read_data_state = 2;
parameter write_data_state = 3;
parameter send_ack_2_state = 4;
parameter slave_stop_state = 5;
parameter read_ack_state = 6;

// Changing counter to 7
reg [7:0] addr=8'b00000000; 
reg [3:0] counter=4'b0111;
reg [5:0] state =6'b000000;
reg [3:0] data_in =4'b1111;

reg [3:0] data_out = 4'b0110;
reg sda_out = 0;
reg sda_in = 0;
reg wr_enb = 0;
reg start = 0;


assign sda = (wr_enb == 1) ? sda_out : 'bz;

//once check this
always@(negedge sda) begin
if(start == 0 && scl == 1) begin
$display("done");
start <=1;
end
end

//always@(posedge sda) begin
//if(start ==1 && scl == 1) begin
//state <= read_addr_state;
////start <= 0; 
//wr_enb <=0;                                 
//end
//end

// Next state logic
always@(negedge scl) begin
if(start ==1) begin
$display("slave state %d",state);
case(state)
read_addr_state:begin
//                counter <=7;
                $display("addr,counter,start %b,%d,%b",addr,counter,start);
                addr[counter] <= sda;
                if(counter == 0) state <= send_ack_state;
                else counter <= counter - 1;
                end
                
send_ack_state:begin
               $display("slave add,own add %b,%b",addr,address_slave);
               if(addr[7:1] == address_slave) begin
               counter <= 3;
                if(addr[0] == 0) state <= read_data_state;
                else state <= write_data_state;
               end
               end
                
read_data_state:begin
                $display("data_in %b,",data_in);
                data_in[counter] <= sda;
                 if(counter == 0) state <= send_ack_2_state;
                 else counter <= counter - 1;
                end                
  
  
//New thing added 
send_ack_2_state:begin
//                 recieved_data_slave <= data_in;
                 state <= slave_stop_state;
                 end 
                 
write_data_state:begin
                 if(counter == 0) state <= read_addr_state;
                 else counter = counter - 1;
                 end                

//read_ack_state:begin
               
//               end
                    
endcase         
end
end

// Output logic generation
//always@(negedge scl) begin
always@(posedge scl) begin
case(state)
read_addr_state:begin
                wr_enb <= 0;
                end
                
send_ack_state:begin
               sda_out <= 0;
               wr_enb <= 1;
               end               
   
read_data_state:begin
                wr_enb <= 0;
                end
                
send_ack_2_state:begin
                 sda_out <= 0;
                 wr_enb <= 1;
                 end                

// New line added, wr_enb <=1;
write_data_state:begin
                 $display("slaver data %d",data_out[counter]);
                 wr_enb <=1;
                 sda_out <= data_out[counter];
                 end 
                 
slave_stop_state:begin
                 wr_enb <= 0;
                 end                        
                                           
endcase
end

//  Latching the output safely on a separate clk domain
always @(negedge scl) begin
    if ((state == read_data_state) || (state == send_ack_2_state)) recieved_data_slave <= data_in;
end

endmodule
