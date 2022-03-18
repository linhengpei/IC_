`timescale 1ns/10ps
module LBP ( clk, reset, gray_addr, gray_req, gray_ready, gray_data, lbp_addr, lbp_valid, lbp_data, finish);
input   	clk;
input   	reset;

input       	gray_ready;
input [7:0] 	gray_data;
output reg [13:0] 	gray_addr;
output reg        	gray_req;
output reg        	lbp_valid;
output reg [13:0]  lbp_addr;
output reg [7:0] 	 lbp_data;
output reg         finish;
reg [7:0] data [8:0];
reg [3:0]state;

always@(posedge clk)begin
  if (reset)begin
     gray_addr <= 0;
     gray_req <= 0;
     lbp_addr <= 129;
     lbp_valid <= 0;
     lbp_data <= 0;
     finish <= 0;
     state <=0; 
  end
  else begin
     if(gray_ready)
           gray_req <= 1;
     if(gray_req)begin
       case (state)
        4'd0:begin
             gray_addr <= gray_addr+128;
             data[state] <= gray_data;
            
             end 
        4'd1:begin
             gray_addr <= gray_addr+128;
             data[state] <= gray_data;
             
             end 
        4'd2:begin
             gray_addr <= gray_addr-255;
             data[state] <= gray_data;
       
             end 
        4'd3:begin
             gray_addr <= gray_addr+128;
             data[state] <= gray_data;
            
             end
        4'd4:begin
             gray_addr <= gray_addr+128;
             data[state] <= gray_data;
             
             end
        4'd5:begin
             gray_addr <= gray_addr-255;
             data[state] <= gray_data;
             
             end     
        4'd6:begin 
             lbp_data[0] <=(data[0] >= data[4])? 1 : 0 ;
             lbp_data[3] <=(data[1] >= data[4])? 1 : 0 ;
             lbp_data[5] <=(data[2] >= data[4])? 1 : 0 ;
  
             gray_addr <= gray_addr+128;
             data[state] <= gray_data;
            
             end
        4'd7:begin
             lbp_data[1] <=(data[3] >= data[4])? 1 : 0 ;
             lbp_data[6] <=(data[5] >= data[4])? 1 : 0 ;

             gray_addr <= gray_addr+128;
             data[state] <= gray_data;
            
             end    
        4'd8:begin
             lbp_valid <= 1; 
             lbp_data[2] <=(data[6] >= data[4])? 1 : 0 ;
             lbp_data[4] <=(data[7] >= data[4])? 1 : 0 ;
             lbp_data[7] <=(gray_data >= data[4])? 1 : 0 ; 

             data[state] <= gray_data;
           
             end            
          endcase
          
          if(state == 9)begin
              lbp_valid <= 0;  
              if( lbp_addr == 16254)
                       finish <= 1;
              if(lbp_addr[6:0] == 7'b1111110 )begin  //next line
                  lbp_addr <= lbp_addr +3;
                  gray_addr <= gray_addr -255;
                  state <= 0;
              end
              else begin
                 lbp_addr <= lbp_addr+1;
                 gray_addr <= gray_addr -255;
                 state <= 6;
                 data[0] <= data[3];
                 data[1] <= data[4];
                 data[2] <= data[5];
                 data[3] <= data[6];
                 data[4] <= data[7];
                 data[5] <= data[8];
              end
          end
          else
                state <= state + 1;
      end  
    end  
end
endmodule