# Diagrom64

This project is an open-source C64 diagnostic ROM meant to aid repair of Commodore 64 computers.
It is designed to replace the kernal ROM on the c64 mainboard, but also functions as a typical deadtest cartridge using ultimax mode
I decided to start work on this after trying to repair a particularly sick C64, where the CPU was crashing before the deadtest could even do anything. 
Thus, i made this diagrom init the VIC and change the border color the second the CPU starts running, allowing me to narrow my search down massively.

Currently, it only tests the various memory locations searching for bad RAM.
I plan to eventually add all the tests performed by the deadtest cart, plus many more

## Building

The CC65 compiler suite is required to build this project. To do so, just type `make all` in the project root.
To test the ROM, us `make sim` to open diagrom64 in VICE. If it doesn't find the vice binary correctly, just launch vice with `x64 -kernal bin/diagrom.bin` instead.

## Authors

* **NotArtyom** - *Things that do stuff* - [Website](http://notartyoms-box.com)
