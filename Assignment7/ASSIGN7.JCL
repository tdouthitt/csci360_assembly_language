//KC03DDBL JOB ,'Taylor Douthitt',MSGCLASS=H
//STEP1 EXEC PGM=ASSIST
//STEPLIB DD DSN=KC02293.ASSIST.LOADLIB,DISP=SHR
//SYSPRINT DD SYSOUT=*
//SYSIN DD *
************************************************************
*  Program:     Assign7.JCL                                *
*  Programmer:  TAYLOR DOUTHITT                            *
*  NAME: MAIN                                              *
*  FUNCTION:                                               *
*  INPUT: file - given sample input file                   *
*  OUTPUT: number list                                     *
*  ENTRY CONDS: NONE                                       *
*  REGISTER USAGE:   R0 - PASSING PARAMETER                *
*                    R1 - PARAMETER LIST USAGE             *
*                    R2 - SUBROUTINE USE                   *
*                    R3 - SUBROUTINE USE                   *
*                    R4 - SUBROUTINE USE                   *
*                    R5 - SUBROUTINE USE                   *
*                    R6 - SUBROUTINE USE                   *
*                    R7 - SUBROUTINE USE                   *
*                    R8 - TABLE1                           *
*                    R9 - TABLE2                           *
*                    R10 - TABLE3                          *
*                    R11 - INPUTLINE                       *
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
*
$ENTRY   DSECT
$LNAME   DS    12C
$FNAME   DS    12C
$LID     DS    7C
$SEX     DS    C
*
ASSIGN7  CSECT
*
*
* STANDARD ENTRY LINKAGE *
*
         STM   R14,R12,12(13)    save the registers
         LR    R12,R15           make 12 the base register
         USING ASSIGN7,R12
         LA    R14,MAINSAVE      point r14 at MAINSAVE
         ST    R13,4(0,14)       save forward pointer in reg 13
         ST    R14,8(0,13)       save backward pointer in reg 14
         LR    R13,R14           point r13 at MAINSAVE
         LA    R11,4095(,R12)    advance reg 11 to end base reg12
         LA    R11,1(,R11)       move reg11 to 1 after end reg12
         USING ASSIGN7+4095,R11  make reg11 the base reg
*
*   CALL TO SUBROUTINE BUILD1
* 
         LA    R1,BLIST1         reg 1 = address of BLIST1
         L     R15,=V(BUILD1)    point r15 at build1
         BALR  R14,R15           branch to build1
*
*
*   CALL TO SUBROUTINE PRINT
*
         LA    R1,PLIST1          reg 1 = address of PLIST
         L     R15,=V(PRINT)      point r15 at PRINT
         BALR  R14,R15            branch to PRINT
*
*   CALL TO SUBROUTINE BUILD2
*
         LA    R1,BLIST2         reg 1 = address of BLIST2
         L     R15,=V(BUILD2)    point r15 at build2
         BALR  R14,R15           branch to build2
*
*   CALL TO SUBROUTINE PRINT
*
         LA    R1,PLIST2          reg 1 = address of PLIST
         L     R15,=V(PRINT)      point r15 at PRINT
         BALR  R14,R15            branch to PRINT
*
*   CALL TO SUBROUTINE SORT
*
         LA    R1,SLIST1           reg 1 = address of SLIST
         L     R15,=V(SORT)       point r15 at SORT
         BALR  R14,R15            branch to SORT
*
*   CALL TO SUBROUTINE PRINT
*
         LA    R1,PLIST1          reg 1 = address of PLIST
         L     R15,=V(PRINT)      point r15 at PRINT
         BALR  R14,R15            branch to PRINT
*
*   CALL TO SUBROUTINE SORT
*
         LA    R1,SLIST2          reg 1 = address of SLIST
         L     R15,=V(SORT)       point r15 at SORT
         BALR  R14,R15            branch to SORT
*
*   CALL TO SUBROUTINE PRINT
*
         LA    R1,PLIST2          reg 1 = address of PLIST
         L     R15,=V(PRINT)      point r15 at PRINT
         BALR  R14,R15            branch to PRINT
