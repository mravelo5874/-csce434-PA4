%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <stdbool.h>

    /* TOKEN INTS */
    #define NUM     0
    #define ID      1
    #define LP      2
    #define RP      3
    #define ASGN    4
    #define SC      5
    #define AS      6
    #define POWER   7
    #define MULT    8
    #define ADD     9
    #define COMP    10
    #define IF      11
    #define THEN    12
    #define ELSE    13
    #define BGN     14
    #define ENDIF   15
    #define WHL     16
    #define ENDWHL  17
    #define DO      18
    #define PRGM    19
    #define END     20
    #define VAR     21
    #define INT     22
    #define AND     23
    #define OR      24
    #define NOT     25
    #define READ    26
    #define WRITE   27

    #define INVALID 99

    int ln = 1; 
    int pos = 0;
    char* str = NULL;

    int currentToken = 0;
    bool printTree = false;
    bool isValidated = true;
    bool makingTable = true;

    // SYMBOL TABLE
    // max symbols = 64
    // max char length = 128
    char symTab[64][128];
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
                str = yytext;
                return(NUM);
            }

{id}        {   
                pos += yyleng;
                str = yytext;
                return(ID);
            }

{LP}        {   
                pos += yyleng;
                str = yytext;
                return(LP);
            }

{RP}        {   
                pos += yyleng;
                str = yytext;
                return(RP);
            }

{ASGN}      {
                pos += yyleng;
                str = yytext;
                return(ASGN);
            }

{SC}        {
                pos += yyleng;
                str = yytext;
                return(SC);
            }

{AS}        {
                pos += yyleng;
                str = yytext;
                return(AS);
            }

{POWER}     {
                pos += yyleng;
                str = yytext;
                return(POWER);
            }

{MULT}      {
                pos += yyleng;
                str = yytext;
                return(MULT);
            }

{ADD}       {
                pos += yyleng;
                str = yytext;
                return(ADD);
            }

{COMP}      {              
                pos += yyleng;
                str = yytext;
                return(COMP);
            }

{IF}        {
                pos += yyleng;
                str = yytext;
                return(IF);
            }

{THEN}      {
                pos += yyleng;
                str = yytext;
                return(THEN);
            }

{ELSE}      {
                pos += yyleng;
                str = yytext;
                return(ELSE);
            }

{BEGIN}     {
                pos += yyleng;
                str = yytext;
                return(BGN);
            }

{ENDIF}     {
                pos += yyleng;
                str = yytext;
                return(ENDIF);
            }

{WHILE}     {
                pos += yyleng;
                str = yytext;
                return(WHL);
            }

{ENDWHILE}  {
                pos += yyleng;
                str = yytext;
                return(ENDWHL);
            }

{DO}        {
                pos += yyleng;
                str = yytext;
                return(DO);
            }

{PROGRAM}   {
                pos += yyleng;
                str = yytext;
                return(PRGM);
            }

{END}       {
                pos += yyleng;
                str = yytext;
                return(END);
            }

{VAR}       {
                pos += yyleng;
                str = yytext;
                return(VAR);
            }
        
{INT}       {
                pos += yyleng;
                str = yytext;
                return(INT);
            }

{AND}       {
                pos += yyleng;
                str = yytext;
                return(AND);
            }

{OR}        {
                pos += yyleng;
                str = yytext;
                return(OR);
            }
        
{NOT}       {
                pos += yyleng;
                str = yytext;
                return(NOT);
            }
        
{WRITEINT}  {
                pos += yyleng;
                str = yytext;
                return(WRITE);
            }

{READINT}   {
                pos += yyleng;
                str = yytext;
                return(READ);
            }

.           {
                pos += yyleng;
                str = yytext;
                return(INVALID);
            } 
%%

/* BNF GRAMMAR */

