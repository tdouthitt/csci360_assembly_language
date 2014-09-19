//KC03DDBA JOB ,'Taylor Douthitt',MSGCLASS=H
//STEP1 EXEC PGM=ASSIST
//STEPLIB DD DSN=KC02293.ASSIST.LOADLIB,DISP=SHR
//SYSPRINT DD SYSOUT=*
//SYSIN DD *
************************************************************
*  Program:     Assign5.JCL                                *
*  Programmer:  TAYLOR DOUTHITT                            *
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
*                    R6 - ADDRESS FOR XDECO                *
*                    R7 -                                  *
*                    R8 - DIVISION USE                     *
*                    R9 - DIVISION USE                     *
*                    R10 - PRINT COUNTER                   *
*                    R11 -                                 *
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
ASSIGN5 CSECT
    USING ASSIGN5,R15
*  CREATE A RESTORE POINT
    STM R0,R15,MAINSAVE
*
*   CALL TO SUBROUTINE BUILD
*
    LA R1,BLIST         reg 1 = address of BLIST
    L R15,=V(BUILD)      point r15 at build
    BALR R14,R15          branch to build
*
*   CALL TO SUBROUTINE PRINT
*
    LA R1,PLIST         reg 1 = address of BLIST
    L R15,=V(PRINT)      point r15 at build
    BALR R14,R15          branch to build
*
*   CALL TO SUBROUTINE SEARCH
*
*    LA R1,=SLIST         reg 1 = address of BLIST
*    L R15,=V(SEARCH)      point r15 at build
*    BALR R14,R15          branch to build
*
*   CALL TO SUBROUTINE PRINTE
*
*    LA R1,=PELIST         reg 1 = address of BLIST
*    L R15,=V(PRINTE)      point r15 at build
*    BALR R14,R15          branch to build
* END OF PROGRAM
    BR R14
***************************************************
*       STORAGE FOR MAIN STARTS HERE              *
***************************************************
MAINSAVE DS 18F
* TABLE STORAGE *
TABLE DS 60F
ENDTABLE DC C'*'
EOT DC A(ENDTABLE)
* INPUTLINE STORAGE *
INPUT DS 80C
END DC C'$'
* PARAMETER LISTS *
BLIST DC A(TABLE)
      DC A(ENDTABLE)
*
PLIST DC A(TABLE)
      DC A(ENDTABLE) 
*
SLIST DC A(TABLE)
      DC A(ENDTABLE)
      DC A(SNUM)
*
PELIST DC A(TABLE)
      DC A(ENDTABLE)
***************************************************
*               SUBROUTINE BUILD                  *
***************************************************
BUILD CSECT
* STANDARD ENTRY LINKAGE *
    STM R14,R12,12(13)    save the registers
    LR R12,R15            make 12 the base register
    USING BUILD,R12
    LA R14,BSAVE         point r14 at BSAVE
    ST R13,4(0,14)       save forward pointer in reg 13
    ST R14,8(0,13)       save backward pointer in reg 14
    LR R13,R14           point r13 at BSAVE
*
    LM R2,R3,0(1)        unload parameters
    L R4,0(R2)            reg 4 = table
*
    XREAD INPUT,80       READ FIRST RECORD IN FILE
*
*              OUTER LOOP TO PROCESS RECORDS *
OLOOP BC B'0100',ENDO  if eof then skip to end outer loop 
* 
    C R4,EOT            compare table and endtable
    BC B'1010',ENDO     if table full then skip to end outer loop
    LA R1,INPUT         load input into r1    
*
*               INNER LOOP TO EXTRACT VALUES *
ILOOP XDECI R5,0(,R1)   store converted form of input in r5                      
      BC B'0001',INVLD  if input invalid skip past storage phase
      C R5,=F'999999'   compare table value to 999999
      BE ENDO           if equal exit table build
*     
      ST R5,0(0,R4)     STORE NUMBER IN TABLE
      LA R4,4(0,R4)     ADVANCE TABLE
      B ILOOP           UC BRANCH TO TOP OF INNER LOOP
