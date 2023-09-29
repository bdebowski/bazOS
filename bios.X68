*-----------------------------------------------------------
* bios.X68
*
* Sets up and boots the system
*-----------------------------------------------------------


*-----------------------------------------------------------
* Set Up System Memory Sections
*-----------------------------------------------------------
ROMSTRT EQU     $000000
ROMEND  EQU     $000FFF
KMSTRT  EQU     $004000
KMEND   EQU     $007FFF
UMSTRT  EQU     $008000
UMEND   EQU     $01FFFF
IOMSTRT EQU     $0E0000
IOMEND  EQU     $0EFFFF

        MEMORY  Read        ROMSTRT,ROMEND      ; Read only memory section
        MEMORY  Invalid     ROMEND+1,KMSTRT-1   ; Doesn't exist
        MEMORY  Protected   KMSTRT,KMEND        ; Kernel access only memory section
        * Nothing to do for user memory section
        MEMORY  Invalid     UMEND+1,IOMSTRT-1   ; Doesn't exist
        * Nothing to do for IO memory section
        MEMORY  Invalid     IOMEND+1,$FFFFFF    ; Doesn't exist
*-----------------------------------------------------------


*-----------------------------------------------------------
* Define the Vector Table
*-----------------------------------------------------------
        * Interrupt Vector Table from $000 - $3FF
        ORG     $000000
        DC.L    KMEND+1     ; System Stack pointer initial value
        DC.L    BTSTRP      ; Address of first line of boot code
        DS.B    $3F8        ; Skip remaining for now
*-----------------------------------------------------------


*-----------------------------------------------------------
* Include critical modules
*-----------------------------------------------------------
CPSTRT  INCLUDE "emulatedhd.X68"    ; EmulatedHD driver code
*-----------------------------------------------------------


*-----------------------------------------------------------
* Define the Boot Sequence
*
* NOTE: This will change.  In the future, we will just initialize
* the HD here, then copy the kernel code from the HD into memory
* and pass control to the kernel.  The kernel code will be
* assembled relative to address 0000 and A6 will be set the base
* address where the kernel was copied.
*-----------------------------------------------------------
        * Initialize HD0
BTSEQ   MOVE.L  DVCTBL+KMSTRT-CPSTRT,A1
        CLR.L   D1                      ; select device 0
        CLR.L   D0                      ; clear for return value
        BSR     EMULATEDHD_INIT

        * Build the data structure that will be written to the drive
        LEA     HDBUF+KMSTRT-CPSTRT,A1
        MOVE.L  #$01234567,(A1)+
        MOVE.L  #$89ABCDEF,(A1)+

        * Seek to position 0x20 on the drive
        MOVE.L  DVCTBL+KMSTRT-CPSTRT,A1
        MOVE.L  #$20,D1
        CLR.L   D0
        BSR     EMULATEDHD_SEEK

        * Write the structure to the drive
        MOVE.L  DVCTBL+KMSTRT-CPSTRT,A1
        LEA     HDBUF+KMSTRT-CPSTRT,A2
        MOVE.L  #8,D1
        CLR.L   D0
        BSR     EMULATEDHD_WRITE

        * Seek to position 0x0 on the drive
        MOVE.L  DVCTBL+KMSTRT-CPSTRT,A1
        CLR.L   D1
        CLR.L   D0
        BSR     EMULATEDHD_SEEK

        * Read 512 Bytes from drive into memory buffer
        MOVE.L  DVCTBL+KMSTRT-CPSTRT,A1
        LEA     HDBUF+KMSTRT-CPSTRT,A2
        MOVE.L  #HDBUFSZ,D1
        CLR.L   D0
        BSR     EMULATEDHD_READ

        SIMHALT
        
        * Define a Device Table.
        * The device table for now just stores the memory mapped 
        * address of HD0.
DVCTBL  DC.L    IOMSTRT

        * Define a 512 Byte long buffer for reading from/writing
        * to drives.
HDBUFSZ EQU     512
HDBUF   DS.B    HDBUFSZ

CPEND   EQU     *       ; End of code section to be copied
*-----------------------------------------------------------


*-----------------------------------------------------------
* Bootstrap process:
* Copy all the boot code to OS memory space and start
* execution there.  This is everything from CPSTRT to CPEND.
*-----------------------------------------------------------
BTSTRP  LEA     KMEND+1,SP  ; If we don't start from a reset we need to set the stack pointer here
        LEA     CPSTRT,A1
        LEA     KMSTRT,A2
        LEA     CPEND,A3
        MOVE.W  (A1)+,(A2)+
        CMP     A1,A3
        BNE     *-4
        BRA     KMSTRT+BTSEQ-CPSTRT
*-----------------------------------------------------------
 
        END     BTSTRP





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
