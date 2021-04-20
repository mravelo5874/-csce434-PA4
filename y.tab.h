/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    NUM = 258,
    ID = 259,
    LP = 260,
    RP = 261,
    ASGN = 262,
    SC = 263,
    AS = 264,
    POWER = 265,
    MULT = 266,
    ADD = 267,
    COMP = 268,
    IF = 269,
    THEN = 270,
    ELSE = 271,
    BGN = 272,
    ENDIF = 273,
    WHL = 274,
    ENDWHL = 275,
    DO = 276,
    PRGM = 277,
    END = 278,
    VAR = 279,
    INT = 280,
    AND = 281,
    OR = 282,
    NOT = 283,
    READ = 284,
    WRITE = 285,
    INVALID = 286
  };
#endif
/* Tokens.  */
#define NUM 258
#define ID 259
#define LP 260
#define RP 261
#define ASGN 262
#define SC 263
#define AS 264
#define POWER 265
#define MULT 266
#define ADD 267
#define COMP 268
#define IF 269
#define THEN 270
#define ELSE 271
#define BGN 272
#define ENDIF 273
#define WHL 274
#define ENDWHL 275
#define DO 276
#define PRGM 277
#define END 278
#define VAR 279
#define INT 280
#define AND 281
#define OR 282
#define NOT 283
#define READ 284
#define WRITE 285
#define INVALID 286

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
