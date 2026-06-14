`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/23/2025 06:30:34 PM
// Design Name: 
// Module Name: i2c_master
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


module i2c_master(
input i2c_clk,
input rst,
input [6:0]addr_top,
input [3:0]data_in_top,
input enable,
input rd_wr, 
output reg [3:0] data_out,
inout sda, inout scl);

reg [3:0] state=4'b0000;
reg [7:0] temp_addr=8'b00000000;
reg [3:0] temp_data=4'b0000;
reg [3:0] counter2=0;
reg wr_enb=1,sda_out=1;
reg i2c_scl_enable=0;

reg [3:0]master_data_in = 4'b1111;

parameter idle_state=0;
parameter start_state=1;
parameter address_state=2;
parameter read_ack_state=3;
parameter write_data_state=4;
parameter write_ack_state=5;
parameter read_data_state=6;
parameter read_ack_2_state=7;
parameter stop_state=8;

//For scl using i2c_clock
assign scl = (i2c_scl_enable == 0)? 1 : i2c_clk;

always@(posedge i2c_clk or posedge rst) begin
 if(rst==1) i2c_scl_enable <= 0;
 else 
  if(state == idle_state || state == start_state || state == stop_state) i2c_scl_enable <=0;
  else i2c_scl_enable <=1; 
end

// State machine logic
always@(posedge i2c_clk) begin
$display("master state %d",state);
if(rst==1) state <= idle_state;
else begin
case(state)
idle_state: begin
            if(enable) begin
            temp_addr <= {addr_top,rd_wr};
            temp_data <= data_in_top;
            state <= start_state;
            end
            else state <= idle_state;
            end
                 
start_state: begin 
             counter2 <=7;
             state <= address_state;
             end
             
address_state:begin 
              if(counter2 == 0) state <= read_ack_state;
              else counter2 <= counter2 - 1;
              end
             
read_ack_state:begin
               if(sda == 0) begin
               counter2 <=3;
                if(temp_addr[0] == 0) state <= write_data_state;
                else  state <= read_data_state;
               end
               end
                            
write_data_state:begin
                if(counter2 == 0) state <= read_ack_2_state;
                else counter2 <=counter2 - 1;
                end  
                
read_ack_2_state:begin
                 if(sda == 0 && enable ==1) state <= idle_state;
                 else state <= stop_state;
                 end   
              
// Reading the data from the slave and giving the data as output to the top level module   
read_data_state:begin
                master_data_in[counter2] <= sda;
                $display("master_read_data %d",master_data_in);
                
                if(counter2 == 0) state <= write_ack_state;
                else counter2 <= counter2 - 1;
                end 
                
write_ack_state:begin
                state <= stop_state;
                end            
 
stop_state:begin
           state <= idle_state;
           end 
  
//default: state <= idle_state;                                     
endcase
end
end

// Logic for generating output signals
always@(posedge i2c_clk) begin 
if(rst==1) begin 
wr_enb <= 1;sda_out <=1;

end
else begin

case(state)
idle_state: begin
            wr_enb <= 1;sda_out <= 1;
            end 
             
start_state: begin
             wr_enb <= 1;sda_out <= 0;
             end

address_state:begin
              $display("temp_addr %d",temp_addr[counter2]);
              sda_out <= temp_addr[counter2];
              end
              
read_ack_state:begin
               wr_enb <= 0;
               end

write_data_state:begin
                wr_enb <=1;
                sda_out <= temp_data[counter2];
                end       

read_data_state:begin
                wr_enb <= 0;
                end                 
                 
write_ack_state:begin
                wr_enb <= 1;
                sda_out <= 0;
                end       
        
stop_state:begin
           wr_enb <=1;
           sda_out <=1;
           end                 
 
                                                    
endcase
end
end

// Logic for sda
assign sda = (wr_enb == 1) ? sda_out : 'bz;


always @(posedge i2c_clk) begin
    if ((state == read_data_state) || (state == write_ack_state)) data_out <= master_data_in;
end

endmodule
