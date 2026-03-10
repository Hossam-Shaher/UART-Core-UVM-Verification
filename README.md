# UART Core: UVM Verification
Serial communication uses a single data line (*serial line*) to exchange information between two systems. 

The transmitting system converts the parallel data to a serial stream, and the receiving system reassembles the serial data back to its original parallel format. 

A **UART (Universal Asynchronous Receiver and Transmitter) core** is the most commonly used scheme.

In this project, the UART core is verified using the **SystemVerilog HDVL** and the **Universal Verification Methodology (UVM)**.

## Design Under Test (DUT)

The UART core consists of three components:

1. The baud rate generator.
2. The receiver (Rx).
3. The transmitter (Tx).

The following figure shows the **block diagram** of the UART core.

<img width="2084" height="1040" alt="UART-UART Block Diagram drawio" src="https://github.com/user-attachments/assets/49595eac-ae8c-430f-8316-924d24d35bb7" />

For more information about the UART core (its parameters, ports, functionality, and more), see its specification: *UART Core Specification*.

## UVM Testbench

**This repository contains:**

1. **The testbench used to verify this module.**

    * It is written in SystemVerilog. (**Constrained randomization**, **functional coverage**, and **assertions** are used). 
    * It follows the Universal Verification Methodology (UVM). (**Multiple agents** are used).
    * It is file-based and well-constructed

2. **"UART Core - Architecture of The Verification Environment" (A PDF document).**
    * It shows the architecture of the verification environment, the transaction-level communication between its UVM components, and UML class diagrams of some classes.

3. **"UART Core - Verification Plan" (A PDF document).**
    * It contains three plans: (1) test plan, (2) coverage plan, and (3) assertion plan.

4. **"UART Core - Results" (A PDF document).**
    * It contains: (1) testing results, (2) coverage results, and (3) assertion results. 

The following figures show the **structure of the UVM testbench**. 

For more details, see: *UART Core - Architecture of The Verification Environment*.

<img width="619.5" height="510" alt="image" src="https://github.com/user-attachments/assets/10ba5d5f-f7de-4ca9-b594-336cdac8052a" />

<img width="936.5" height="539.5" alt="image" src="https://github.com/user-attachments/assets/ec417404-6660-4c0f-aa95-7e066d23b1c0" />

<img width="959.5" height="390" alt="image" src="https://github.com/user-attachments/assets/05049399-30da-4487-8cd2-c7c8ac87fc01" />
