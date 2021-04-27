%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <stdbool.h>
    #include "y.tab.h"

    // used to keep track of current pos
    int ln = 1; 
    int pos = 0;

    // print stuff to console for debugging
    bool printTokens = true;
    bool printTree = true;

    // bools used in semantic analysis
    bool isValidated = true;
    bool makingTable = true;

    // current token and respective string
    int currentToken = 0;
    char* str = NULL;

    // SYMBOL TABLE
    // max symbols = 128
    // max char length = 128
    char symTab[128][128];
    int symIndex = 0;
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
{ws}+ {   
    /* printf("whitespace len: %i\n", yyleng); */
    pos += yyleng;
}

\n+ {
    printToken("NL");
    ln += yyleng;
    pos = 0;
}  

{comment} {   
    printToken("COMMENT");
    ln++;
    pos = 0;
}

{num} {   
    printToken("NUM");
    pos += yyleng;
    return(NUM);
}

{id} {   
    printToken("ID");
    pos += yyleng;
    return(ID);
}

{LP} { 
    printToken("LP");
    pos += yyleng;
    return(LP);
}

{RP} {   
    printToken("RP");
    pos += yyleng;
    return(RP);
}

{ASGN} {
    printToken("ASGN");
    pos += yyleng;
    return(ASGN);
}

{SC} {
    printToken("SC");
    pos += yyleng;
    return(SC);
}

{AS} {
    printToken("AS");
    pos += yyleng;
    return(AS);
}

{POWER} {
    printToken("POWER");
    pos += yyleng;
    return(POWER);
}

{MULT} {
    printToken("MULT");
    pos += yyleng;
    return(MULT);
}

{ADD} {
    printToken("ADD");
    pos += yyleng;
    return(ADD);
}

{COMP} {
    printToken("COMP");          
    pos += yyleng;
    return(COMP);
}

{IF} {
    printToken("IF");
    pos += yyleng;
    return(IF);
}

{THEN} {
    printToken("THEN");
    pos += yyleng;
    return(THEN);
}

{ELSE} {
    printToken("ELSE");
    pos += yyleng;
    return(ELSE);
}

{BEGIN} {
    printToken("BEGIN");
    pos += yyleng;
    return(BGN);
}

{ENDIF} {
    printToken("ENDIF");
    pos += yyleng;
    return(ENDIF);
}

{WHILE} {
    printToken("WHILE");
    pos += yyleng;
    return(WHL);
}

{ENDWHILE} {
    printToken("ENDWHILE");
    pos += yyleng;
    return(ENDWHL);
}

{DO} {
    printToken("DO");
    pos += yyleng;
    return(DO);
}

{PROGRAM} {
    printToken("PROGRAM");
    pos += yyleng;
    return(PRGM);
}

{END} {
    printToken("END");
    pos += yyleng;
    return(END);
}

{VAR} {
    printToken("VAR");
    pos += yyleng;
    return(VAR);
}
        
{INT} {
    printToken("INT");
    pos += yyleng;
    return(INT);
}

{AND} {
    printToken("AND");
    pos += yyleng;
    return(AND);
}

{OR} {
    printToken("OR");
    pos += yyleng;
    return(OR);
}
        
{NOT} {
    printToken("NOT");
    pos += yyleng;
    return(NOT);
}
        
{WRITEINT} {
    printToken("WRITEINT");
    pos += yyleng;
    return(WRITE);
}

{READINT} {
    printToken("READINT");
    pos += yyleng;
    return(READ);
}

. {
    printToken("INVALID");
    pos += yyleng;
    return(INVALID);
}
%%

void printToken(char *t)
{
    if (printTokens) printf("[TOKEN] %s\n", t);
}