*
*   CALL TO SUBROUTINE MERGE
*
         LA    R1,MLIST           reg 1 = address of MLIST
         L     R15,=V(MERGE)      point r15 at MERGE
         BALR  R14,R15            branch to MERGE
*
*   CALL TO SUBROUTINE PRINT
*
         LA    R1,PLIST3          reg 1 = address of PLIST
         L     R15,=V(PRINT)      point r15 at PRINT
         BALR  R14,R15            branch to PRINT   
* END OF PROGRAM
* STANDARD EXIT LINKAGE *
         L     R13,4(0,13)        point r13 at caller save area
         LM    R14,R12,12(13)     restore registers
         BR    R14
         LTORG
***************************************************
*       STORAGE FOR MAIN STARTS HERE              *
***************************************************
MAINSAVE DS    18F
*
*        PARAMETER LISTS
*     
BLIST1   DC    A(TABLE1)
         DC    A(EOT1)
         DC    A(DWNTAB)
         DC    A(UPPTAB)
*       
BLIST2   DC    A(TABLE2)
         DC    A(EOT2)
         DC    A(DWNTAB)
         DC    A(UPPTAB)
*
PLIST1   DC    A(TABLE1)
         DC    A(EOT1)
         DC    A(CAP1)
*
PLIST2   DC    A(TABLE2)
         DC    A(EOT2)
         DC    A(CAP2)
*
PLIST3   DC    A(TABLE3)
         DC    A(EOT3)
         DC    A(CAP3)
*
*
*
SLIST1   DC    A(TABLE1)
         DC    A(EOT1)
*
SLIST2   DC    A(TABLE2)
         DC    A(EOT2)
*
MLIST    DC    A(TABLE1)
         DC    A(TABLE2)
         DC    A(TABLE3)
         DC    A(EOT1)
         DC    A(EOT2)
         DC    A(EOT3)
*
*
*   PAGE HEADER
CAP1     DC    C'1'
         DC    CL48' '
         DC    C' FIRST LIST OF CLIENTS'
*   PAGE HEADER
CAP2     DC    C'1'
         DC    CL48' '
         DC    C'SECOND LIST OF CLIENTS'
*   PAGE HEADER
CAP3     DC    C'1'
         DC    CL48' '
         DC    C'MASTER LIST OF CLIENTS'
* TRANSLATE TABLES
UPPTAB   DC    X'000102030405060708090A0B0C0D0E0F'                                          
         DC    X'101112131415161718191A1B1C1D1E1F'                                          
         DC    X'202122232425262728292A2B2C2D2E2F'                                          
         DC    X'303132333435363738393A3B3C3D3E3F'                                          
         DC    X'404142434445464748494A4B4C4D4E4F'                                          
         DC    X'505152535455565758595A5B5C5D5E5F'                                          
         DC    X'606162636465666768696A6B6C6D6E6F'                                          
         DC    X'707172737475767778797A7B7C7D7E7F'                                          
         DC    X'80C1C2C3C4C5C6C7C8C98A8B8C8D8E8F'                                          
         DC    X'90D1D2D3D4D5D6D7D8D99A9B9C9D9E9F'                                          
         DC    X'A0A1E2E3E4E5E6E7E8E9AAABACADAEAF'                                          
         DC    X'B0B1B2B3B4B5B6B7B8B9BABBBCBDBEBF'                                          
         DC    X'C0C1C2C3C4C5C6C7C8C9CACBCCCDCECF'                                          
         DC    X'D0D1D2D3D4D5D6D7D8D9DADBDCDDDEDF'                                          
         DC    X'E0E1E2E3E4E5E6E7E8E9EAEBECEDEEEF'                                          
         DC    X'F0F1F2F3F4F5F6F7F8F9FAFBFCFDFEFF'                                          
