%{
#include <stdio.h>
#include "y.tab.h"
%}
delim   [ \n\t]
ws  {delim}+
number  [0-9]+
ident   [a-z]+

%%
{ws}                { ; }   /* skip blanks and tabs */
{number}            { yylval = strdup(yytext); return NUM; }
{ident}             { yylval = strdup(yytext); return ID; }
"+"                 { return PLUS; }
"*"                 { return STAR; }
"("                 { return LP; }
")"                 { return RP; }
":="                { return ASGN; }
";"                 { return SEMICOLON; }
","                 { return COMMA; }
"IF"                { return IFSYM; }
"{"                 { return BEGINSYM; }
"}"                 { return ENDSYM; }
"THEN"              { return THENSYM; }
"ENDIF"             { return ENDIF; }
"PROGRAM"           { return PROGSYM; }
"INTEGER"           { return INTSYM; }
.                   { printf("\n lexical error\n"); }
%%
