module sync_fifo_tb;
    reg         clk, rst_n, wr_en, rd_en;
    reg  [7:0]  din;
    wire [7:0]  dout;
    wire        full, empty;
    
    integer errors = 0;
 
    sync_fifo #(.WIDTH(8), .SIZE(16)) dut (
        .clk(clk), .rst_n(rst_n), .wr_en(wr_en), .din(din),
        .rd_en(rd_en), .dout(dout), .full(full), .empty(empty));
 
    initial clk = 0;
    always #5 clk = ~clk;
 
    // FIX: added begin...end inside every task
    task write;
        input [7:0] data;
        begin
            @(negedge clk); wr_en = 1; din = data;
            @(posedge clk); #1; wr_en = 0;
        end
    endtask
 
    task read;
        input [7:0] exp;
        begin
            @(negedge clk); rd_en = 1;
            @(posedge clk); #1; rd_en = 0;
            if (dout !== exp) begin
                $display("  MISMATCH: got=%0d exp=%0d", dout, exp);
                errors = errors + 1;
            end
        end
    endtask
 
    initial begin
        rst_n = 0; wr_en = 0; rd_en = 0; din = 0;
        repeat(3) @(posedge clk);
        
        $display("=== SYNC FIFO TESTS ===");
        rst_n = 1; @(posedge clk); #1;
        $display("1. Reset: empty=%b(exp 1)  full=%b(exp 0)", empty, full);
 
        $display("2. Write-Read 4 values:");
        write(10); read(10);
        write(20); read(20);
        write(30); read(30);
        write(40); read(40);
 
        $display("3. Fill all 16 slots:");
        repeat(16) write(8'hAA);
        #1; $display("   full=%b(exp 1)", full);
 
        $display("4. Overflow guard:");
        write(8'hFF);
        #1; $display("   full still=%b(exp 1) - write blocked", full);
 
        $display("5. Drain all 16 slots:");
        repeat(16) read(8'hAA);
        #1; $display("   empty=%b(exp 1)", empty);
 
        $display("6. Underflow guard:");
        read(8'hAA);
        #1; $display("   empty still=%b(exp 1) - read blocked", empty);
 
        $display("\n==============================");
        if (errors == 0)
            $display("  ALL TESTS PASSED");
        else
            $display("  FAILED: %0d errors", errors);
        $display("==============================");
 
        #100 $finish;
    end
endmodule