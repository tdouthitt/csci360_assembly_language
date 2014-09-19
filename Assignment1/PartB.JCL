//KC03DDBB JOB ,'Taylor Douthitt',MSGCLASS=H
//STEP1  EXEC PGM=ASSIST
//STEPLIB  DD DSN=KC02293.ASSIST.LOADLIB,DISP=SHR
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
********************************************
*  NAME: MAIN                              *
*  FUNCTION: Load fullwords into registers *
*            and subtract one register from*
*            another. Stores the result in *
*            a fullword ANS.               *
*            Then display the              *
*            contents of the registers at  *
*            ANS and adjacent values       *
*  INPUT: NONE                             *
*  OUTPUT: XDUMP ANS,4 display appropriate * 
*                      registers           *
*  ENTRY CONDS: NONE                       *
*  REGISTER USAGE: R1 - holds value of N1  *
*                  R2 - holds value of N2  *
*  EXIT CONDS:  NONE                       *
*  PSEUDOCODE:                             *
*  NOTES:                                  *
********************************************
MAIN    CSECT
        USING MAIN,15
        L 1,N1 Load N1 into register 1
        L 2,N2 Load N2 into register 2
        SR 2,1 Subtract N1 from N2
        ST 2,ANS Store answer in ANS
        XDUMP ANS,4
        BR 14
N1      DC      F'35'
N2      DC      F'27'
ANS     DS      F
        END   MAIN
/*
//