*              TR TABLE FROM UPPER TO LOWER                                                 
DWNTAB   DC    X'000102030405060708090A0B0C0D0E0F'                                          
         DC    X'101112131415161718191A1B1C1D1E1F'                                          
         DC    X'202122232425262728292A2B2C2D2E2F'                                          
         DC    X'303132333435363738393A3B3C3D3E3F'                                          
         DC    X'404142434445464748494A4B4C4D4E4F'                                          
         DC    X'505152535455565758595A5B5C5D5E5F'                                          
         DC    X'606162636465666768696A6B6C6D6E6F'                                          
         DC    X'707172737475767778797A7B7C7D7E7F'                                          
         DC    X'808182838485868788898A8B8C8D8E8F'                                          
         DC    X'909192939495969798999A9B9C9D9E9F'                                          
         DC    X'A0A1A2A3A4A5A6A7A8A9AAABACADAEAF'                                          
         DC    X'B0B1B2B3B4B5B6B7B8B9BABBBCBDBEBF'                                          
         DC    X'C0818283848586878889CACBCCCDCECF'                                          
         DC    X'D0919293949596979899DADBDCDDDEDF'                                          
         DC    X'E0E1A2A3A4A5A6A7A8A9EAEBECEDEEEF'                                          
         DC    X'F0F1F2F3F4F5F6F7F8F9FAFBFCFDFEFF' 
* FIRST TABLE
TABLE1   DS    30CL32
END1     DC    C'$'
EOT1     DC    A(END1)
* SECOND TABLE
TABLE2   DS    30CL32
END2     DC    C'$'
EOT2     DC    A(END2)
* MERGE TABLE
TABLE3   DS    60CL32
END3     DC    C'$'
EOT3     DC    A(END3)
***************************************************
*               SUBROUTINE BUILD1                 *
***************************************************
BUILD1   CSECT
* STANDARD ENTRY LINKAGE *
         STM   R14,R12,12(13)     save the registers
         LR    R12,R15            make 12 the base register
         USING BUILD1,R12
         LA    R14,BSAVE1         point r14 at BSAVE1
         ST    R13,4(0,14)        save forward pointer in reg 13
         ST    R14,8(0,13)        save backward pointer in reg 14
         LR    R13,R14            point r13 at BSAVE1
*
         LM    R2,R5,0(1)         unload parameters
         USING $ENTRY,R2
*
         XREAD INPUT,80           READ FIRST RECORD IN FILE
*
*              LOOP TO PROCESS RECORDS *
OLOOP    BC    B'0100',ENDO       if eof then skip to end Loop                     
*        
         MVC   COMP(4),INPUT
         CLC   COMP,=C'----'      COMPARE INPUT TO LAST FILE 
         BE    ENDO       IF EQUAL THEN EXIT LOOP
*
         MVC   $LNAME(12),INPUT+11 MOVE DATA FOR LAST NAME
         TR    $LNAME(1),0(R5)    CHANGE FIRST LETTER TO UPP
         TR    $LNAME+1(11),0(R4)  CHANGE REST OF WORD TO LOWER
*
         MVC   $FNAME(10),INPUT   MOVE DATA FOR FIRST NAME
         TR    $FNAME(1),0(R5)    CHANGE FIRST LETTER TO UPP
         TR    $FNAME+1(9),0(R4)  CHANGE REST OF WORD TO LOWER
*
         MVC   $LID(2),GP         MOVE GP INTO ID 
         MVC   $LID+2(5),INPUT+24 MOVE DATA FOR LOGON ID 
*   
         MVC   $SEX(1),INPUT+30   MOVE DATA FOR SEX
*
         LA    R2,32(R2)          ADVANCE TABLE
*
         XREAD INPUT,80           READ NEXT RECORD IN INPUT FILE
*            
         B     OLOOP              UC BRANCH TO TOP OF LOOP
* 
ENDO DS 0H              END OF LOOP              
*
*         S     R2,=F'32'
         ST    R2,0(R3)           store last table entry in EOT
*  
         DROP  R2                 STOP USING DSECT
