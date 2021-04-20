%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "y.tab.h"

    int ln = 1; 
    int pos = 0;
%}

/* BASIC */
ws          [ \t]
digit       [0-9]
num         [1-9][0-9]*|0
cap         [A-Z]
low         [a-z]
letter      {cap}|{low}

/* WORDS */
id          {cap}({cap}|{digit})*
comment     "%"(.)*"\n"

/* SYMBOLS & OPERATORS */
LP          "("
RP          ")"
ASGN        ":="
SC          ";"
AS          ":"
POWER       "**"
MULT        "*"|"div"|"mod"
ADD         "+"|"-"
COMP        "<>"|"<="|">="|"<"|">"|"="

/* KEYWORDS */
IF          "if"
THEN        "then"
ELSE        "else"
BEGIN       "begin"
ENDIF       "endif"
WHILE       "while"
ENDWHILE    "endwhile"
DO          "do"
PROGRAM     "program"
END         "end"
VAR         "var"
INT         "integer"
AND         "and"
OR          "or"
NOT         "not"

/* PROCEDURES */
WRITEINT    "writeInt"
READINT     "readInt"

%%
{ws}+       {   
                /* printf("whitespace len: %i\n", yyleng); */ 
                pos += yyleng;
            }

\n+         { 
                printf("\n");
                ln += yyleng;
                pos = 0;
            }  

{comment}   {   
                ln++;
                pos = 0;
            }

{num}       {   
                pos += yyleng;
                return(NUM);
            }

{id}        {   
                pos += yyleng;
                return(ID);
            }

{LP}        {   
                pos += yyleng;
                return(LP);
            }

{RP}        {   
                pos += yyleng;
                return(RP);
            }

{ASGN}      {
                pos += yyleng;
                return(ASGN);
            }

{SC}        {
                pos += yyleng;
                return(SC);
            }

{AS}        {
                pos += yyleng;
                return(AS);
            }

{POWER}     {
                pos += yyleng;
                return(POWER);
            }

{MULT}      {
                pos += yyleng;
                return(MULT);
            }

{ADD}       {
                pos += yyleng;
                return(ADD);
            }

{COMP}      {              
                pos += yyleng;
                return(COMP);
            }

{IF}        {
                pos += yyleng;
                return(IF);
            }

{THEN}      {
                pos += yyleng;
                return(THEN);
            }

{ELSE}      {
                pos += yyleng;
                return(ELSE);
            }

{BEGIN}     {
                pos += yyleng;
                return(BGN);
            }

{ENDIF}     {
                pos += yyleng;
                return(ENDIF);
            }

{WHILE}     {
                pos += yyleng;
                return(WHL);
            }

{ENDWHILE}  {
                pos += yyleng;
                return(ENDWHL);
            }

{DO}        {
                pos += yyleng;
                return(DO);
            }

{PROGRAM}   {
                pos += yyleng;
                return(PRGM);
            }

{END}       {
                pos += yyleng;
                return(END);
            }

{VAR}       {
                pos += yyleng;
                return(VAR);
            }
        
{INT}       {
                pos += yyleng;
                return(INT);
            }

{AND}       {
                pos += yyleng;
                return(AND);
            }

{OR}        {
                pos += yyleng;
                return(OR);
            }
        
{NOT}       {
                pos += yyleng;
                return(NOT);
            }
        
{WRITEINT}  {
                pos += yyleng;
                return(WRITE);
            }

{READINT}   {
                pos += yyleng;
                return(READ);
            }

.           {
                pos += yyleng;
                return(INVALID);
            }
%%