// <program>            ::= PROGRAM <declarations> BEGIN <statementSequence> END
// -------------------------------------------------------------------------------------
// <declarations>       ::= VAR ident AS <type> SC <declarations>
//                        | ε
// -------------------------------------------------------------------------------------
// <type>               ::= INT 
// -------------------------------------------------------------------------------------
// <statementSequence>  ::= <statement> SC <statementSequence>
//                        | ε
// -------------------------------------------------------------------------------------
// <statement>          ::= <assignment>
//                        | <ifStatement>
//                        | <whileStatement>
//                        | <writeInt>
//                        | ε
// -------------------------------------------------------------------------------------
// <assignment>         ::= ident ASGN <expression>
//                        | ident ASGN READINT
// -------------------------------------------------------------------------------------
// <ifStatement>        ::= IF <expression> THEN <statementSequence> <elseClause> ENDIF
// -------------------------------------------------------------------------------------
// <elseClause>         ::= ELSE <statementSequence>
//                        | ε
// -------------------------------------------------------------------------------------
// <whileStatement>     ::= WHILE <expression> DO <statementSequence> ENDWHILE
// -------------------------------------------------------------------------------------
// <writeInt>           ::= WRITEINT <expression>
// -------------------------------------------------------------------------------------
// <expression>         ::= <simpleExpression>
//                        | <simpleExpression> COMPARE <expression>
// -------------------------------------------------------------------------------------
// <simpleExpression>   ::= <term> ADDITIVE <simpleExpression>
//                        | term OR <simpleexpression>
//                        |<term>
// -------------------------------------------------------------------------------------
// <term>               ::= <factor> MULTIPLICATIVE <term>
//                        | <factor> AND <term> 
//                        | <factor>
// -------------------------------------------------------------------------------------
// <factor>             ::= <primary> POWER<factor> 
//                        | <primary>
// -------------------------------------------------------------------------------------
// <primary>            ::= ident
//                        | num
//                        | LP <expression> RP
//                        | “-“ <primary>
//                        | NOT <primary>

/* UTIL FUNCTIONS */
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

void printError(char* type, char* msg)
{
    printf("\n\n[%s] %s at line %d pos %d\n", type, msg, ln, pos);
    exit(-1);
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
    printf("<%s, %s> ", getTokenStr(currentToken), _str);
}

void getNextToken()
{
    if (!isValidated)
        return;

    currentToken = yylex();
    isValidated = false;

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




/* GRAMMAR FUNCTIONS */

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
    }
    else if (currentToken == NUM)
    {
        getNum();
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
    }
    else if (currentToken == NOT)
    {
        validateToken(NOT, "_");

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

    // determine if next token is POWER
    getNextToken();
    if (currentToken == POWER)
    {
        validateToken(POWER, "_");
    }
    else
    {
        printSyntaxTree("factor()", false);
        return;
    }

    // factor
    factor();

    printSyntaxTree("factor()", false);
}

void term()
{
    printSyntaxTree("term()", true);

    // factor
    factor();

    // determine if next token is MULT or AND
    getNextToken();
    if (currentToken == MULT)
    {
        validateToken(MULT, addQuotes(str));
    }
    else if (currentToken == AND)
    {
        validateToken(AND, "_");
    }
    else
    {
        printSyntaxTree("term()", false);
        return;
    }

    // term
    term();

    printSyntaxTree("term()", false);
}

void simpleExpression()
{
    printSyntaxTree("simpleExpression()", true);

    // term
    term();

    // determine if next token is ADD or OR
    getNextToken();
    if (currentToken == ADD)
    {
        validateToken(ADD, addQuotes(str));
    }
    else if (currentToken == OR)
    {
        validateToken(OR, "_");
    }
    else 
    {
        printSyntaxTree("simpleExpression()", false);
        return;
    }

    // simpleExpression
    simpleExpression();

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

        // expression
        expression();
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

    printSyntaxTree("writeInt()", false);
}

void whileStatement()
{
    printSyntaxTree("whileStatement()", true);

    // WHILE
    validateToken(WHL, "_");

    // expression
    expression();

    // DO
    getNextToken();
    validateToken(DO, "_");

    // statementSequence
    getNextToken();
    statementSequence();

    // ENDWHILE
    getNextToken();
    validateToken(ENDWHL, "_");

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

    // IF
    validateToken(IF, "_");

    // expression
    expression();

    // THEN
    getNextToken();
    validateToken(THEN, "_");

    // statementSequence
    getNextToken();
    statementSequence();

    // elseClause
    elseClause();

    // ENDIF
    validateToken(ENDIF, "_");

    printSyntaxTree("ifStatement()", false);
}

void assignment()
{
    printSyntaxTree("assignment()", true);

    // ID
    getID();

    // ASGN
    getNextToken();
    validateToken(ASGN, "_");

    getNextToken();
    // determine btwn expression or readInt
    if (currentToken == READ)
    {
        // READINT
        validateToken(READ, "_");
    }
    else
    {
        // expression
        expression();
    }

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

    // declarations
    declarations();

    // BEGIN
    validateToken(BGN, "_");

    // finished making symbol table
    makingTable = false;

    // statementSequence
    statementSequence();

    validateToken(END, "_");
    
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

    program();
    symbolTable();

    return 1;
}