* STANDARD EXIT LINKAGE *
         L     R13,4(0,13)        point r13 at caller save area
         LM    R14,R12,12(13)    restore registers
         BR    R14               return to caller
         LTORG
***************************************************
*      STORAGE FOR BUILD1 STARTS HERE             *
***************************************************
BSAVE1   DS    18F
* LINE TO INSERT IN LOGON ID
GP       DC    C'GP'
* INPUT LINE
INPUT    DS    CL80
COMP     DS    CL4
***************************************************
*               SUBROUTINE BUILD2                 *
***************************************************
BUILD2   CSECT
* STANDARD ENTRY LINKAGE *
         STM   R14,R12,12(13)     save the registers
         LR    R12,R15            make 12 the base register
         USING BUILD2,R12
         LA    R14,BSAVE2         point r14 at BSAVE2
         ST    R13,4(0,14)        save forward pointer in reg 13
         ST    R14,8(0,13)        save backward pointer in reg 14
         LR    R13,R14            point r13 at BSAVE2
*
         LM    R2,R5,0(R1)        unload parameters
         USING $ENTRY,R2          USING STATEMENT FOR DSECT
*
         XREAD INPUT1,80          READ FIRST RECORD IN FILE
*
*              LOOP TO PROCESS RECORDS *
OLOOP1   BC    B'0100',ENDO1      if eof then skip to end Loop                     
*
         MVC   $LNAME(10),INPUT1+8 MOVE DATA FOR LAST NAME
         TR    $LNAME(1),0(R5)    CHANGE FIRST LETTER TO UPP
         TR    $LNAME+1(9),0(R4)  CHANGE REST OF WORD TO LOWER
*
         MVC   $FNAME(12),INPUT1+19 MOVE DATA FOR FIRST NAME
         TR    $FNAME(1),0(R5)    CHANGE FIRST LETTER TO UPP
         TR    $FNAME+1(11),0(R4) CHANGE REST OF WORD TO LOWER
* 
         MVC   $LID(7),INPUT1     MOVE DATA FOR LOGON ID 
*   
         MVC   $SEX(1),INPUT1+32  MOVE DATA FOR SEX
*
         LA    R2,32(R2)          ADVANCE TABLE
*
         XREAD INPUT1,80          READ NEXT RECORD IN INPUT FILE
*            
         B     OLOOP1             UC BRANCH TO TOP OF LOOP
* 
ENDO1    DS    0H                 END OF LOOP              
*
*         S     R2,=F'32'
         ST    R2,0(R3)           store last table entry in EOT
*  
         DROP  R2                 STOP USING DSECT
*   
* STANDARD EXIT LINKAGE *
         L     R13,4(0,13)        point r13 at caller save area
         LM    R14,R12,12(13)     restore registers
         BR    R14                return to caller
         LTORG
***************************************************
*      STORAGE FOR BUILD2 STARTS HERE             *
***************************************************
BSAVE2   DS    18F
* INPUT LINE
INPUT1   DS    CL80
***************************************************
*               SUBROUTINE PRINT                  *
***************************************************
PRINT    CSECT
* STANDARD ENTRY LINKAGE *
         STM   R14,R12,12(13)     save the registers
         LR    R12,R15            make 12 the base register
         USING PRINT,R12
         LA    R14,PSAVE          point r14 at PSAVE
         ST    R13,4(0,14)        save forward pointer in reg 13
         ST    R14,8(0,13)        save backward pointer in reg 14
         LR    R13,R14            point r13 at PSAVE
*
         LM    R2,R5,0(1)         unload parameters
         USING $ENTRY,R2          USING STATEMENT FOR DSECT
*     
*         ZAP   LNNUM,=P'0'        INITIALIZE LNNUM TO 0
*         ZAP   PGNUM,=P'1'        INITIALIZE PGNUM TO 1
         XDUMP
         XPRNT 0(R4),71
         XPRNT CHEAD,61
