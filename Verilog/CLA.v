module Or(input a, b, output out);
    assign out = a | b;
endmodule

module Or3(input a, b, c, output out);
    assign out = a | b | c;
endmodule

module Or4(input a, b, c, d, output out);
    assign out = a | b | c | d;
endmodule

module Or5(input a, b, c, d, e, output out);
    assign out = a | b | c | d | e;
endmodule

// New Module for 5-bit CLA Carry Logic
module Or6(input a, b, c, d, e, f, output out);
    assign out = a | b | c | d | e | f;
endmodule

module And(input a, b, output out);
    assign out = a & b;
endmodule

module And3(input a, b, c, output out);
    assign out = a & b & c;
endmodule

module And4(input a, b, c, d, output out);
    assign out = a & b & c & d;
endmodule

module And5(input a, b, c, d, e, output out);
    assign out = a & b & c & d & e;
endmodule

// New Module for 5-bit CLA Carry Logic
module And6(input a, b, c, d, e, f, output out);
    assign out = a & b & c & d & e & f;
endmodule

module Xor(input a, b, output out);
    assign out = a ^ b;
endmodule

// ==========================================
// Flip-Flops and Latches
// ==========================================

// SR Latch
module DLatch (input D, input clk, output Q);
    wire Dn, S, R, Qn;
    not U1 (Dn, D);
    and U2 (S, D, clk);
    and U3 (R, Dn, clk);
    nor U4 (Q, R, Qn);
    nor U5 (Qn, S, Q);
endmodule

// D flip-flop for 1-bit input
module Dff (input D, input clk, output Q);
    wire clk_n;
    wire D1;
    not U1 (clk_n, clk);
    DLatch Master (.D(D), .clk(clk_n), .Q(D1));
    DLatch Slave (.D(D1), .clk(clk), .Q(Q));
endmodule

// D flip-flop for 5-bit input (Modified from D4ff)
module D5ff (
    input [4:0] D,
    input clk,
    output [4:0] Q
);
    Dff dff0( D[0], clk, Q[0] );
    Dff dff1( D[1], clk, Q[1] );
    Dff dff2( D[2], clk, Q[2] );
    Dff dff3( D[3], clk, Q[3] );
    Dff dff4( D[4], clk, Q[4] );
endmodule

// ==========================================
// 5-Bit Carry Look Ahead Adder
// ==========================================

module CLA(
    input [4:0] A,
    input [4:0] B,
    input Cin,
    input clk,
    output [4:0] S,
    output Cout,
    output [4:0] A1,
    output [4:0] B1,
    output Cin1
);

    // Internal wires
    wire [4:0] G, P, C;
    wire [4:0] S1;
    wire cc; // Internal wire for final carry

    // Wire declarations for intermediate AND terms
    // C0 terms
    wire P0Cin;
    // C1 terms
    wire P1G0, P1P0Cin;
    // C2 terms
    wire P2G1, P2P1G0, P2P1P0Cin;
    // C3 terms
    wire P3G2, P3P2G1, P3P2P1G0, P3P2P1P0G0; 
    wire P3P2P1P0Cin;
    // C4 terms
    wire P4G3, P4P3G2, P4P3P2G1, P4P3P2P1G0, P4P3P2P1P0Cin;

    // 1. Register Inputs
    D5ff dff_a(A, clk, A1);
    D5ff dff_b(B, clk, B1);
    Dff  dff_c(Cin, clk, Cin1);

    // 2. Carry Generation (G) and Propagation (P)
    // gi = Ai & Bi, pi = Ai ^ Bi
    
    // Bit 0
    And and_g0(A1[0], B1[0], G[0]);
    Xor xor_p0(A1[0], B1[0], P[0]);
    
    // Bit 1
    And and_g1(A1[1], B1[1], G[1]);
    Xor xor_p1(A1[1], B1[1], P[1]);
    
    // Bit 2
    And and_g2(A1[2], B1[2], G[2]);
    Xor xor_p2(A1[2], B1[2], P[2]);
    
    // Bit 3
    And and_g3(A1[3], B1[3], G[3]);
    Xor xor_p3(A1[3], B1[3], P[3]);

    // Bit 4 (New)
    And and_g4(A1[4], B1[4], G[4]);
    Xor xor_p4(A1[4], B1[4], P[4]);

    // 3. Carry Calculation
    
    // c0 = g0 + p0Cin
    And and_c0_1(Cin1, P[0], P0Cin);
    Or  or_c0   (P0Cin, G[0], C[0]);

    // c1 = g1 + p1g0 + p1p0Cin
    And  and_c1_1(P[1], G[0], P1G0);
    And3 and_c1_2(P[1], P[0], Cin1, P1P0Cin);
    Or3  or_c1   (G[1], P1G0, P1P0Cin, C[1]);

    // c2 = g2 + p2g1 + p2p1g0 + p2p1p0Cin
    And  and_c2_1(P[2], G[1], P2G1);
    And3 and_c2_2(P[2], P[1], G[0], P2P1G0);
    And4 and_c2_3(P[2], P[1], P[0], Cin1, P2P1P0Cin);
    Or4  or_c2   (G[2], P2G1, P2P1G0, P2P1P0Cin, C[2]);

    // c3 = g3 + p3g2 + p3p2g1 + p3p2p1g0 + p3p2p1p0Cin
    And  and_c3_1(P[3], G[2], P3G2);
    And3 and_c3_2(P[3], P[2], G[1], P3P2G1);
    And4 and_c3_3(P[3], P[2], P[1], G[0], P3P2P1G0);
    And5 and_c3_4(P[3], P[2], P[1], P[0], Cin1, P3P2P1P0Cin);
    Or5  or_c3   (G[3], P3G2, P3P2G1, P3P2P1G0, P3P2P1P0Cin, C[3]);

    // c4 (Cout) = g4 + p4g3 + p4p3g2 + p4p3p2g1 + p4p3p2p1g0 + p4p3p2p1p0Cin
    And  and_c4_1(P[4], G[3], P4G3);
    And3 and_c4_2(P[4], P[3], G[2], P4P3G2);
    And4 and_c4_3(P[4], P[3], P[2], G[1], P4P3P2G1);
    And5 and_c4_4(P[4], P[3], P[2], P[1], G[0], P4P3P2P1G0);
    And6 and_c4_5(P[4], P[3], P[2], P[1], P[0], Cin1, P4P3P2P1P0Cin);
    Or6  or_c4   (G[4], P4G3, P4P3G2, P4P3P2G1, P4P3P2P1G0, P4P3P2P1P0Cin, C[4]);

    // 4. Sum Calculation
    // si = pi ^ C(i-1) (Note: C[0] here represents carry out of bit 0)
    
    Xor xor_s0(P[0], Cin1, S1[0]);
    Xor xor_s1(P[1], C[0], S1[1]);
    Xor xor_s2(P[2], C[1], S1[2]);
    Xor xor_s3(P[3], C[2], S1[3]);
    Xor xor_s4(P[4], C[3], S1[4]); // New 5th bit sum

    // 5. Register Outputs
    assign cc = C[4];
    
    D5ff dff_sum(S1, clk, S);
    Dff  dff_cout(cc, clk, Cout);

endmodule