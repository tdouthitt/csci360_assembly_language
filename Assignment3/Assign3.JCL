//KC03DDBT JOB ,'Taylor Douthitt',MSGCLASS=H
//STEP1 EXEC PGM=ASSIST
//STEPLIB DD DSN=KC02293.ASSIST.LOADLIB,DISP=SHR
//SYSPRINT DD SYSOUT=*
//SYSIN DD *
   TITLE 'CSCI 360 ASSIGNMENT 3'
************************************************************
*  Program:     Assign3.JCL                                *
*  Programmer:  Taylor Douthitt                            *
*  NAME: MAIN                                              *
*  FUNCTION:                                               *
*  INPUT: file - given sample input file                   *
*  OUTPUT: payroll report                                  *
*  ENTRY CONDS: NONE                                       *
*  REGISTER USAGE:   R0 - Command Use                      *
*                    R1 - Command Use                      *
*                    R2 - Math use                         *
*                    R3 - Math use                         *
*                    R4 - ID number                        *
*                    R5 - Hourly Wage                      *
*                    R6 - Number of hours                  *
*                    R7 - Bonus                            *
*                    R8 - Deduction                        *
*                    R9 - Gross Pay                        *
*                    R10 - Net Pay                         *
*                    R11 - Average Net Pay                 *
*                    R12 - employee count                  *
*                    R13 - overtime count                  *
*                    14 - exit address                     *
*                    15 - base register                    *
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
ASSIGN3 CSECT
    USING ASSIGN3,15
    XPRNT HEADR,51 print page header
    SR R11,R11 Initialize variables
    SR R10,R10
    SR R9,R9
    SR R12,R12 Reset count set
    SR R13,R13
    XPRNT HEAD1,86
    XPRNT HEAD2,86
    XPRNT HEAD3,86
    SPACE 2
*
    XREAD FILE,80 Read first input record
    SPACE 2
*
TOP BC B'0100',END Top of loop and condition
    SPACE 2
*
    XDECI R4,FILE Process record with XDECI
    XDECI R5,0(1)
    XDECI R6,0(1)
    XDECI R7,0(1)
    XDECI R8,0(1)
*
    SPACE 2
    LR R3,R5 Load wage into register 3
    MR R2,R6  calculate gross pay(wage * hours)
    LR R9,R3  copy gross pay into register 9
    SR R3,R3  clear register 3
    SR R2,R2  clear register 2
    SR R1,R1  clear register 1
*
    SPACE 2
    C R6,=F'40' compare hours worked to literal 40
    BC B'1100',SKIP if less than 40 hours worked
    BC B'0010',OVRT if more than 40 hours worked
*
*             Determine overtime pay
    SPACE 2 
OVRT L R3,=F'2' load literal 2 into register 3
    MR R2,R5 calculate OT wage multiply 2 * wage
*     value gets stored in register 3
    LR R1,R6 load hours into register 2
    S R1,=F'40' calculate OT hours(hours-40) 
*
    MR R0,R3 multiply OT hours by wage
*
    A R13,=F'1' increment OT count
    AR R9,R1 add OT pay to gross pay
    SPACE 2
*      Determine net pay preliminary
SKIP LR R10,R9
*
    SPACE 2
    AR R10,R7 Add bonus to net pay
    SR R10,R8 Subtract deduction from net pay
*
    SPACE 2
    AR R11,R10 add net pay to register 11   
*     Convert register values into variables in print form
    SPACE 2
    XDECO R4,IDNUM     
    XDECO R5,WAGE
    XDECO R6,HOURS
    XDECO R7,BONUS
    XDECO R8,DDUCT
    XDECO R9,GPAY
    XDECO R10,NPAY
    SPACE 2
*   Print variable values
    XPRNT PRNTL,90
    SPACE 2
    A R12,=F'1'
    SPACE 2
* Read next record
    XREAD FILE,80
    SPACE 2    
    BC B'1111',TOP Return to top of loop
    SPACE 2
END DS 0H End of loop
* Calculate final results and print
    SPACE 2
    LR R3,R11 copy total pay into register 2
    DR R2,R12 divide total net pay by # of employees
    SR R2,R2
*   result stored in register 3
    LR R11,R3 copy register 3 into register 11
*  Convert final results to fullwords and print form
    SPACE 2
    XDECO R11,AVPAY
    XDECO R12,ENUM
    XDECO R13,OTNUM
*  Print end of payroll report
    SPACE 2
    XPRNT PRNT1,40
    XPRNT PRNT2,43
    XPRNT PRNT3,51
*
    BR 14
OTWAG DS CL12
FILE DS CL80
OTHRS DS CL12
OTPAY DS CL12
*
HEADR DC C'1'
      DC C'                    PAYROLL REPORT -- WIDGETS-R-US'
*
HEAD1 DC C'0'
* 
      SPACE 2
      DC C'     EMPLOYEE'
      SPACE 2
      DC C'        HOURLY'
      SPACE 2
      DC C'       HOURS'
      SPACE 2
      DC C'                            GROSS'
      SPACE 2
      DC C'         NET'       
*
HEAD2 DC C' '
      SPACE 2
      DC C'      NUMBER'
      SPACE 2
      DC C'         WAGE'
      SPACE 2
      DC C'         WORKED'
      SPACE 2
      DC C'    BONUS'
      SPACE 2
      DC C'   DEDUCTION'
      SPACE 2
      DC C'       PAY'
      SPACE 2
      DC C'          PAY'
*
HEAD3 DC C'0'
      DC C'--------------------------------------------------'
      DC C'-----------------------------'
*
PRNTL DC C'0' 
* 
IDNUM DS CL12 
*
WAGE DS CL12
*
HOURS DS CL12
*
BONUS DS CL12
*
DDUCT DS CL12
*
GPAY DS CL12
*
NPAY DS CL12 
*
PRNT1 DC C'-'
      DC C'TOTAL NUMBER OF EMPLOYEES: '
ENUM DS CL12 
*
PRNT2 DC C'0'
      DC C'AVERAGE NET PAY PER EMPLOYEE: '
AVPAY DS CL12
*
PRNT3 DC C'0'
      DC C'NUMBER OF EMPLOYEES WORKING OVERTIME: '
OTNUM DS CL12
        END ASSIGN3
/*
//FT05F001 DD DSN=KC02314.SUMMER11.CSCI360.HW3DATA,DISP=SHR
//