*            LOOP TO PRINT OUT TABLE VALUES   *
PLOOP    DS    0H                 TOP OF LOOP
*
         C     R2,0(R3)           COMPARE TABLE AND ENDTABLE
         BNL   ENDLP              IF EQUAL EXIT LOOP
*       
         MVC   FIRST(10),$FNAME   MOVE FIRST NAME TO FW
*
         MVC   LAST(12),$LNAME    MOVE LAST NAME TO FW
*
         MVC   ID(7),$LID         MOVE ID NUMBER TO FW
*
         MVC   SEX(1),$SEX        MOVE SEX TO FULLWORD
*
         XPRNT PLINE,60           PRINT INFO
*
         LA    R2,32(R2)          ADVANCE TABLE         
         CLI   0(R2),C'$'         
         B     PLOOP              UC BRANCH TO PLOOP     
ENDLP    DS    0H                 BOTTOM OF LOOP
*
         DROP  R2                 END OF USING DSECT         
* STANDARD EXIT LINKAGE *
         L     R13,4(0,13)        point r13 at caller save area
         LM    R14,R12,12(13)     restore registers
         BR    R14                return to caller
         LTORG
***************************************************
*      STORAGE FOR PRINT STARTS HERE              *
***************************************************
PSAVE    DS    18F
* PACK DECIMAL TO KEEP TRACK OF LINES PRINTED(MAX 40)
LNNUM    DS    PL2
* PACK DECIMAL TO KEEP TRACK OF PAGE NUMBER
PGNUM    DS    PL1   
*   COLUMN HEADER
CHEAD    DC    C'-'
         DC    CL5' '
         DC    C'FIRST NAME'
         DC    CL10' '
         DC    C'LAST NAME'
         DC    CL10' '
         DC    C'LOGON ID'
         DC    CL5' '
         DC    C'SEX' 
*   DATA LISTS
PLINE    DC    C'0'
         DC    CL5' '
FIRST    DS    CL10
         DC    CL10' '
LAST     DS    CL12
         DC    CL8' ' 
ID       DS    CL7 
         DC    CL6' '
SEX      DS    CL1      
***************************************************
*               SUBROUTINE SORT                   *
*               R7 - BEGIN                        *
*               R8 - END                          *
*               R9 - I                            *
*               R10 - LOW                         *
***************************************************
SORT     CSECT
* STANDARD ENTRY LINKAGE *
         STM   R14,R12,12(13)     save the registers
         LR    R12,R15            make 12 the base register
         USING SORT,R12
         LA    R14,SSAVE          point r14 at SSAVE
         ST    R13,4(0,14)        save forward pointer in reg 13
         ST    R14,8(0,13)        save backward pointer in reg 14
         LR    R13,R14            point r13 at SSAVE
*
         LM    R2,R3,0(1)         unload parameters
* CODE TO SORT TABLE VALUES STARTS HERE *
         LR    R7,R2              LOAD 1ST LAST NAME INTO REG8
         L     R8,0(R3)            LOAD END OF TABLE INTO REG9
*
LOOP1    CR    R7,R8              COMPARE FIRST ENTRY & EOT
         BNL   ENDL1              IF BEGIN > END EXIT LOOP1
*
         LR    R10,R7             LOAD R8 INTO R10
*
         LA    R9,32(R7)          LOAD R7 WITH NEXT LAST NAME
*
LOOP2    CR     R9,R8             COMPARE I AND END
         BNL   ENDL2              IF I > END EXIT LOOP2
*      
IF       CLC   0(24,R10),0(R9)    COMPARE ENTRY TO NEXT ENTRY
         BL    ENDIF              IF FIRST ENTRY LOW THEN SKIP TO ENDIF
         LR    R10,R9             LOW = I
ENDIF    DS    0H
         LA    R9,32(R9)          INCREMENT I
         B     LOOP2
ENDL2    DS    0H
*
         MVC   BEGIN(32),0(R10)   SWAP STATEMENTS FOR VALUES
         MVC   0(32,R10),0(R7)
         MVC   0(32,R7),BEGIN
