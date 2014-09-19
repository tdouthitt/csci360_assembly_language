//KC03DDBA JOB ,'Taylor Douthitt',MSGCLASS=H
//STEP1  EXEC PGM=ASSIST
//STEPLIB  DD DSN=KC02293.ASSIST.LOADLIB,DISP=SHR
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
********************************************
*  NAME: MAIN                              *
*  FUNCTION: Load fullwords into registers *
*            and subtract one register from*
*            another. Then display the     *
*            contents of the registers.    *
*  INPUT: NONE                             *
*  OUTPUT: XDUMP - display all registers   *
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
        XDUMP
        BR 14
N1      DC      F'35'
N2      DC      F'27'
        END   MAIN
/*
//
