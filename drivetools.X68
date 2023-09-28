*-----------------------------------------------------------
* Create a partition of size specified on the drive
* specified.  Assumes that the read buffer size is 1:1 with 
* the block size on the drive.
* A1.L - Memory mapped address of the drive.
* A2.L - Address of read buffer
* D1.L - Size of read buffer (and Block Size on the drive.)
* D2.L - Desired size for partition.
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

    * Read in Block 0 of the drive which contains the drive size
    * and the partition table.
    BSR     EMULATEDHD_READ

    * Determine available space = DriveSize - BlockSize - SizeOfExistingPartitions
    * Determine also first available partition table index, and 
    * first available block index.
    MOVE.L  (A2),D3             ; D3 = Size of drive
    MOVE.L  A2,A3               ; A3 = Partion Table Index
    ADD.L   #4,A3
    MOVE.L  D1,A4               ; A4 = Next available Byte on drive
    CLR.L   D4                  ; D4 = Total size of all partitions
    MOVE.L  (A3)+,D5            ; D5 = Size of current partition
    ADD.L   D5,D4
    ADD.L   D5,A4
    
    

* Read the partition table to get the index of the next
* available partition, and to compute the space used by
* existing partitions.

* If there is not enough space for the partition then return
* an error.

* Enter the partition size into the partition table at the
* next available index.

* Exit
        RTS


*-----------------------------------------------------------
* Create a logical partition and format it to bazFS format.
* p1.L - Address of null terminated string specifying drive
*   file name/path.
* p2.L - Address of 8 Byte (8 characters) long name for the
*   logical partition.
* p3.L - Desired size for the partition in Bytes.
* p4.W - Return value:
*   0 = Success
*   1 = Error
*-----------------------------------------------------------
DRIVETOOLS_FORMAT
* Open the disk file
* Determine the disk file size
        RTS





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
