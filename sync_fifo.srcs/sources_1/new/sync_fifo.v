`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.03.2026 23:13:29
// Design Name: 
// Module Name: sync_fifo
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
module sync_fifo #(
    parameter WIDTH = 8,   
    parameter SIZE  = 16   
)(
    input  wire           clk, rst_n, wr_en, rd_en,
    input  wire [WIDTH-1:0] din,
    output reg  [WIDTH-1:0] dout,
    output wire        full, empty
);
    reg [WIDTH-1:0] mem [0:SIZE-1];  
    reg [4:0]       wp, rp;
    
    assign empty = (wp == rp);
    assign full  = (wp[4] != rp[4]) && (wp[3:0] == rp[3:0]);
    
    always @(posedge clk) begin
        if (!rst_n) wp <= 0;
        else if (wr_en && !full) begin
            mem[wp[3:0]] <= din;
            wp <= wp + 1;
        end
    end
    
    always @(posedge clk) begin
        if (!rst_n) begin
            rp <= 0; dout <= 0;
        end else if (rd_en && !empty) begin
            dout <= mem[rp[3:0]];
            rp <= rp + 1;
        end
    end
endmodule

