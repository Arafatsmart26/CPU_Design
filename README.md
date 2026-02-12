# CPU_Design

This repository contains a simple educational CPU design in VHDL, inspired by classic RISC architectures often used in the tecnical university of denmark courses (e.g. DTU). The goal is to provide a small but complete CPU core that can be used for learning, experiments, and small projects. Book used Digital design a systematic aproach W.J Dally.

### High-Level Idea

- **Single-cycle CPU**: Each instruction is executed in one clock cycle.
- **RISC-style instruction set**: A minimal but useful set of arithmetic, logical, load/store, and branch instructions.
- **Modular design**: The CPU is split into clear modules (ALU, register file, PC, control unit, etc.) to make it easy to understand and extend.

---

## Architecture

### Datapath

- **Word size**: 32-bit data and 32-bit program counter (PC).
- **Register file**: 16 general-purpose registers (`R0`–`R15`), with `R0` hardwired to 0.
- **Instruction width**: 32-bit instructions.
- **Addressing**: Word-aligned instruction addresses.

### Instruction Formats (example)

- **R-type** (register-to-register):
  - `opcode (31:28) | rd (27:24) | rs (23:20) | rt (19:16) | unused (15:0)`
- **I-type** (immediate / load/store / branch):
  - `opcode (31:28) | rt (27:24) | rs (23:20) | imm (19:0)`
- **J-type** (jump):
  - `opcode (31:28) | addr (27:0)`

### Example Instructions

- **Arithmetic / logic**
  - `ADD rd, rs, rt`
  - `SUB rd, rs, rt`
  - `AND rd, rs, rt`
  - `OR  rd, rs, rt`
  - `ADDI rt, rs, imm`
- **Load / Store**
  - `LW  rt, imm(rs)` – load word from data memory
  - `SW  rt, imm(rs)` – store word to data memory
- **Control flow**
  - `BEQ rs, rt, imm` – branch if `rs == rt`
  - `J   addr` – unconditional jump

The exact encoding of instructions (opcodes, immediate format, etc.) can be found in the VHDL code and can be extended as needed.

---

## Files

(Adjust this section if some filenames are different in your repo.)

- **`cpu_core.vhd`**  
  Top-level CPU module that connects all subcomponents (PC, instruction memory, register file, ALU, control unit, etc.).

- **`alu.vhd`**  
  Arithmetic Logic Unit. Implements operations such as ADD, SUB, AND, OR and produces a `zero` flag used by branch instructions.

- **`register_file.vhd`** *(if present, or to be added later)*  
  Register file with two read ports and one write port. Supports synchronous write and asynchronous read.

- **`pc.vhd`**  
  Program Counter register. Holds the current instruction address and is updated every clock cycle (optionally including branch/jump logic).

- **`imen.vhd` / `imem.vhd`**  
  Instruction memory (typically implemented as a small ROM or RAM initialized with a test program).

- **`control_unit.vhd`**  
  Control unit that decodes the instruction `opcode` and generates control signals for the ALU, register file, memory, and PC (e.g. `reg_write`, `alu_src`, `branch`, `jump`, etc.).

- **(Optional) `dmem.vhd`**  
  Data memory used by `LW`/`SW` instructions.

- **`tb_cpu_core.vhd`** *(optional / recommended)*  
  Testbench for simulating the CPU running a small program stored in instruction memory.

---

## How to Simulate

These are generic steps that work similarly in most VHDL tools (ModelSim/Questa, Vivado, Quartus, etc.):

1. **Create a project**
   - Create a new VHDL project in your preferred tool.
   - Add all `.vhd` files from this repository to the project.

2. **Set top-level**
   - Use `tb_cpu_core` as the top-level design for simulation if you have a testbench.
   - Alternatively, simulate `cpu_core` directly and write your own testbench that drives `clk` and `reset`.

3. **Compile**
   - Compile all VHDL files and fix any syntax errors.

4. **Run simulation**
   - Run a time-based simulation (e.g. some microseconds or enough clock cycles to execute your test program).
   - Observe signals like `pc`, `instr`, register values, ALU results, etc. in the waveform viewer to see how the CPU executes the program.

5. **Modify the program**
   - Edit the initialization in `imen.vhd` / `imem.vhd` to change the program stored in instruction memory.
   - Recompile and re-run the simulation to test new instructions and scenarios.

---

## Possible Extensions

- **More instructions** (e.g. XOR, SLT, shifts, multiplication/division).
- **More addressing modes** (e.g. byte/halfword accesses, different branch types).
- **Pipelining** (IF/ID/EX/MEM/WB) to introduce hazards, forwarding, and stalls.
- **Interrupts and exceptions**.
- **A simple assembler or scripts** to translate pseudo-assembly into machine code for the instruction memory.

---

## Purpose

The main purpose of this project is **education and documentation**. The VHDL code can serve as a starting point for exercises, reports, or as a reference when learning how a simple CPU can be built from basic components.
