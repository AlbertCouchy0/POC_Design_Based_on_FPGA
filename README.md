# POC Design Based on FPGA

## Project Overview

This project aims to design and implement a Parallel Output Controller (POC) to serve as an interface between the system bus and the printer, enabling efficient data transmission and interaction. The project utilizes the Vivado software platform and employs the Verilog language for writing, designing, and simulating, ensuring that the POC module can support both polling and interrupt modes and can flexibly switch between the two modes according to actual needs.

## Design Objectives

  1. To design and implement the POC, processor, and printer modules, and complete the data interaction and transmission among the three through joint simulation.
  2. To ensure that the POC module can support both polling and interrupt modes and can switch between the two modes as needed.
  3. To verify the logical correctness of the POC design using functional simulation.

## Working Principle

### Polling Mode

  1. **Initialization Stage** : The processor and POC are initialized. The SR0 bit of the POC status register (SR) remains 0, indicating the polling mode. The printer is initialized, and RDY is set to 1, indicating that it is ready to receive data.
  2. **Processor Queries SR Status** : The processor selects the address of the POC's SR register through address selection and queries the status of SR7 (ready bit). If SR7=1, it means that the POC is in the "ready" state and can receive new data.
  3. **Processor Writes Data** : The processor selects the address of the POC buffer register (BR) and writes the data to be printed into the BR. After the write is completed, SR7 is set to 0, indicating that the processor has written new data to the POC and the POC has not yet processed it.
  4. **POC Detects SR7=0** : The POC detects that SR7 has been set to 0 and begins to perform handshake operations with the printer.
  5. **POC and Printer Handshake** : The printer detects RDY=1, indicating that it is ready to receive new data. The POC sends the data from the BR to the parallel data port (PD) and sends a pulse through the transmission request (TR). After the printer detects the TR pulse, it sets RDY to 0, receives the data on the PD port, and starts printing.
  6. **Printing Completed** : After the printing is completed, the printer resets RDY to 1, indicating that it is ready again. The POC resets SR7 to 1, returning to the "ready" state, and waits for the next data transmission.

### Interrupt Mode

  1. **Initialization Stage** : The processor and POC are initialized. The SR0 bit of the SR remains 1, indicating the interrupt mode. The printer is initialized, and RDY is set to 1, indicating that it is ready to receive data.
  2. **POC Detects SR Status** : The POC continuously detects the status of SR7. If SR7=1, the POC sends an interrupt request signal (IRQ) to the processor, which is active low.
  3. **Processor Responds to Interrupt** : After receiving the IRQ signal, since it is the interrupt mode, the processor will not query SR7 and directly selects the address of the BR. The processor writes the data to be printed into the BR register. After the write is completed, the processor sets SR7 to 0, indicating that it has written new data to the POC and the POC has not yet processed it.
  4. **POC Detects SR7=0** : The POC detects that SR7 has been set to 0 and begins to perform handshake operations with the printer.
  5. **POC and Printer Handshake** : The printer detects RDY=1, indicating that it is ready to receive new data. The POC sends the data from the BR to the PD port and sends a pulse through the TR. After the printer detects the TR pulse, it sets RDY to 0, receives the data on the PD port, and starts printing.
  6. **Printing Completed** : After the printing is completed, the printer resets RDY to 1, indicating that it is ready again. The POC resets SR7 to 1, returning to the "ready" state. Since SR0=1 and SR7=1, the POC sends the interrupt request signal IRQ again, waiting for the next data transmission.


## Module Interface Definition

  * **POC Module** :
    * **Input Ports** : clk (clock signal), print_data (data to be printed), print_flag (printer switch), print_button (start printing button), IRQ, D_b2a (data transmitted from POC to processor).
    * **Output Ports** : RW (read/write control), D_a2b (data transmitted from processor to POC), RSA (register select address signal).

  * **Processor Module** :
    * **Input Ports** : clk, Switch (transmission mode, 0: polling mode, 1: interrupt mode), RW, D_a2b, RSA, RDY (Ready signal, 1: printer is ready, 0: printer is not ready).
    * **Output Ports** : IRQ, D_b2a, TR (print request for printer) PD (parallel output port).

  * **Printer Module** :
    * **Input Ports** : clk, TR, PD, RDY.
    * **Output Ports** : print_data_out (data printed by the printer).

## Simulation Results

  * **Polling Mode Simulation** : During the period of 0-50ns, print_flag=1, the printer is turned on but there is no input data, so print_data=0. From 50-100ns, a positive pulse of print_button is generated by pressing the button, and the first set of data is input. After a period of time, the printer successfully outputs the data to be printed. From 100-200ns, the data is cleared. Observing the simulation results, IRQ is always at a high level, and the interrupt request is invalid. RW will enter 10 (read state) before entering 11 (write state), reflecting the characteristics of the polling mode.
  * **Interrupt Mode Simulation** : During the period of 0-50ns, print_flag=1, the printer is turned on but there is no input data, so print_data=0. From 50-100ns, a positive pulse of print_button is generated by pressing the button, and the first set of data is input. After a period of time, the printer successfully outputs the data to be printed. From 100-200ns, the data is cleared. Observing the simulation results, except for the time when SR7 is 0 (the POC is shaking hands with the printer), IRQ is effectively low, and RW will directly enter 11 (write state), reflecting the characteristics of the interrupt mode.
  * **Comprehensive Simulation** : The comprehensive simulation is divided into three stages with a total of six sets of data. The first stage (0-300ns) is the polling mode, outputting 2 sets of data; the second stage (300-700ns) is the interrupt mode, outputting 3 sets of data; the third stage (700-850ns) is the polling mode, outputting 1 set of data. The simulation results meet the expectations.
