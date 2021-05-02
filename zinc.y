%{
    #include <stdio.h>
    #include <ctype.h>
    #include <stdlib.h>
    #include <stdbool.h>

    #define yycode printf
    #define YYSTYPE int

    bool printStartEnd = false;
    int numLabel;

    // file to write output to
    FILE *outfile;
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

/* ########################### */
/*                             */
/*      UTIL FUNCTIONS         */
/*                             */
/* ########################### */

void printError(char* type, char* msg)
{
    printf("\n\n[%s] %s at line %d pos %d\n", type, msg, ln, pos);
    exit(-1);
}

void printParse(char *str, bool begin)
{
    if (printStartEnd)
    {
        if (begin) printf("[YACC] starting %s...\n", str);
        else printf("[YACC] ending %s...\n", str);
    }
}

int yyerror(char *msg)
{
    printError("SYNTAX", msg);
}

char* getTokenStr(int n)
{
    switch(n)
    {
        default:
        case NUM:
            return "NUM";
        case ID:
            return "ID";
        case LP:
            return "LP";
        case RP:
            return "RP";
        case ASGN:
            return "ASGN";
        case SC:
            return "SC";
        case AS:
            return "AS";
        case POWER:
            return "POWER";
        case MULT:
            return "MULT";
        case ADD:
            return "ADD";
        case COMP:
            return "COMP";
        case IF:
            return "IF";
        case THEN:
            return "THEN";
        case ELSE:
            return "ELSE";
        case BGN:
            return "BEGIN";
        case ENDIF:
            return "ENDIF";
        case WHL:
            return "WHILE";
        case ENDWHL:
            return "ENDWHILE";
        case DO:
            return "DO";
        case PRGM:
            return "PROGRAM";
        case END:
            return "END";
        case VAR:
            return "VAR";
        case INT:
            return "INT";
        case AND:
            return "AND";
        case OR:
            return "OR";
        case NOT:
            return "NOT";
        case READ:
            return "READINT";
        case WRITE:
            return "WRITEINT";
        case INVALID:
            return "INVALID";
    }
}

bool checkSymbolTable(char * sym)
{
    if (makingTable)
        return true;

    // printf("\nlooking for: %s\n", sym);
    for (int i = 0; i < symIndex; i++)
    {
        // printf ("symbol %d: %s\n", i, symTab[i]);

        if (strcmp(symTab[i], sym) == 0)
            return true;
    }
    return false;
}

void printSyntaxTree(char* func, bool start)
{
    if (!printTree) return;

    if (start)
    {
        printf("*starting %s\n", func);
    }
    else
    {
        printf("*ending %s\n", func);
    }
}

void validateToken(int token, char* _str)
{
    if (currentToken != token)
    {
        char msg[128] = "expected \'";
        strcat(msg, getTokenStr(token));
        strcat(msg, "\' token but found \'");
        strcat(msg, str);
        strcat(msg, "\'");

        printError("SYNTAX ERROR", msg);
    }
    
    isValidated = true;
    // used for PA3, no longer needed for PA4
    //printf("<%s, %s> ", getTokenStr(currentToken), _str);
}

void getNextToken()
{
    if (!isValidated)
        return;

    currentToken = yylex();
    isValidated = false;
    str = yytext;

    // printf("new curr token: ");
    // printf("%s\n", getTokenStr(currentToken));
}

char* addQuotes(char* _str)
{
    char* res = strdup("\0");
    snprintf(res, sizeof(res), "\"%s\"", _str);
    return res;
}

void getID()
{
    validateToken(ID, addQuotes(str));
    if (!checkSymbolTable(str))
    {
        char buff[128];
        snprintf(buff, sizeof(buff), "invalid identifier \'%s\'", str);
        printError("SYMBOL", buff);
    }
}

void getNum()
{
    validateToken(NUM, str);
}

void addToSymbolTable(char* symbol)
{
    // check to see if symbol is in table already
    for (int i = 0; i < symIndex; i++)
    {
        if (symTab[i] == symbol)
            return;
    }

    strcpy(symTab[symIndex], symbol);
    symIndex++;
}

/* ########################### */
/*                             */
/*    OUTPUT CODE FUNCTIONS    */
/*                             */
/* ########################### */

void emitToOutput(char* inst, char* n, bool tab)
{
    if (tab)
    {
        char buff[128];
        snprintf(buff, sizeof(buff), "\t%s\t%s\n", inst, n);
        fprintf(outfile, buff);
    }
    else
    {
        char buff[128];
        snprintf(buff, sizeof(buff), "%s\t%s\n", inst, n);
        fprintf(outfile, buff);
    }
}

char* generateLabel()
{
    char* res = strdup("\0");
    snprintf(res, sizeof(res), "label_%d", numLabel);
    numLabel++;
    return res;
}

/* ########################### */
/*                             */
/*      GRAMMAR FUNCTIONS      */
/*                             */
/* ########################### */

// predeclared functions
void statementSequence(void);
void ifStatement(void);
void expression(void);

void primary()
{
    printSyntaxTree("primary()", true);

    getNextToken();
    // can be ID, NUM, LP EXPR RP, "-" PRIMARY, or NOT PRIMARY
    if (currentToken == ID)
    {
        getID();

        emitToOutput("RVALUE", str, true);
    }
    else if (currentToken == NUM)
    {
        getNum();

        emitToOutput("PUSH", str, true);
    }
    else if (currentToken == LP)
    {
        validateToken(LP, "_");
        
        // expression
        expression();

        getNextToken();
        validateToken(RP, "_");
    }
    else if (currentToken == ADD)
    {
        // determine if '-' is found
        if (strcmp(str, "-") == 0)
        {
            validateToken(ADD, addQuotes(str));
        }
        else
        {
            // send error?
            char buff[128];
            snprintf(buff, sizeof(buff), "invalid token \'%s\'", str);
            printError("SYNTAX", buff);
        }

        // primary
        primary();

        emitToOutput("NEG", "", true);
    }
    else if (currentToken == NOT)
    {
        validateToken(NOT, "_");

        emitToOutput("NOT", "", true);

        // primary
        primary();
    }
    else
    {
        // send error?
        char buff[128];
        snprintf(buff, sizeof(buff), "invalid token \'%s\'", str);
        printError("SYNTAX", buff);
    }

    printSyntaxTree("primary()", false);
}

void factor()
{
    printSyntaxTree("factor()", true);

    // primary
    primary();

    bool isPower = false;

    // determine if next token is POWER
    getNextToken();
    if (currentToken == POWER)
    {
        validateToken(POWER, "_");
        isPower = true;
    }
    else
    {
        printSyntaxTree("factor()", false);
        return;
    }

    // factor
    factor();

    if (isPower)
    {
        emitToOutput("POW", "", true);
    }

    printSyntaxTree("factor()", false);
}

void term()
{
    printSyntaxTree("term()", true);

    // factor
    factor();
    char* sym;

    // determine if next token is MULT or AND
    getNextToken();
    if (currentToken == MULT)
    {
        validateToken(MULT, addQuotes(str));
        sym = strdup(str);
    }
    else if (currentToken == AND)
    {
        validateToken(AND, "_");
        sym = strdup(str);
    }
    else
    {
        printSyntaxTree("term()", false);
        return;
    }

    // term
    term();

    if (strcmp(sym,"*") == 0)
    {   
        emitToOutput("MPY", "", true);
    }
    else if (strcmp(sym,"div") == 0)
    {
        emitToOutput("DIV", "", true);
    }
    else if (strcmp(sym,"and") == 0)
    {
        emitToOutput("AND", "", true);
    }

    printSyntaxTree("term()", false);
}

void simpleExpression()
{
    printSyntaxTree("simpleExpression()", true);

    // term
    term();
    char* sym;

    // determine if next token is ADD or OR
    getNextToken();
    if (currentToken == ADD)
    {
        validateToken(ADD, addQuotes(str));
        sym = strdup(str);
    }
    else if (currentToken == OR)
    {
        validateToken(OR, "_");
        sym = strdup(str);
    }
    else 
    {
        printSyntaxTree("simpleExpression()", false);
        return;
    }

    // simpleExpression
    simpleExpression();

    if (strcmp(sym,"+") == 0)
    {
        emitToOutput("ADD", "", true);
    }
    else if (strcmp(sym,"-") == 0)
    {
        emitToOutput("SUB", "", true);
    }
    else if (strcmp(sym,"or") == 0)
    {
        emitToOutput("OR", "", true);
    }

    printSyntaxTree("simpleExpression()", false);
}

void expression()
{
    printSyntaxTree("expression()", true);

    // simpleExpression
    simpleExpression();

    // determine if next token is COMP
    getNextToken();
    if (currentToken == COMP)
    {
        // COMP
        validateToken(COMP, addQuotes(str));
        char* sym = strdup(str);

        // expression
        expression();

        // emit correct comp to output
        // "<>"|"<="|">="|"<"|">"|"="
        if (strcmp(sym,"<>") == 0)
        {
            emitToOutput("NE", "", true);
        }
        else if (strcmp(sym,"<=") == 0)
        {
            emitToOutput("LE", "", true);
        }
        else if (strcmp(sym,">=") == 0)
        {
            emitToOutput("GE", "", true);
        }
        else if (strcmp(sym,"<") == 0)
        {
            emitToOutput("LT", "", true);
        }
        else if (strcmp(sym,">") == 0)
        {
            emitToOutput("GT", "", true);
        }   
        else if (strcmp(sym,"=") == 0)
        {
            emitToOutput("EQ", "", true);
        }
    }

    printSyntaxTree("expression()", false);
}

void writeInt()
{
    printSyntaxTree("writeInt()", true);

    // WRITEINT
    validateToken(WRITE, "_");

    // expression
    expression();

    emitToOutput("PRINT", "", true);

    printSyntaxTree("writeInt()", false);
}

void whileStatement()
{
    printSyntaxTree("whileStatement()", true);

    char* startLabel = generateLabel();
    char* endLabel = generateLabel();

    emitToOutput("LABEL", startLabel, true);

    // WHILE
    validateToken(WHL, "_");

    // expression
    expression();

    // DO
    getNextToken();
    validateToken(DO, "_");

    emitToOutput("GOFALSE", endLabel, true);

    // statementSequence
    getNextToken();
    statementSequence();

    // ENDWHILE
    getNextToken();
    validateToken(ENDWHL, "_");

    emitToOutput("GOTO", startLabel, true);
    emitToOutput("LABEL", endLabel, true);

    printSyntaxTree("whileStatement()", false);
}

void elseClause()
{
    printSyntaxTree("elseClause()", true);

    getNextToken();
    if (currentToken == ELSE)
    {
        validateToken(ELSE, "_");
        
        // statementSequence
        statementSequence();
    }

    printSyntaxTree("elseClause()", false);
}

void ifStatement()
{
    printSyntaxTree("ifStatement()", true);

    // generate unique label
    char* label = generateLabel();
    char* label2 = generateLabel();

    // IF
    validateToken(IF, "_");

    // expression
    expression();

    // THEN
    getNextToken();
    validateToken(THEN, "_");

    emitToOutput("GOFALSE", label, true);

    // statementSequence
    getNextToken();
    statementSequence();

    emitToOutput("GOTO", label2, true);
    emitToOutput("LABEL", label, true);

    // elseClause
    elseClause();

    // ENDIF
    validateToken(ENDIF, "_");

    emitToOutput("LABEL", label2, true);

    printSyntaxTree("ifStatement()", false);
}

void assignment()
{
    printSyntaxTree("assignment()", true);

    // ID
    getID();
    emitToOutput("LVALUE", str, true);

    // ASGN
    getNextToken();
    validateToken(ASGN, "_");

    getNextToken();
    // determine btwn expression or readInt
    if (currentToken == READ)
    {
        // READINT
        validateToken(READ, "_");

        emitToOutput("READ", "", true);
    }
    else
    {
        // expression
        expression();
    }

    emitToOutput("STO", "", true);

    printSyntaxTree("assignment()", false);
}

void statement()
{
    printSyntaxTree("statement()", true);

    if (currentToken == ID)
    {
        assignment();
    }
    else if (currentToken == IF)
    {
        ifStatement();
    }
    else if (currentToken == WHL)
    {
        whileStatement();
    }
    else if (currentToken == WRITE)
    {
        writeInt();
    }
    
    printSyntaxTree("statement()", false);
}

void statementSequence()
{
    printSyntaxTree("statementSequence()", true);

    getNextToken();
    // return if next token is not
    // ID, IF, WHILE, or WRITEINT
    if (currentToken != ID &&
        currentToken != IF &&
        currentToken != WHL &&
        currentToken != WRITE)
    {
        printSyntaxTree("statementSequence()", false);
        return;
    }

    // statement
    statement();

    // SC
    getNextToken();
    validateToken(SC, "_");

    statementSequence();

    printSyntaxTree("statementSequence()", false);
}

void declarations()
{
    printSyntaxTree("declarations()", true);

    // VAR
    getNextToken();
    // return if next token is not VAR
    if (currentToken != VAR)
    {
        printSyntaxTree("declarations()", false);
        return;
    }
    validateToken(VAR, "_");

    // ID
    getNextToken();
    getID();
    // add to symbol table
    addToSymbolTable(str);
    char buff[128];
    snprintf(buff, sizeof(buff), "%s:", str);
    emitToOutput(buff, "word", true);
    
    // AS
    getNextToken();
    validateToken(AS, "_");

    // INT
    getNextToken();
    validateToken(INT, "_");

    // SC
    getNextToken();
    validateToken(SC, "_");

    // more declarations
    declarations();

    printSyntaxTree("declarations()", false);
}

void program()
{
    printf("starting lexical analysis...\n");
    printSyntaxTree("program()", true);

    // PRGM
    getNextToken();
    validateToken(PRGM, "_");
    emitToOutput("Section", ".data", false);

    // declarations
    declarations();

    // BEGIN
    validateToken(BGN, "_");
    emitToOutput("Section", ".code", false);

    // finished making symbol table
    makingTable = false;

    // statementSequence
    statementSequence();

    validateToken(END, "_");
    emitToOutput("HALT", "", true);
    
    printSyntaxTree("program()", false);
    printf("\nlexical analysis complete...\n");
}

void symbolTable()
{
    printf("\nSymbol Table");
    printf("\n-------------\n");

    for (int i = 0; i < symIndex; i++)
    {
        printf("%s\tint\n", symTab[i]);
    }
}

int main(int argc, char* argv[])
{
    if (argc > 1)
    {
        FILE *fp = fopen(argv[1], "r");
        if (fp) yyin = fp;
    }

    numLabel = 0;
    
    outfile = fopen("outfile.txt", "w+");
    program();
    symbolTable();
    fclose(outfile);

    return 1;
}