*
INVLD  CLI 0(R1),C'$'   scan for end of inputfile
      BE ENDI           if end of input branch to end of inner loop
* 
ENDI DS 0H              END OF INNER LOOP
      XREAD INPUT,80    READ NEXT RECORD             
      B OLOOP           UC BRANCH TO TOP OF OUTER LOOP
* 
ENDO DS 0H              END OF OUTER LOOP              
*
      ST R4,EOT         store last table entry as in EOT 
* STANDARD EXIT LINKAGE *
    L R13,4(0,13)        point r13 at caller save area
    LM R14,R12,12(13)    restore registers
    BR R14               return to caller
    LTORG
***************************************************
*      STORAGE FOR BUILD STARTS HERE              *
***************************************************
BSAVE DS 18F
***************************************************
*               SUBROUTINE PRINT                  *
***************************************************
PRINT CSECT
* STANDARD ENTRY LINKAGE *
    STM R14,R12,12(13)   save the registers
    LR R12,R15           make 12 the base register
    USING PRINT,R12
    LA R14,PSAVE         point r14 at PSAVE
    ST R13,4(0,14)      save forward pointer in reg 13
    ST R14,8(0,13)       save backward pointer in reg 14
    LR R13,R14           point r13 at PSAVE
*
    LM R2,R3,0(1)        unload parameters
    L R4,0(2)            reg 4 = table
*
* PRINT HEADER
      XPRNT HEADR,47
* PRINT TABLE VALUES(5 PER LINE)
PLOOP C R4,EOT           compare table to endtable
      BNL ENDPL          if table empty or finished skip to end of loop
      SR R10,R10         ZERO OUT COUNTER
      L R10,=F'5'        load value into counter
*
      LA R6,NUM          load address of num into reg 6
PRNT1 C R10,=F'0'        compare counter and zero
      BE PRNTN           if equal branch to prntline
      L R5,0(R4)         load table entry into reg 5
      XDECO R5,0(6)      put printable form in REG 6
      LA R4,4(R4)        advance the table
      C R4,EOT           compare table entry to endtable
      BNL PRNTN          if not eot branch to printline
      LA R6,20(R6)       advance to next num in storage
      S R10,=F'1'        subtract one from counter
      B PRNT1            UC BRANCH TO TOP OF LOOP
*
PRNTN XPRNT LINE,81
*
*        SECTION TO BLANK OUT PRINT LINES
*
      MVI LINE,C' '      move blank to end of printline
      MVC LINE+1(80),LINE blank out rest after line
      B PLOOP            UC branch to top of print loop
ENDPL DS 0H             END OF LOOP
*
* STANDARD EXIT LINKAGE *
    L R13,4(0,13)        point r13 at caller save area
    LM R14,R12,12(13)    restore registers
    BR R14               return to caller
    LTORG
***************************************************
*      STORAGE FOR PRINT STARTS HERE              *
***************************************************
PSAVE DS 18F
* PRINT LINE FOR HEADER
HEADR DC C'1'
      DC CL30' '
      DC C' TABLE CONTENTS '
* PRINT LINE FOR LIST OF NUMBERS
LINE DC C'0'
NUM  DS CL12
     DC CL8' '
NUM1 DS CL12
     DC CL8' '
NUM2 DS CL12
     DC CL8' '
NUM3 DS CL12
     DC CL8' '
***************************************************
*               SUBROUTINE SEARCH                 *
***************************************************
SEARCH CSECT
* STANDARD ENTRY LINKAGE *
    STM R14,R12,12(13)    save the registers
    LR R12,R15            make 12 the base register
    USING SEARCH,R12
    LA R14,SSAVE         point r14 at SSAVE
    ST R13,4(0,14)       save forward pointer in reg 13
    ST R14,8(0,13)       save backward pointer in reg 14
    LR R13,R14           point r13 at SSAVE
*
    LM R2,R3,0(1)        unload parameters
    L R4,0(R2)            reg 4 = table
