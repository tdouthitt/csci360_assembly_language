//KC03DDBR JOB ,'Taylor Douthitt',MSGCLASS=H
//STEP1 EXEC PGM=ASSIST
//STEPLIB DD DSN=KC02293.ASSIST.LOADLIB,DISP=SHR
//SYSPRINT DD SYSOUT=*
//SYSIN DD *
************************************************************
*  Program:     Assign4.JCL                                *
*  Programmer:  Taylor Douthitt                            *
*  NAME: MAIN                                              *
*  FUNCTION:                                               *
*  INPUT: file - given sample input file                   *
*  OUTPUT: number list                                     *
*  ENTRY CONDS: NONE                                       *
*  REGISTER USAGE:   R1 - Parameter List Usage/xDECI use   *
*                    R2 - SUBROUTINE USE                   *
*                    R3 - SUBROUTINE USE                   *
*                    R4 - TABLE                            *
*                    R5 - INPUTLINE                        *
*                    R8 - DIVISION USE                     *
*                    R9 - DIVISION USE                     *
*                    R10 - PRINT COUNTER                   *
*                    R11 - Subroutine return address       *
*                    R12 - BASE REGISTER                   *
*                    R13 - A(LOCAL SAVE AREA)              *
*                    R14 - Return address                  *
*                    R15 - V(SUBROUTINE)                   *
*  EXIT CONDS:  NONE                                       *
*  PSEUDOCODE:                                             *
*  NOTES:                                                  *
************************************************************
R0 EQU 0
R1 EQU 1
R2 EQU 2
R3 EQU 3
R4 EQU 4
R5 EQU 5
R6 EQU 6
R7 EQU 7
R8 EQU 8
R9 EQU 9
R10 EQU 10
R11 EQU 11
R12 EQU 12
R13 EQU 13
R14 EQU 14
R15 EQU 15
ASSIGN4 CSECT
    USING ASSIGN4,15
    STM R0,R15,SAVE CREATE A RESTORE POINT SAVE
    LA R4,TABLE POINT REG 4 AT TABLE
* CALL TO ROUTINE BUILD    
    LA R1,PARMB  REG 1 = ADDRESS OF PARMB
    BAL R11,BUILD  BRANCH TO BUILD
* CALL TO ROUTINE PRINT
    LA R1,PARMP
    BAL R11,PRINT
* CALL TO ROUTINE PRINTO
          LTORG    
    BR 14   EXIT PROGRAM 
*
*
************************************************************
* SPECIFICATIONS FOR SUBROUTINE: BUILD                     *
* INPUT PARAMETERS: TABLE                                  *
*                   ENDTABLE                               *
************************************************************    
BUILD DS 0H
*
      STM R0,R15,BSAVE Store registers 0-15 at BSAVE for recovery
*
      XREAD INPUT,80 READ FIRST RECORD IN FILE
*
OLOOP BC B'0100',ENDL1 (if EOF,loop ends) - OUTERLOOP>
* 
      C R4,EOT if table full loop ends
      BC B'1010',ENDL1
      LA R1,INPUT      
*
ILOOP XDECI R5,0(,R1)                         INNERLOOP>
      BC B'0001',OVER  
*     
      ST R5,0(0,R4) STORE NUMBER IN TABLE
      LA R4,4(0,R4) ADVANCE TABLE
      B ILOOP    UC BRANCH TO TOP OF INNER LOOP
OVER  CLI 0(R1),C'$'
      BE ENDIN
* 
ENDIN DS 0H
      XREAD INPUT,80 NEXT RECORD             INNERLOOP<
      B OLOOP  UC BRANCH TO TOP OF OUTER LOOP
* 
ENDL1 DS 0H                                 OUTERLOOP<
*
      ST R4,EOT
      LM R0,R15,BSAVE RESTORE REGS 0-15 FROM STORAGE BSAVE
      BR R11 EXIT TO MAIN PROGRAM
*
*
*
************************************************************
* SPECIFICATIONS FOR SUBROUTINE: PRINT                     *
* INPUT PARAMETERS: TABLE                                  *
************************************************************
PRINT DS 0H
*
      STM R0,R15,PSAVE Store registers 0-15 at PSAVE for recovery
* PRINT HEADER
      XPRNT HEADR,16
      LA R4,TABLE  POINT R4 AT TABLE
LOOP2 C R4,EOT compare table to endtable
      BNL ENDL2
      SR R10,R10   ZERO OUT COUNTER
      L R10,=F'4' 
*
      LA R12,NUM
PRNT1 C R10,=F'0'
      BE PRNTN
      L R5,0(R4)
      XDECO R5,0(12) put printable form in REG 12
      LA R4,4(R4) advance the table
      C R4,EOT
      BNL PRNTN
      LA R12,20(R12)
      S R10,=F'1'
      B PRNT1 TO TOP OF LOOP
*
PRNTN XPRNT LINE,81
*
* SECTION TO BLANK OUT PRINT LINES
*
      MVI LINE,C' '
      MVC LINE+1(80),LINE
      B LOOP2
ENDL2 DS 0H  END OF LOOP
*
      LM R0,R15,PSAVE RESTORE REGS 0-15 FROM STORAGE PSAVE
*
      BR R11 EXIT TO MAIN(CALLING) PROGRAM
*
*
*
*
EOT DC A(ENDTABLE)
*
* STORAGE FOR BUILD STARTS HERE *
*
BSAVE DS 16F
*
PARMB DC A(TABLE)
      DC A(ENDTABLE)
*
* STORAGE FOR PRINT STARTS HERE *
*
PSAVE DS 16F
PARMP DC A(TABLE)
      DC A(ENDTABLE)
*
* STORAGE FOR MAIN STARTS HERE
*
TABLE DS 60F
ENDTABLE DC C'*'
*
SAVE DS 16F
*
INPUT DS 80C
END DC C'*'
*
HEADR DC C' '
      DC C'LIST OF NUMBERS'
*
LINE DC C'0'
NUM  DS CL12
     DC CL8' '
NUM1 DS CL12
     DC CL8' '
NUM2 DS CL12
     DC CL8' '
NUM3 DS CL12
     DC CL8' '
        END ASSIGN4
//FT05F001  DD  *
1 -2005         515   90  50      -1    19 172219           60205
3       7534    204914           141  0 606031    -419	218 111
9001  312909    -517  9 62  89  305   250 305 118
000 -999     2    6509    -5   177   42        777

-84                 131  402   5106  121  -89 15   95221 -80
/*