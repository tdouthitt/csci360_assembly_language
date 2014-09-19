//KC03DDBA JOB ,'Taylor Douthitt',MSGCLASS=H
//STEP1  EXEC PGM=ASSIST
//STEPLIB  DD DSN=KC02293.ASSIST.LOADLIB,DISP=SHR
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
********************************************
*  EXAMPLE PROGRAM                         *
********************************************
MAIN   CSECT
       USING MAIN,15
       SR    3,3     ZERO FOR TOTAL
       SR    4,4     ZERO FOR COUNTER
       XDUMP
       BR    14
       END   MAIN
/*
//
