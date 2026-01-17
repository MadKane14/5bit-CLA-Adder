`timescale 1ps/1ps

module CLA_tb;

    // Inputs
    reg [4:0] A;
    reg [4:0] B;
    reg Cin;
    reg clk;

    // Outputs
    wire [4:0] S;
    wire Cout;
    wire [4:0] A1, B1;
    wire Cin1;
    
    // Instantiate the Unit Under Test (UUT)
    CLA uut (
        .A(A), 
        .B(B), 
        .Cin(Cin), 
        .clk(clk), 
        .S(S), 
        .Cout(Cout),
        .A1(A1),
        .B1(B1),
        .Cin1(Cin1)
    );

    initial 
    begin
        $dumpfile("CLA_tb.vcd");
        $dumpvars(0, CLA_tb);

        // --- Test Case 1: Max Values ---
        // 31 (11111) + 31 (11111) + 1 (Cin) = 63
        // Result should be S=11111, Cout=1 (Total 63, which is 111111 in 6 bits)
        A = 5'b11111;
        B = 5'b11111;
        Cin = 1'b1;
        clk = 1'b0;
        
        // Clock pulses (Input Capture -> Calc -> Output Capture)
        #10 clk = ~clk; // Pos: Input captured
        #10 clk = ~clk; // Neg
        #10 clk = ~clk; // Pos: Output captured
        #10 clk = ~clk; // Neg
        #10;

        // --- Test Case 2: Random Values ---
        // 20 (10100) + 10 (01010) + 0 = 30 (011110)
        // Cout should be 0, S should be 11110
        A = 5'b10100;
        B = 5'b01010;
        Cin = 1'b0;
        
        #10 clk = ~clk; 
        #10 clk = ~clk;
        #10 clk = ~clk;
        #10 clk = ~clk;
        #10;
        
        // --- Test Case 3: Ripple propagation check ---
        // 15 (01111) + 1 (00001) + 0 = 16 (10000)
        // Checks if carry ripples from bit 0 to bit 4
        A = 5'b01111;
        B = 5'b00001;
        Cin = 1'b0;

        #10 clk = ~clk; 
        #10 clk = ~clk;
        #10 clk = ~clk;
        #10 clk = ~clk;

        $finish;
    end
    
    always @(posedge clk) 
    begin
        // Delay slightly to allow outputs to settle after clock edge
        #1; 
        $display("Time=%t | Input: A=%d B=%d Cin=%b | Internal: A1=%b B1=%b | Output: S=%d (%b) Cout=%b", 
                 $time, A, B, Cin, A1, B1, S, S, Cout);
    end

endmodule