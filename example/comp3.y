%{
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <stdlib.h>

#define yycode printf

#define YYSTYPE char*

/* function prototypes */
char * gen_label();
int yyerror(char *);
int yylex(void);


%}

%token NUM
%token ID
%token PLUS
%token STAR
%token LP
%token RP
%token ASGN
%token COMMA
%token SEMICOLON
%token BEGINSYM
%token ENDSYM
%token IFSYM
%token THENSYM
%token ENDIF
%token PROGSYM
%token INTSYM

%left  PLUS
%left  STAR

%%

prog:     PROGSYM  ID {yycode("section .data\n");} decls
          BEGINSYM {yycode("section .code\n");} seq
          ENDSYM   { printf("End of Compilation\n"); return 0; }
    ;
decls:    decl SEMICOLON decls
    | decl
    | /* nothing */
    ;
decl:    INTSYM varlist
    ;
varlist:    ID COMMA varlist  { yycode("%s\t word\n", $1); }
    | ID        { yycode("%s\t word\n", $1); }
    ;
seq:      seq SEMICOLON stmt
    | stmt
    ;
stmt:     /* nothing */
    | astmt
    | ifstmt
    ;
astmt:    ID { yycode("RVALUE \t%s\n", $1);} ASGN expr { yycode("STO\n");}
    ;
ifstmt:   IFSYM expr {$$ = strdup(gen_label()); yycode("GOFALSE %4s\n", $$); }
                    THENSYM seq ENDIF {yycode("LABEL \t%4s\n", $3); }
    ;
expr:   expr PLUS expr {yycode("ADD\n");}
    |   expr STAR expr {yycode("MUL\n");}
    |   LP expr RP
    |   NUM { yycode("PUSH \t%s\n", $1);}
    |   ID  { yycode("LVALUE\t%s\n", $1);}
    ;
%%
#include "lex.yy.c"    /* simplifies compilation */

char *gen_label()
{
    static int i = 1000;
    char *temp = malloc(5);
    sprintf(temp,"%04d",i++);
    return temp;
}

int yyerror(char *s)
{
    printf("%s\n", s);
}


main()
{
    yyparse();
}
