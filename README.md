# About
This is a very basic operating system (bazOS) written for fun in X68 assembly and designed to run via the Easy68K simulator.

# Usage:
1. Run 'python setup.py' to create binary file HD0 that represents the Hard Drive.
2. Assemble and run setup.X68 which partitions and formats HD0, then install the OS on the drive.
3. Assemble and run bios.X68 which begins a power on boot procedure, loading the kernel from HD0 into memory, and opening a command terminal.