*
         LA    R7,32(R7)          INCREMENT BEGIN
         B     LOOP1         
ENDL1    DS    0H         
* STANDARD EXIT LINKAGE *
         L    R13,4(0,13)         point r13 at caller save area
         LM   R14,R12,12(13)      restore registers
         BR   R14                 return to caller
         LTORG
***************************************************
*      STORAGE FOR SORT STARTS HERE              *
***************************************************
SSAVE    DS    18F
BEGIN    DS    CL32
***************************************************
*               SUBROUTINE MERGE                  *
***************************************************
MERGE    CSECT
* STANDARD ENTRY LINKAGE *
         STM   R14,R12,12(13)     save the registers
         LR    R12,R15            make 12 the base register
         USING MERGE,R12
         LA    R14,MSAVE          point r14 at MSAVE
         ST    R13,4(0,14)        save forward pointer in reg 13
         ST    R14,8(0,13)        save backward pointer in reg 14
         LR    R13,R14            point r13 at MSAVE
*
         LM    R2,R7,0(R1)        unload parameters
         L     R5,0(,R5)          R5 -> EOT1
         L     R6,0(,R6)          R6 -> EOT2
         L     R7,0(,R7)          R7 -> EOT3
* START OF CODE TO MERGE TABLES
MERGELP  CR    R2,R5              COMPARE TAB1 TO EOT1
         BNH   SOMELEFT           BRANCH IF NOT ALL OF TAB1 MOVED         
*
         CR    R3,R6              COMPARE TAB2 TO EOT2
         BH    POINTR7            BRANCH IF ALL ENTRIES MOVED
* FIGURE OUT WHICH TABLE THE NEXT ENTRY COMES FROM
*
SOMELEFT CR     R3,R6           COMPARE TAB2 TO EOT2
         BH    FROMT1             BRANCH IF TABLE2 EXHAUSTED
*
         CR    R2,R5              COMPARE TAB1 TO EOT1
         BH    FROMT2             BRANCH IF TABLE1 EXHAUSTED
*
         LR    R8,R2              LOAD R8 WITH NEXT TABLE1 ENTRY
         CLC   0(24,R2),0(R3)     COMPARE TAB1 ENTRY TO TAB2 ENTRY
         BH    FROMT2             BRANCH IF T1'S ENTRY IS HIGH
*
* MOVE ENTRY FROM TAB1 TO TAB3
*
FROMT1   LR    R8,R2              LOAD ENTRY FROM TAB1
         MVC   0(32,R4),0(R8)     STORE INTO TAB3
         LA    R2,32(R2)          INCREMENT TABLE POINTER
         B     INCRMNT            BRANCH TO INCREMENT TABLE3 POINTER
*
* MOVE ENTRY FROM TAB2 TO TAB3
*
FROMT2   LR    R8,R3              LOAD ENTRY FROM TAB2
         MVC   0(32,R4),0(R8)     STORE INTO TAB3
         LA    R3,32(R3)          INCREMENT TABLE POINTER
*
* INCREMENT POINTER FOR TABLE3
*
INCRMNT  LA    R4,32(R4)          INCREMENT POINTER TO NEXT ENTRY
*
         B     MERGELP            UC BRANCH TO TOP OF LOOP
*
* POINT R7 AT EOT FOR TABLE 3
*
POINTR7  ST    R4,0(R7)              R4 POINTS JUST PAST LAST ENTRY
*         S     R7,=F'32'         NOW R7 POINTS AT LAST ENTRY
* STANDARD EXIT LINKAGE *
         L     R13,4(0,13)        point r13 at caller save area
         LM    R14,R12,12(13)     restore registers
         BR    R14                return to caller
         LTORG
***************************************************
*      STORAGE FOR MERGE STARTS HERE              *
***************************************************
MSAVE    DS    18F
         END ASSIGN7
//FT05F001  DD  DSN=KC02314.SUMMER11.CSCI360.HW7DATA,DISP=SHR