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

#ifndef YY_YY_SRC_MAIN_TAB_H_INCLUDED
# define YY_YY_SRC_MAIN_TAB_H_INCLUDED
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
    TRUE = 258,
    FALSE = 259,
    T_CHAR = 260,
    T_INT = 261,
    T_STRING = 262,
    T_BOOL = 263,
    T_VOID = 264,
    IDAddr = 265,
    IDPtr = 266,
    K_IF = 267,
    K_ELSE = 268,
    K_WHILE = 269,
    K_FOR = 270,
    K_SKIP = 271,
    F_PRINTF = 272,
    F_SCANF = 273,
    LOP_ADD = 274,
    LOP_SUB = 275,
    LOP_MULT = 276,
    LOP_DEV = 277,
    LOP_MOD = 278,
    LOP_DADD = 279,
    LOP_DSUB = 280,
    LOP_ADDASS = 281,
    LOP_SUBASS = 282,
    LOP_MULTASS = 283,
    LOP_DEVASS = 284,
    LOP_MODASS = 285,
    LOP_AND = 286,
    LOP_OR = 287,
    LOP_NOT = 288,
    LOP_BNOT = 289,
    LOP_BOR = 290,
    LOP_BAND = 291,
    LOP_XOR = 292,
    LOP_EQ = 293,
    LOP_NEQ = 294,
    LOP_L = 295,
    LOP_LEQ = 296,
    LOP_S = 297,
    LOP_SEQ = 298,
    LOP_SHL = 299,
    LOP_SHR = 300,
    LOP_ASSIGN = 301,
    SEMICOLON = 302,
    LPAREN = 303,
    RPAREN = 304,
    LBRACE = 305,
    RBRACE = 306,
    IDENTIFIER = 307,
    INTEGER = 308,
    CHAR = 309,
    BOOL = 310,
    STRING = 311,
    COMMA = 312,
    LOP_MUL = 313,
    LOP_DIV = 314,
    UMINUS = 315,
    UADD = 316
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_SRC_MAIN_TAB_H_INCLUDED  */
