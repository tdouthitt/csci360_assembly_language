//KC03DDBX JOB ,'Taylor Douthitt',MSGCLASS=H
//STEP1 EXEC PGM=ASSIST
//STEPLIB DD DSN=KC02293.ASSIST.LOADLIB,DISP=SHR
//SYSPRINT DD SYSOUT=*
//SYSIN DD *
************************************************************
*  Program:     Assign6.JCL                                *
*  Programmer:  TAYLOR DOUTHITT                            *
*  NAME: MAIN                                              *
*  FUNCTION:                                               *
*  INPUT: file - given sample input file                   *
*  OUTPUT: number list                                     *
*  ENTRY CONDS: NONE                                       *
*  REGISTER USAGE:   R1 -    *
*                    R2 - SUBROUTINE USE                   *
*                    R3 - SUBROUTINE USE                   *
*                    R4 - SUBROUTINE USE                   *
*                    R5 - INPUTLINE                        *
*                    R6 -                 *
*                    R7 - TABLE                            *
*                    R8 -                      *
*                    R9 -                      *
*                    R10 -                    *
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
ASSIGN6 CSECT
    USING ASSIGN6,R15
* STANDARD ENTRY LINKAGE *
    STM R14,R12,12(13)   save the registers
    LR R12,R15           make 12 the base register
    USING ASSIGN6,R12
    LA R14,MAINSAVE      point r14 at MAINSAVE
    ST R13,4(0,14)       save forward pointer in reg 13
    ST R14,8(0,13)       save backward pointer in reg 14
    LR R13,R14           point r13 at MAINSAVE
*
*   CALL TO SUBROUTINE BUILD
*
    LA R1,BLIST         reg 1 = address of BLIST
    L R15,=V(BUILD)      point r15 at build
    BALR R14,R15          branch to build
*
*   CALL TO SUBROUTINE PRINT
*
*    LA R1,PLIST         reg 1 = address of BLIST
*    L R15,=V(PRINT)      point r15 at build
*    BALR R14,R15          branch to build
*
*   CALL TO SUBROUTINE SORT
*
*    LA R1,=SLIST         reg 1 = address of BLIST
*    L R15,=V(SORT)      point r15 at build
*    BALR R14,R15          branch to build
*
*   CALL TO SUBROUTINE TALLY
*
*    LA R1,=TLIST         reg 1 = address of BLIST
*    L R15,=V(TALLY)      point r15 at build
*    BALR R14,R15          branch to build
* END OF PROGRAM
* STANDARD EXIT LINKAGE *
    L R13,4(0,13)        point r13 at caller save area
    LM R14,R12,12(13)    restore registers
    BR R14
***************************************************
*       STORAGE FOR MAIN STARTS HERE              *
***************************************************
MAINSAVE DS 18F
* TABLE STORAGE *
TABLE DS 70CL48
ENDTABLE DC C'*'
EOT DC A(ENDTABLE)
* INPUTLINE STORAGE *
INPUT DS 80C
END DC C'$'
* PARAMETER LISTS *
BLIST DC A(TABLE)
      DC A(ENDTABLE)
      DC A(INPUT)
*
PLIST DC A(TABLE)
      DC A(ENDTABLE) 
*
SLIST DC A(TABLE)
      DC A(ENDTABLE)
      DC A(INPUT)
*
TLIST DC A(TABLE)
      DC A(ENDTABLE)
      LTORG
***************************************************
*               SUBROUTINE BUILD                  *
***************************************************
BUILD CSECT
* STANDARD ENTRY LINKAGE *
    STM R14,R12,12(13)   save the registers
    LR R12,R15           make 12 the base register
    USING BUILD,R12
    LA R14,BSAVE         point r14 at BSAVE
    ST R13,4(0,14)       save forward pointer in reg 13
    ST R14,8(0,13)       save backward pointer in reg 14
    LR R13,R14           point r13 at BSAVE
*
    LM R2,R4,0(1)        unload parameters
    L R7,0(R2)           reg 7 = table
*
    XREAD 0(R4),80       READ FIRST RECORD IN FILE
*
*              OUTER LOOP TO PROCESS RECORDS *
OLOOP BC B'0100',ENDO  if eof then skip to end outer loop 
* 
*   CLC R7,ENDTABLE        compare table and endtable
    BC B'1010',ENDO     if table full then skip to end outer loop
    LA R1,0(R4)            load input into r1    
*
*               INNER LOOP TO EXTRACT VALUES *
ILOOP DS 0H             INNER LOOP                            
*      CLI 0(R1),C'$'    scan for end of inputfile
      BE ENDI           if end of input branch to end of inner loop
*     
      MVC 0(10,R7),INPUT     MOVE DATA FOR FIRST NAME
      MVC 48(10,R7),INPUT+12   MOVE DATA FOR LAST NAME
      MVC 96(8,R7),INPUT+45    MOVE DATA FOR BALANCE
      MVC 144(1,R7),INPUT+52    MOVE DATA FOR BALANCE SIGN
      MVC 192(9,R7),INPUT+24    MOVE DATA FOR PASSWORD    
      MVC 240(7,R7),INPUT+55    MOVE DATA FOR EXPIRATION DATE    
      MVC 288(8,R7),INPUT+34    MOVE DATA FOR IDNUM
      MVC 336(1,R7),INPUT+56
      B ILOOP           UC BRANCH TO TOP OF INNER LOOP      
*    
      PACK 96(8,R7),96(R7)
ENDI DS 0H              END OF INNER LOOP             
      B OLOOP           UC BRANCH TO TOP OF OUTER LOOP
* 
ENDO DS 0H              END OF OUTER LOOP              
*
*      ST R7,EOT         store last table entry as in EOT
      XDUMP TABLE,8      
* STANDARD EXIT LINKAGE *
    L R13,4(0,13)        point r13 at caller save area
    LM R14,R12,12(13)    restore registers
    BR R14               return to caller
    LTORG
***************************************************
*      STORAGE FOR BUILD STARTS HERE              *
***************************************************
BSAVE DS 18F
            END ASSIGN6
//FT05F001  DD  DSN=KC02314.SUMMER11.CSCI360.HW6DATA,DISP=SHR