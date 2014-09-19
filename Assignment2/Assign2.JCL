//KC03DDBA JOB ,'Taylor Douthitt',MSGCLASS=H
//STEP1    EXEC  PGM=ASSIST
//STEPLIB    DD  DSN=KC02293.ASSIST.LOADLIB,DISP=SHR
//SYSPRINT   DD  SYSOUT=*
//SYSIN      DD  *
************************************************************
*  Program:     Assign2.JCL                                *
*  Programmer:  Taylor Douthitt                            *
*  NAME: MAIN                                              *
*  FUNCTION:                                               *
*  INPUT: NONE                                             *
*  OUTPUT:                                                 *
*  ENTRY CONDS: NONE                                       *
*  REGISTER USAGE:   R1 - XDECI Usage                      *
*                    R2 - SUM                              *
*                    R3 - TOTALSUM                         *
*                    R4 - LINE COUNT                       *
*                    R5 - NUM1                             *
*                    R6 - NUM2                             *
*                    R7 - NUM3                             *
*                    14 - exit address                     *
*                    15 - base register                    *
*  EXIT CONDS:  NONE                                       *
*  PSEUDOCODE:                                             *
*  NOTES:                                                  *
************************************************************
R1 EQU 1
R2 EQU 2
R3 EQU 3
R4 EQU 4
R5 EQU 5
R6 EQU 6
R7 EQU 7
MAIN CSECT
     USING MAIN,15
     SR R4,R4 Initialize variables
     SR R3,R3
     XREAD FILE,80 Read the first record
TOP  BC B'0100',ENDLOOP Top of loop and condition
     SR R2,R2 Reset line sum
     XDECI R5,FILE Process record with XDECI
     XDECI R6,0(1)
     XDECI R7,0(1)
     AR R2,R5       Add values to line sum
     AR R2,R6
     AR R2,R7
     XDECO R5,NUM1  Change values to character info for print
     XDECO R6,NUM2
     XDECO R7,NUM3
     XDECO R2,SUM
     XPRNT PLINE,88 Print table of values
     AR R3,R2  Add line sum to total
     A R4,SPACE Increment line count
     XREAD FILE,80 Read next record
     BC B'1111',TOP Return to top of loop
ENDLOOP DS 0H End of loop
     XDECO R3,TOTAL Total statistics display
     XDECO R4,LINES
     XPRNT PRINT,63
     BR 14
SPACE  DC F'1'
PLINE DC C' '
      DC C'A = '
NUM1 DS CL12
     DC C'      B = '
NUM2 DS CL12
     DC C'      C = '
NUM3 DS CL12
     DC C'      SUM = '
SUM  DS CL12
PRINT DC C' '
      DC C'Number of Lines = '
LINES DS CL12
     DC C'      Grand Total = '
TOTAL DS CL12
FILE   DS CL80
          END MAIN
/*
//FT05F001   DD  *
12  34  56
45  98  23
55  88  99
10  09  32
66  22  07
98  76  54
/*
//FT06F001   DD SYSOUT=*
//