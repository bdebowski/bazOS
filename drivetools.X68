*-----------------------------------------------------------
* Create a partition of size specified on the drive
* specified.  The read buffer must be at least as large as
* the block size of the drive.
*
* A1.L - Memory mapped address of the drive.
* A2.L - Address of read buffer
* D1.L - Size of read buffer
* D2.L - Desired size for partition (in Bytes)
* D0.W - Return value:
*   0 = Success
*   1 = Error
*-----------------------------------------------------------
DRIVETOOLS_CREATE_PARTITION
    * Seek to position 0 on the drive
    MOVE.L  D1,-(SP)
    CLR.L   D1
    BSR     EMULATEDHD_SEEK
    MOVE.L  (SP)+,D1

    * Read in Buffer Size number of Bytes from drive starting at Block 0
    BSR     EMULATEDHD_READ

    * Setup
    MOVE.L  #0,A3           ; A3 = Index to block size entry
    MOVE.L  (A2,A3),D3      ; D3 = Block size in Bytes
    ADDQ.L  #4,A3           ; A3 = Index to drive size entry
    MOVE.L  (A2,A3),D4      ; D4 = Drive size in Blocks
    ADDQ.L  #4,A3           ; A3 = index to first entry of Partition Table
    SUBQ.L  #1,D4           ; D4 = Drive remaining space in Blocks
    DIVU    D3,D2           ; D2.W = Desired size of partition in Blocks
    AND.L   #$0000FFFF,D2   ; Clear upper word of D2
    MOVE.L  (A2,A3),D5      ; D5 = Size in Blocks of Partition 0
    SUB.L   D5,D4           ; D4 - D5 = Drive remaining space in Blocks
    BRA     _DRIVETOOLS_001

    * Iterate Partition Table
_DRIVETOOLS_000
    ADDQ.L  #4,A3           ; A3 = index to next entry in PartitionTable
    MOVE.L  (A2,A3),D5      ; D5 = Size in Blocks of partion indexed by A3
    SUB.L   D5,D4           ; D4 - D5 = Drive remaining space in Blocks
_DRIVETOOLS_001
    CMP.L   #0,D5           ; D5 == 0?
    BNE     _DRIVETOOLS_000 ; Partition entry indexed by A3 not zero; keep looping

    * Now A3 is indexing the next available entry in the partition table
    * and D4 indicates the number of available blocks on the drive.

    * If there is not enough space for the partition then return an error.
    CMP.L   D2,D4
    BHS     _DRIVETOOLS_002 ; D4 - D2 >= 0; continue
    MOVE.W  #1,D0           ; Not enough space available.  Record the error and exit
    BRA     _DRIVETOOLS_003

_DRIVETOOLS_002
    * Seek to position 0 on the drive
    MOVE.L  D1,-(SP)
    CLR.L   D1
    BSR     EMULATEDHD_SEEK
    * Update the Partition Table in the buffer and write the first A3+4 Bytes
    * to the Drive
    MOVE.L  D2,(A2,A3)
    MOVE.L  A3,D1
    ADDQ.L  #4,D1
    BSR     EMULATEDHD_WRITE
    MOVE.L  (SP)+,D1

    * Exit
_DRIVETOOLS_003
    RTS


*-----------------------------------------------------------
* Return the block size in Bytes and the partition size in
* blocks.
*
* A1.L - Memory mapped address of the drive.
* D1.W - Index of partition to get info for.
* A0.W - Returns the block size in Bytes.
* D0.W - Returns the partition size in blocks.
*-----------------------------------------------------------
DRIVETOOLS_PARTITION_INFO
    RTS
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