* START OF CODE FOR SEARCH 
* STANDARD EXIT LINKAGE *
    L R13,4(0,13)        point r13 at caller save area
    LM R14,R12,12(13)    restore registers
    BR R14               return to caller
    LTORG
***************************************************
*      STORAGE FOR SEARCH STARTS HERE             *
***************************************************
SSAVE DS 18F
SHEAD DC C'1'
      DC CL30' '
      DC C'RESULTS OF SEARCHES'
FLINE DC C'0'
      DC CL30' '
      DC C'WE HAVE FOUND THE VALUE:'
      DC CL15' '
NFLINE DC C'0'
       DC CL30' '
       DC C'WE HAVE NOT FOUND THE VALUE:'
       DC CL15' '
SNUM   DS CL12
SINPUT DS CL80
ENDS   DC C'$'
***************************************************
*               SUBROUTINE PRINTE                 *
***************************************************
PRINTE CSECT
* STANDARD ENTRY LINKAGE *
    STM R14,R12,12(13)    save the registers
    LR R12,R15            make 12 the base register
    USING PRINTE,R12
    LA R14,PESAVE         point r14 at PESAVE
    ST R13,4(0,14)       save forward pointer in reg 13
    ST R14,8(0,13)       save backward pointer in reg 14
    LR R13,R14           point r13 at PESAVE
*   CODE FOR PRINTE STARTS HERE
    LM R2,R3,0(1)        unload parameters
    L R4,0(2)            reg 4 = table
*
* PRINT HEADER
      XPRNT HEADE,47
* PRINT EVEN TABLE VALUES(6 PER LINE)
PELOOP C R4,EOT           compare table to endtable
      BNL ENDPE          if table empty or finished skip to end of loop
      SR R10,R10         ZERO OUT COUNTER
      L R10,=F'6'        load value into counter
*
      LA R6,PNUM         load address of num into reg 6
PRNT2 C R10,=F'0'        compare counter and zero
      BE PRNTX           if equal branch to prntline
      L R5,0(R4)         load table entry into reg 5
      XDECO R5,0(6)      put printable form in REG 6
      LA R4,4(R4)        advance the table
      C R4,EOT           compare table entry to endtable
      BNL PRNTX          if not eot branch to printline
      LA R6,20(R6)       advance to next num in storage
      S R10,=F'1'        subtract one from counter
      B PRNT2            UC BRANCH TO TOP OF LOOP
*
PRNTX XPRNT LINEP,81
*
*        SECTION TO BLANK OUT PRINT LINES
*
      MVI LINEP,C' '      move blank to end of printline
      MVC LINEP+1(80),LINEP blank out rest after line
      B PELOOP            UC branch to top of print loop
ENDPE DS 0H             END OF LOOP
*CODE FOR PRINTE ENDS HERE
    LM R2,R3,0(1)        unload parameters
    L R4,0(R2)            reg 4 = table
* START OF CODE FOR SEARCH 
* STANDARD EXIT LINKAGE *
    L R13,4(0,13)        point r13 at caller save area
    LM R14,R12,12(13)    restore registers
    BR R14               return to caller
    LTORG
***************************************************
*      STORAGE FOR PRINTE STARTS HERE             *
***************************************************
PESAVE DS 18F
* PRINT LINE FOR HEADER
HEADE DC C'1'
      DC CL30' '
      DC C'LIST OF EVEN NUMBERS'
* PRINT LINE FOR LIST OF EVEN NUMBERS
LINEP DC C'0'
PNUM  DS CL12
     DC CL8' '
PNUM1 DS CL12
     DC CL8' '
PNUM2 DS CL12
     DC CL8' '
PNUM3 DS CL12
     DC CL8' '
        END ASSIGN5
//FT05F001  DD  *
1 -2005         515   90  50      -1    19 172219           60205
3       7534    204914           141  0 606031    -419  218 111
9001  312909    -517  9 62  89  305   250 305 118
000 -999     2    6509    -5   177   42        777

-84                 131  402   5106  121  -89 15   95221 -80
999999
305
306
19
-999
176
/*