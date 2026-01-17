# 5-bit Carry Look Ahead (CLA) Adder Design

## 📌 Project Overview
This repository contains the design, simulation, and implementation of a **5-bit Carry Look Ahead (CLA) Adder** using **180nm CMOS technology**. The project encompasses the full VLSI design flow, from transistor-level schematic design to physical layout, post-layout verification, and hardware implementation on FPGA.

The design utilizes a pipelined architecture with D-Flip-Flops at the input and output stages to ensure stable synchronous operation.

## 📂 Repository Structure
```text
├── MAGIC/          # Physical layout files (.mag) using SCN6M_DEEP.09 technology
├── NGSPICE/        # Netlists and simulation scripts (.spice, .cir)
├── Verilog/        # Verilog HDL structural description and testbenches
├── 2024102061_VLSI_Project_Report.pdf  # Detailed project report
└── VLSI_Design 2025 Problem Statement.pdf # Original problem statement