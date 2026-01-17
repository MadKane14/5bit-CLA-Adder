`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Cleaned / corrected CLA_5bit
//////////////////////////////////////////////////////////////////////////////////

module DLatch (input D, input clk, output Q);
    wire Dn, S, R, Qn;
    not U1 (Dn, D);
    and U2 (S, D, clk);
    and U3 (R, Dn, clk);
    nor U4 (Q, R, Qn);
    nor U5 (Qn, S, Q);
endmodule

module Dff (input D, input clk, output Q);
    wire clk_n;
    wire D1;
    not U1 (clk_n, clk);
    DLatch Master (.D(D), .clk(clk_n), .Q(D1));
    DLatch Slave (.D(D1), .clk(clk), .Q(Q));
endmodule

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


module CLA_5bit(
    input [4:0] A,
    input [4:0] B,
    input Cin,
    input clk,
    output [4:0] Sum,    // renamed from S -> Sum to match your XDC
    output Cout
);

    // Propagate / Generate / Carry / Sum registers/wires
    wire [4:0] G, P;      // generate, propagate
    wire [4:0] C;         // internal carries (C[0] is carry into bit1)
    wire [4:0] S1;        // combinational sums (to be registered)
    wire cc;

    // Registered inputs
    wire [4:0] A1, B1;
    wire Cin1;

    // register inputs (sampled on clk)
    D5ff dff_a(A, clk, A1);
    D5ff dff_b(B, clk, B1);
    Dff  dff_c(Cin, clk, Cin1);

    // compute generate and propagate
    assign G = A1 & B1;       // bitwise AND
    assign P = A1 ^ B1;       // bitwise XOR

    // carry lookahead logic (explicit boolean expressions)
    // C[0] = G0 | (P0 & Cin1)
    assign C[0] = G[0] | (P[0] & Cin1);

    // C[1] = G1 | (P1 & G0) | (P1 & P0 & Cin1)
    assign C[1] = G[1]
                | (P[1] & G[0])
                | (P[1] & P[0] & Cin1);

    // C[2] = G2 | (P2 & G1) | (P2 & P1 & G0) | (P2 & P1 & P0 & Cin1)
    assign C[2] = G[2]
                | (P[2] & G[1])
                | (P[2] & P[1] & G[0])
                | (P[2] & P[1] & P[0] & Cin1);

    // C[3] = G3 | (P3 & G2) | (P3 & P2 & G1) | (P3 & P2 & P1 & G0) | (P3 & P2 & P1 & P0 & Cin1)
    assign C[3] = G[3]
                | (P[3] & G[2])
                | (P[3] & P[2] & G[1])
                | (P[3] & P[2] & P[1] & G[0])
                | (P[3] & P[2] & P[1] & P[0] & Cin1);

    // C[4] = G4 | (P4 & G3) | (P4 & P3 & G2) | (P4 & P3 & P2 & G1) | (P4 & P3 & P2 & P1 & G0) | (P4 & P3 & P2 & P1 & P0 & Cin1)
    assign C[4] = G[4]
                | (P[4] & G[3])
                | (P[4] & P[3] & G[2])
                | (P[4] & P[3] & P[2] & G[1])
                | (P[4] & P[3] & P[2] & P[1] & G[0])
                | (P[4] & P[3] & P[2] & P[1] & P[0] & Cin1);

    // sums (combinational)
    assign S1[0] = P[0] ^ Cin1;
    assign S1[1] = P[1] ^ C[0];
    assign S1[2] = P[2] ^ C[1];
    assign S1[3] = P[3] ^ C[2];
    assign S1[4] = P[4] ^ C[3];

    assign cc = C[4];

    // register the sums and cout
    D5ff dff_sum(S1, clk, Sum);
    Dff  dff_cout(cc, clk, Cout);

endmodule
