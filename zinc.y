%{
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <stdlib.h>

#define yycode printf
#define YYSTYPE int
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
program: PRGM declarations BGN statementSequence END;
declarations: VAR ID AS type SC declarations
            | /* nothing */
            ;
type: INT;
statementSequence: statement SC statementSequence
                 | /* nothing */
                 ;
statement: assignment
         | ifStatement
         | whileStatement
         | writeInt
         | /* nothing */
         ;
assignment: ID ASGN expression
          | ID ASGN READ
          ;
ifStatement: IF expression THEN statementSequence elseClause ENDIF;
elseClause: ELSE statementSequence
          | /* nothing */
          ;
whileStatement: WHL expression DO statementSequence ENDWHL;
writeInt: WRITE expression;
expression: simpleExpression
          | simpleExpression COMP expression
          ;
simpleExpression: term ADD simpleExpression
                | term OR simpleExpression
                | term
                ;
term: factor MULT term
    | factor AND term
    | factor
    ;
factor: primary POWER factor
      | primary
      ;
primary: ID
       | NUM
       | LP expression RP
       | ADD primary 
       | NOT primary
       ;
%%
#include "lex.yy.c"

int yyerror(char *s)
{
    printf("[ERROR]%s\n", s);
}

main()
{
    yyparse();
}