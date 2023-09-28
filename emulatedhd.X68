*-----------------------------------------------------------
* emulatedhd.X68
*
* Driver for Hard Drive Emulater on EASy68K.
* The HD is represented by a binary file named "HD0", "HD1",
* etc.
*-----------------------------------------------------------


*-----------------------------------------------------------
* Initialize the drive at slot specified mapped to address
* specified.  Must initialize the drive before using it.
*
* Uses 4 Bytes of space at (A1):
* 0-3 - File-ID
*
* A1.L - Address drive is mapped to.
* D1.W - Drive slot (0-9).
* D0.W - Return value:
*   0 = Success
*   Otherwise = Error
*-----------------------------------------------------------
EMULATEDHD_INIT
    MOVE.L  D1,-(SP)

    * Write the string "HDn",0 into memory at address A1
    MOVE.B  #'H',(A1)+
    MOVE.B  #'D',(A1)+
    ADD.B   #'0',D1
    MOVE.B  D1,(A1)+
    MOVE.B  #0,(A1)
    LEA     -3(A1),A1   ; restore A1

    * Open the file 'HDn' which represents the drive
    MOVE.L  #51,D0
    TRAP    #15         ; File-ID will be in D1.L, success indicator in D0.W
    
    * Write the File-ID into memory at address A1
    MOVE.L  D1,(A1)

    * Exit
    MOVE.L  (SP)+,D1
    RTS


*-----------------------------------------------------------
* Seek to position specified.
* A1.L - Address where HD is mapped to.
* D1.L - Offset/Position (in Bytes) to seek to.
* D0.W - Return value:
*   0 = Success
*   Otherwise = Error
*-----------------------------------------------------------
EMULATEDHD_SEEK
    MOVEM.L D2/D1,-(SP)

    * Position the file pointer
    MOVE.L  D1,D2
    MOVE.L  (A1),D1
    MOVE.L  #55,D0
    TRAP    #15         ; Position set, success indicator in D0.W

    * Exit
    MOVEM.L (SP)+,D2/D1
    RTS


*-----------------------------------------------------------
* Read N Bytes from the drive (at the current position) into
* the buffer.
* A1.L - Address where HD is mapped to.
* A2.L - Address of buffer to read into.
* D1.L - Number of Bytes to read; will contain number of
*   Bytes read once this returns.
* D0.W - Return value:
*   0 = Success
*   Otherwise = Error
*-----------------------------------------------------------
EMULATEDHD_READ
    MOVEM.L A1/D2,-(SP)

    * Do the read
    MOVE.L  D1,D2
    MOVE.L  (A1),D1
    MOVE.L  A2,A1
    MOVE.L  #53,D0
    TRAP    #15         ; Num Bytes read is in D2.L, Success indicator in D0.W

    * Exit
    MOVE.L  D2,D1       ; D1 = num Bytes read
    MOVEM.L (SP)+,A1/D2
    RTS


*-----------------------------------------------------------
* Write N Bytes to the drive (at the current position) from
* the buffer.
* A1.L - Address where HD is mapped to.
* A2.L - Address of buffer to transfer from.
* D1.L - Number of Bytes to write.
* D0.W - Return value:
*   0 = Success
*   Otherwise = Error
*-----------------------------------------------------------
EMULATEDHD_WRITE
    MOVEM.L A1/D2/D1,-(SP)

    * Do the write
    MOVE.L  D1,D2
    MOVE.L  (A1),D1
    MOVE.L  A2,A1
    MOVE.L  #54,D0
    TRAP    #15         ; Success indicator in D0.W

    * Exit
    MOVEM.L (SP)+,A1/D2/D1
    RTS

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
