%{
    #include <stdio.h>
    #include <ctype.h>
    #include <stdlib.h>
    #include <stdbool.h>

    #define yycode printf
    #define YYSTYPE int

    bool printStartEnd = false;
%}

// TOKENS
%token NUM
%token ID
%token LP
%token RP
%token ASGN
%token SC
%token AS
%token POWER
%token MULT
%token ADD
%token COMP
%token IF
%token THEN
%token ELSE
%token BGN
%token ENDIF
%token WHL
%token ENDWHL
%token DO
%token PRGM
%token END
%token VAR
%token INT
%token AND
%token OR
%token NOT
%token READ
%token WRITE

%token INVALID

%left MULT
%left ADD
%left COMP

%%
program:
    { printParse("program", true); }
    PRGM declarations BGN statementSequence END
    { printParse("program", false); }
    ;

declarations:
    { printParse("declarations", true); }
    VAR ID AS type SC declarations
    { printParse("declarations", false); }
    | /* nothing */
    ;

type:
    INT
    ;

statementSequence:
    { printParse("statementSequence", true); }
    statement SC statementSequence
    { printParse("statementSequence", true); }
    | /* nothing */
    ;

statement:
    assignment
    | ifStatement
    | whileStatement
    | writeInt
    | /* nothing */
    ;

assignment: 
    ID ASGN expression
    | ID ASGN READ
    ;

ifStatement: 
    IF expression THEN statementSequence elseClause ENDIF
    ;

elseClause: 
    ELSE statementSequence
    | /* nothing */
    ;

whileStatement: 
    WHL expression DO statementSequence ENDWHL
    ;

writeInt: 
    WRITE expression
    ;

expression: 
    simpleExpression
    | simpleExpression COMP expression
    ;

simpleExpression: 
    term ADD simpleExpression
    | term OR simpleExpression
    | term
    ;

term: 
    factor MULT term
    | factor AND term
    | factor
    ;

factor: 
    primary POWER factor
    | primary
    ;

primary: 
    ID
    | NUM
    | LP expression RP
    | ADD primary 
    | NOT primary
    ;
%%
#include "lex.yy.c"

void printParse(char *str, bool begin)
{
    if (printStartEnd)
    {
        if (begin) printf("[YACC] starting %s...\n", str);
        else printf("[YACC] ending %s...\n", str);
    }
}

int yyerror(char *s)
{
    printf("[ERROR] %s\n", s);
}

main()
{
    yyparse();
}