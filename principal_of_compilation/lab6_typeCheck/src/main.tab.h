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
    T_CHAR = 258,
    T_INT = 259,
    T_STRING = 260,
    T_BOOL = 261,
    T_VOID = 262,
    T_DOUBLE = 263,
    T_ARRAY = 264,
    K_IF = 265,
    K_ELSE = 266,
    K_WHILE = 267,
    K_FOR = 268,
    K_SKIP = 269,
    K_BREAK = 270,
    K_CASE = 271,
    K_CONTINUE = 272,
    K_DEFAULT = 273,
    K_RET = 274,
    K_SWITCH = 275,
    LOP_DADD = 276,
    LOP_DSUB = 277,
    LOP_ADD = 278,
    LOP_SUB = 279,
    LOP_MULT = 280,
    LOP_DEV = 281,
    LOP_MOD = 282,
    LOP_NOT = 283,
    LOP_BNOT = 284,
    LOP_AND = 285,
    LOP_OR = 286,
    LOP_BOR = 287,
    LOP_BAND = 288,
    LOP_XOR = 289,
    QM = 290,
    COLON = 291,
    LOP_EQ = 292,
    LOP_NEQ = 293,
    LOP_L = 294,
    LOP_LEQ = 295,
    LOP_S = 296,
    LOP_SEQ = 297,
    LOP_SHL = 298,
    LOP_SHR = 299,
    LOP_ADDASS = 300,
    LOP_SUBASS = 301,
    LOP_MULTASS = 302,
    LOP_DEVASS = 303,
    LOP_MODASS = 304,
    LOP_ASSIGN = 305,
    SEMICOLON = 306,
    LPAREN = 307,
    RPAREN = 308,
    LBRACE = 309,
    RBRACE = 310,
    LBRACKET = 311,
    RBRACKET = 312,
    SYMBOL = 313,
    IDENTIFIER = 314,
    COMMA = 315,
    LOP_MUL = 316,
    LOP_DIV = 317,
    IFX = 318,
    UMINUS = 319,
    UADD = 320
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 16 "src/main.y"

  string *value;
  Symbol *symbol;
  TreeNode *node;

#line 129 "src/main.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_SRC_MAIN_TAB_H_INCLUDED  */
