# iCEBreaker FPGA based PMOD GPS Speedometer

This is a basic implmentation of a PMOD GPS Speedometer on an iCEBreaker FPGA. When powered on, it can acquire a GPS position fix with the PMOD GPS, and display *km/h GPS Speed* on a 7-segment display. The speed is filtered through a basic Kalman Filter. 

## Getting Started 

### Required Hardware

1. [iCEBreaker FPGA](https://1bitsquared.com/collections/fpga/products/icebreaker)
2. [Digilent, Inc. 410-237 BOARD PMODGPS](https://www.digikey.com/en/products/detail/digilent-inc/410-237/3902830)
3. [1BitSquared PMOD 7-Segment Display](https://1bitsquared.com/products/pmod-7-segment-display)

### Required Toolchain

#### Building
- [Yosys Open SYnthesis Suite](https://yosyshq.net/yosys/)

#### Working with the code
- [Verilator](https://verilator.org/guide/latest/)
- [iVerilog](https://github.com/steveicarus/iverilog)

## Repository Structure

The repository has the following file structure:

````bash
| README.md (This File)
| LICENSE.txt
| CHANGELOG.md
|-- rtl # Source and testbench
|    |
|    | dpi.mk # Simulation
|    | fpga.mk # Synth and Build
|    | simulation.mk # Simulation & Testbench Defination
|    |-- souce 
|    |     |
|    |     |-- <Top module>
|    |     |    |
|    |     |    |-- top.sv # SystemVerilog top module
|    |     |    |-- top_testbench.sv # SystemVerilog top module testbench
|    |     |-- <Module Name>
|    |     |    |
|    |     |    |-- <Module Name>.sv # SystemVerilog module file
|    |     |    |-- <Module Name>_testbench.sv # SystemVerilog module testbench file (Not all modules have a testbench)
|    |     | Makefile
|    |-- provided_modules # Modules provided by UCSC CSE 125/L
|    |     |
|    |     |-- <Module Name>
|    |     |    |
|    |     |    |-- <Module Name>.sv # SystemVerilog module file
|    |     |    |-- <Module Name>_testbench.sv # SystemVerilog module testbench file (Not all modules have a testbench)
|-- utilities # Configuration code to run an arduino to configure PMOD GPS
|    |
|    |-- gpsconfig
|    |     |
|    |     |-- gpsconfig.ino # configuration sketch to configure PMOD GPS to desired baud rate and refresh rate
````


## Working with this repo

As of current, in order to synth and build for the FPGA, the top module defination has to be changed in Makefile in source depends on what you want to do.
To build:
1. Go to rtl/source
2. Make sure in Makefile, TOP_MODULE is set as "speedo"
2. make prog

To run individual testbenches, double check in simulation.mk that a testbench is defined for a module.
To run testbench:
1. Go to rtl/source
2. Make sure in Makefile, TOP_MODULE is set as "top"
3. make test_<Module Name>
You can modify simulation.mk to add more testbenches as desired.

## Some Caveats

- The configuration command provided by Digilent, which is used by gpsconfig.ino, seems to be partially incorrect. The script is able to make the GPS change its baud rate to 38.4k, but the command to change refresh rate seems to be invalid. These command are from GlobalTop's Firmware Customization Service, which is not accessible as of now.
- With the GPS on 1Hz, the performance of the speedo is slugish and the Kalman Filter have a hard time even with very high convariance martix.
- Requires 4MHz clock as of current. More pipeline stages should enable a faster clock. Or you can change how the clock is set in rtl/provide_modules/icebreaker.pcf and rtl/fpga.mk

## Code Used
- UART interface based on: https://github.com/medalotte/SystemVerilog-UART 
## Appendix
Special thanks to Dustin Richmond, Priyanka Dutta, and Bhawandeep Sigh Harsh for their assistant through the course for me to complete this project.