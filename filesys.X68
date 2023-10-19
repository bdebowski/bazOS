*-----------------------------------------------------------
* Format the partition specified into bazFS format.
*
* A1.L - Memory mapped address of the drive.
* D1.W - Index of partition to format.
* D0.W - Return value:
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
