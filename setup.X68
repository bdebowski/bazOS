    ORG     $000004
    INCLUDE "emulatedhd.X68"
    INCLUDE "drivetools.X68"

SRT LEA     HD0,A1
    BSR     EMULATEDHD_INIT
    LEA     BUF,A2
    MOVE.L  #512,D1
    MOVE.L  #(1024*1024),D2
    BSR     DRIVETOOLS_CREATE_PARTITION
    SIMHALT

    ORG     $001000
HD0 DS.B    4
BUF DS.B    512

    END     SRT

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
