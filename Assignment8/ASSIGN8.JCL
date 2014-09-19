//KC03DDBA JOB ,'Taylor Douthitt',MSGCLASS=H
//STEP1 EXEC PGM=ASSIST
//STEPLIB DD DSN=KC02293.ASSIST.LOADLIB,DISP=SHR
//SYSPRINT DD SYSOUT=*
//SYSIN DD *
************************************************************
*  Program:     Assign8.JCL                                *
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
* DSECT FOR TABLE ENTRY
TABSECT  DSECT
$KEY     DS    8C
$KEYL    DS    F
$MESS    DS    60C
*
ASSIGN8  CSECT
*
* STANDARD ENTRY LINKAGE *
*
         STM   14,12,12(13)       save the registers
         LR    12,15              make 12 the base register
         USING ASSIGN8,12
         LA    14,MAINSAVE        point r14 at MAINSAVE
         ST    13,4(0,14)         save forward pointer in reg 13
         ST    14,8(0,13)         save backward pointer in reg 14
         LR    13,14              point r13 at MAINSAVE
*
*
*   CALL TO SUBROUTINE BUILD
* 
         LA    1,BLIST            reg 1 = address of BLIST
         L     15,=V(BUILD)       point r15 at build
         BALR  14,15              branch to build
         XDUMP TABLE,216
*
*
*   CALL TO SUBROUTINE PRINT1
*
          LA    1,PLIST1           reg 1 = address of PLIST1
          L     15,=V(PRINT1)      point r15 at PRINT1
          BALR  14,15              branch to PRINT1
*
*   CALL TO SUBROUTINE CRYPT
*
          LA    1,CLIST            reg 1 = address of CLIST
          L     15,=V(CRYPT)       point r15 at crypt
          BALR  14,15              branch to crypt
*
          XDUMP TABLE,216          DUMP FIRST 3 TABLE ENTRIES
*
*   CALL TO SUBROUTINE PRINT2
*
*         LA    1,PLIST2           reg 1 = address of PLIST2
*         L     15,=V(PRINT2)      point r15 at PRINT2
*         BALR  14,15              branch to PRINT2
* END OF PROGRAM
* STANDARD EXIT LINKAGE *
         L     13,4(0,13)         point r13 at caller save area
         LM    14,12,12(13)       restore registers
         BR    14
         LTORG
***************************************************
*       STORAGE FOR MAIN STARTS HERE              *
***************************************************
* SAVE AREA FOR MAIN
MAINSAVE DS    18F
* PAGE COUNTER
PCOUNT   DS    F
* LINE COUNTER
LCOUNT   DS    F
*
*        PARAMETER LISTS
*     
BLIST    DC    A(TABLE)
         DC    A(EOT)
         DC    A(SCANTAB)
*       
CLIST    DC    A(TABLE)
         DC    A(EOT)
         DC    A(LTAB)
*
PLIST1   DC    A(TABLE)
         DC    A(EOT)
         DC    A(LCOUNT)
         DC    A(PCOUNT)
*
PLIST2   DC    A(TABLE)
         DC    A(EOT)
         DC    A(PCOUNT)
* TRT TABLE
SCANTAB  DC    256X'00'
         ORG   SCANTAB+C'.'
         DC    X'4B'
         ORG   SCANTAB+C' '
         DC    X'40'
         ORG
* MESSAGE LENGTH TABLE
LTAB     DC    256X'00'
         ORG   LTAB+C'.'
         DC    X'4B'
         ORG
* TABLE
TABLE    DS    60CL72
ENDTABLE DC    C'$'
EOT      DC    A(ENDTABLE)
***************************************************
*               SUBROUTINE BUILD                  *
***************************************************
BUILD    CSECT
* STANDARD ENTRY LINKAGE *
         STM   14,12,12(13)       save the registers
         LR    12,15              make 12 the base register
         USING BUILD,12
         LA    14,BSAVE           point r14 at BSAVE
         ST    13,4(0,14)         save forward pointer in reg 13
         ST    14,8(0,13)         save backward pointer in reg 14
         LR    13,14              point r13 at BSAVE
*
         LM    2,4,0(1)           unload parameters
         USING TABSECT,2
*
         XREAD INPUT,80           READ FIRST RECORD IN FILE
*
*              LOOP TO PROCESS RECORDS *
OLOOP    BC    B'0100',ENDO       if eof then skip to end Loop                     
*        
         TRT   0(8,2),0(4)        SCAN R2 LENGTH8 FOR . OR ' '
*
         S     1,=A(INPUT)        FIND LENGTH SINCE NOT FULL
*   
         ST    1,$KEYL            STORE LENGTH
*
         MVC   $KEY(8),INPUT  MOVE KEY OF SPECIFIED LENGTH
*
         MVC   $MESS(60),INPUT+9  MOVE MESSAGE TO TABLE
*
         LA    2,72(2)            ADVANCE TABLE
*
         XREAD INPUT,80           READ NEXT RECORD IN INPUT FILE
*            
         B     OLOOP              UC BRANCH TO TOP OF LOOP
* 
ENDO DS 0H              END OF LOOP              
*
         ST    2,0(3)             store last table entry in EOT
*  
         DROP  2                  STOP USING DSECT
