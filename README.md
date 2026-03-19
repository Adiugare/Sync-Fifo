# Sync-Fifo
A Synchronous First-In-First-Out (FIFO) buffer implemented in Verilog/SystemVerilog using Xilinx Vivado. This project includes the RTL design, functional testbench, and simulation results.

Project Overview
ParameterValueFIFO TypeSynchronous (Single Clock)Data Width8 bitsFIFO Depth16 entriesLanguageVerilog / SystemVerilogToolXilinx Vivado

Features

Single-clock synchronous read and write operations
Configurable data width (8-bit) and depth (16 entries)
Full and Empty flag generation
Write Enable (wr_en) and Read Enable (rd_en) control signals
Pointer-based circular buffer implementation


File Structure
Sync-Fifo/
├── sync_fifo.xpr          # Vivado project file
├── sync_fifo.srcs/
│   ├── sources_1/         # RTL design sources
│   │   └── sync_fifo.v    # FIFO RTL module
│   └── sim_1/             # Testbench sources
│       └── tb_sync_fifo.v # Functional testbench
├── .gitignore
└── README.md

Module Interface

module sync_fifo #(
    parameter WIDTH = 8,   
    parameter SIZE  = 16   
)(
    input  wire           clk, rst_n, wr_en, rd_en,
    input  wire [WIDTH-1:0] din,
    output reg  [WIDTH-1:0] dout,
    output wire        full, empty
);

Signal Description
SignalDirectionWidthDescriptionclkInput1-bitSystem clockrstInput1-bitSynchronous reset (active high)wr_enInput1-bitWrite enablerd_enInput1-bitRead enabledinInput8-bitData inputdoutOutput8-bitData outputfullOutput1-bitFIFO full flagemptyOutput1-bitFIFO empty flag

How It Works

Write operation: When wr_en = 1 and full = 0, data is written to the memory at the write pointer, and the write pointer is incremented.
Read operation: When rd_en = 1 and empty = 0, data is read from the memory at the read pointer, and the read pointer is incremented.
Full flag: Asserted when the number of entries equals FIFO_DEPTH (16).
Empty flag: Asserted when the write pointer equals the read pointer (no data stored).


Simulation
The design was simulated using Xilinx Vivado Simulator.
Test Cases Covered

Reset behavior
Sequential write operations until FIFO is full
Sequential read operations until FIFO is empty
Simultaneous read and write
Write when full (overflow check)
Read when empty (underflow check)

Running Simulation in Vivado

Open sync_fifo.xpr in Xilinx Vivado
In the Flow Navigator, click Run Simulation → Run Behavioral Simulation
Observe waveforms for din, dout, full, empty, wr_en, rd_en


Tools Used
ToolVersionXilinx Vivado2023.xSimulatorVivado Simulator (XSim)LanguageVerilog / SystemVerilog

Author
Aditya — GitHub: Adiugare

License
This project is open-source and available under the MIT License.