* STANDARD EXIT LINKAGE *
         L     13,4(0,13)         point r13 at caller save area
         LM    14,12,12(13)       restore registers
         BR    14                 return to caller
         LTORG
***************************************************
*      STORAGE FOR BUILD STARTS HERE              *
***************************************************
BSAVE    DS    18F
* INPUT LINE
INPUT    DS    CL80
***************************************************
*               SUBROUTINE PRINT1                 *
***************************************************
PRINT1   CSECT
* STANDARD ENTRY LINKAGE *
         STM   14,12,12(13)       save the registers
         LR    12,15              make 12 the base register
         USING PRINT1,12
         LA    14,PSAVE1          point r14 at PSAVE1
         ST    13,4(0,14)         save forward pointer in reg 13
         ST    14,8(0,13)         save backward pointer in reg 14
         LR    13,14              point r13 at PSAVE1
*
         LM    2,4,0(1)           unload parameters
         USING TABSECT,2          USING STATEMENT FOR DSECT
         L     5,=F'0'            INITIALIZE PAGE COUNTER
*
PGLP     ST    0,PGNUM            STORE PCOUNT BACK IN VARIABLE
         XPRNT PHEAD,80
         XPRNT CHEAD,26 
         L     4,=F'1'            RESET LINE COUNT
*
*            LOOP TO PRINT OUT TABLE VALUES   *
PLOOP    C     4,=F'20'           START OF PAGE HEADER LOOP
         BE    PGLP               IF 20 LINES BRANCH TO PG HEADER
*
         C     2,0(3)             COMPARE TABLE AND ENDTABLE
         BNL   ENDLP              IF EQUAL EXIT LOOP
*       
         MVC   KEY(8),$KEY       MOVE FIRST NAME TO FW
*
         MVC   MESS(60),$MESS      MOVE ID NUMBER TO FW
*
         XPRNT PLINE,79           PRINT INFO
*
         LA    2,72(2)            ADVANCE TABLE         
*    
         A     4,=F'1'            INCREMENT PAGE COUNTER
         B     PLOOP              UC BRANCH TO PLOOP     
ENDLP    DS    0H                 BOTTOM OF LOOP
*                 
         DROP  2                  END OF USING DSECT         
* STANDARD EXIT LINKAGE *
         L     13,4(0,13)         point r13 at caller save area
         LM    14,12,12(13)       restore registers
         BR    14                 return to caller
         LTORG
***************************************************
*      STORAGE FOR PRINT1 STARTS HERE             *
***************************************************
PSAVE1   DS    18F
* PACK DECIMAL TO KEEP TRACK OF LINES PRINTED(MAX 40)
LNNUM    DS    PL2
*   PAGE HEADER
PHEAD    DC    C'1'
         DC    CL25' '
         DC    C'ORIGINAL MESSAGES AND KEYS'
         DC    CL20' '
         DC    C'PAGE'
         DC    CL3' '
PGNUM    DS    F         
*   COLUMN HEADER
CHEAD    DC    C'-'
         DC    CL5' '
         DC    C'KEY'
         DC    CL10' '
         DC    C'MESSAGE' 
*   DATA LISTS
PLINE    DC    C'0'
         DC    CL5' '
KEY      DS    CL8
         DC    CL5' '
MESS     DS    CL60 
*
***************************************************
*               SUBROUTINE CRYPT                  *
***************************************************
CRYPT    CSECT
* STANDARD ENTRY LINKAGE *
         STM   14,12,12(13)       save the registers
         LR    12,15              make 12 the base register
         USING CRYPT,12
         LA    14,CSAVE           point r14 at CSAVE
         ST    13,4(0,14)         save forward pointer in reg 13
         ST    14,8(0,13)         save backward pointer in reg 14
         LR    13,14              point r13 at CSAVE
*
         LM    2,4,0(1)          
         LA    2,0(2)         
         SR    10,10         
         USING TABSECT,2
         SR    9,9         
*
LOOP     C     2,0(3)       
         BNL   ENDLOOP       
*
         L    10,=F'59'       
         LR   6,2           
         LA   6,12(6)      
         L    5,$KEYL        
ENCRYPT  C    10,=F'0'      
         BE   ENDC          
         C    10,$KEYL       
         BNL  CL            
         EX   10,NCRYPT       
         B    ENDC           
CL       DS    0H          
         EX   5,NCRYPT         
         LA   6,0(5,6)    
         SR   10,5           
         B    ENCRYPT              
ENDC     DS    0H 
*
         LA   2,72(,2)     
         B    LOOP           
*
ENDLOOP  DS    0H
*
* STANDARD EXIT LINKAGE *
         L     13,4(0,13)         point r13 at caller save area
         LM    14,12,12(13)       restore registers
         BR    14                 return to caller
         LTORG
***************************************************
*      STORAGE FOR CRYPT STARTS HERE              *
***************************************************
CSAVE    DS    18F
NCRYPT   XC    0(0,6),$KEY        XOR 1ST KEYL BYTES OF MESSAGE
         DROP  2                  END OF USING DSECT 
*        
         END ASSIGN8
//FT05F001  DD  DSN=KC02314.SUMMER11.CSCI360.HW8DATA,DISP=SHR
