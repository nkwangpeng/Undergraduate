/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison implementation for Yacc-like parsers in C

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

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "3.5.1"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* First part of user prologue.  */
#line 1 "src/main.y"

    #include "common.h"
    class TreeNode;
    TreeNode* root;
    extern int lineno;
    Scope *scope = new Scope();
    Scope *scope_out = new Scope();
    Callable *currFunc = nullptr;
    int currFuncCount = 0;
    map<Callable*, list<Symbol*>> funcTable;
    Symbol::ValueType currentType = Symbol::VALUE_NONE;
    Symbol::ValueType currentFunType = Symbol::VALUE_NONE;
    int yylex();
    int yyerror( char const * );

#line 86 "src/main.tab.cpp"

# ifndef YY_CAST
#  ifdef __cplusplus
#   define YY_CAST(Type, Val) static_cast<Type> (Val)
#   define YY_REINTERPRET_CAST(Type, Val) reinterpret_cast<Type> (Val)
#  else
#   define YY_CAST(Type, Val) ((Type) (Val))
#   define YY_REINTERPRET_CAST(Type, Val) ((Type) (Val))
#  endif
# endif
# ifndef YY_NULLPTR
#  if defined __cplusplus
#   if 201103L <= __cplusplus
#    define YY_NULLPTR nullptr
#   else
#    define YY_NULLPTR 0
#   endif
#  else
#   define YY_NULLPTR ((void*)0)
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* Use api.header.include to #include this header
   instead of duplicating it here.  */
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

#line 210 "src/main.tab.cpp"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_SRC_MAIN_TAB_H_INCLUDED  */



#ifdef short
# undef short
#endif

/* On compilers that do not define __PTRDIFF_MAX__ etc., make sure
   <limits.h> and (if available) <stdint.h> are included
   so that the code can choose integer types of a good width.  */

#ifndef __PTRDIFF_MAX__
# include <limits.h> /* INFRINGES ON USER NAME SPACE */
# if defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stdint.h> /* INFRINGES ON USER NAME SPACE */
#  define YY_STDINT_H
# endif
#endif

/* Narrow types that promote to a signed type and that can represent a
   signed or unsigned integer of at least N bits.  In tables they can
   save space and decrease cache pressure.  Promoting to a signed type
   helps avoid bugs in integer arithmetic.  */

#ifdef __INT_LEAST8_MAX__
typedef __INT_LEAST8_TYPE__ yytype_int8;
#elif defined YY_STDINT_H
typedef int_least8_t yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef __INT_LEAST16_MAX__
typedef __INT_LEAST16_TYPE__ yytype_int16;
#elif defined YY_STDINT_H
typedef int_least16_t yytype_int16;
#else
typedef short yytype_int16;
#endif

#if defined __UINT_LEAST8_MAX__ && __UINT_LEAST8_MAX__ <= __INT_MAX__
typedef __UINT_LEAST8_TYPE__ yytype_uint8;
#elif (!defined __UINT_LEAST8_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST8_MAX <= INT_MAX)
typedef uint_least8_t yytype_uint8;
#elif !defined __UINT_LEAST8_MAX__ && UCHAR_MAX <= INT_MAX
typedef unsigned char yytype_uint8;
#else
typedef short yytype_uint8;
#endif

#if defined __UINT_LEAST16_MAX__ && __UINT_LEAST16_MAX__ <= __INT_MAX__
typedef __UINT_LEAST16_TYPE__ yytype_uint16;
#elif (!defined __UINT_LEAST16_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST16_MAX <= INT_MAX)
typedef uint_least16_t yytype_uint16;
#elif !defined __UINT_LEAST16_MAX__ && USHRT_MAX <= INT_MAX
typedef unsigned short yytype_uint16;
#else
typedef int yytype_uint16;
#endif

#ifndef YYPTRDIFF_T
# if defined __PTRDIFF_TYPE__ && defined __PTRDIFF_MAX__
#  define YYPTRDIFF_T __PTRDIFF_TYPE__
#  define YYPTRDIFF_MAXIMUM __PTRDIFF_MAX__
# elif defined PTRDIFF_MAX
#  ifndef ptrdiff_t
#   include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  endif
#  define YYPTRDIFF_T ptrdiff_t
#  define YYPTRDIFF_MAXIMUM PTRDIFF_MAX
# else
#  define YYPTRDIFF_T long
#  define YYPTRDIFF_MAXIMUM LONG_MAX
# endif
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned
# endif
#endif

#define YYSIZE_MAXIMUM                                  \
  YY_CAST (YYPTRDIFF_T,                                 \
           (YYPTRDIFF_MAXIMUM < YY_CAST (YYSIZE_T, -1)  \
            ? YYPTRDIFF_MAXIMUM                         \
            : YY_CAST (YYSIZE_T, -1)))

#define YYSIZEOF(X) YY_CAST (YYPTRDIFF_T, sizeof (X))

/* Stored state numbers (used for stacks). */
typedef yytype_uint8 yy_state_t;

/* State numbers in computations.  */
typedef int yy_state_fast_t;

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef YY_ATTRIBUTE_PURE
# if defined __GNUC__ && 2 < __GNUC__ + (96 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_PURE __attribute__ ((__pure__))
# else
#  define YY_ATTRIBUTE_PURE
# endif
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# if defined __GNUC__ && 2 < __GNUC__ + (7 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_UNUSED __attribute__ ((__unused__))
# else
#  define YY_ATTRIBUTE_UNUSED
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && ! defined __ICC && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                            \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")              \
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END      \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif

#if defined __cplusplus && defined __GNUC__ && ! defined __ICC && 6 <= __GNUC__
# define YY_IGNORE_USELESS_CAST_BEGIN                          \
    _Pragma ("GCC diagnostic push")                            \
    _Pragma ("GCC diagnostic ignored \"-Wuseless-cast\"")
# define YY_IGNORE_USELESS_CAST_END            \
    _Pragma ("GCC diagnostic pop")
#endif
#ifndef YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_END
#endif


#define YY_ASSERT(E) ((void) (0 && (E)))

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yy_state_t yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (YYSIZEOF (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (YYSIZEOF (yy_state_t) + YYSIZEOF (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYPTRDIFF_T yynewbytes;                                         \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * YYSIZEOF (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / YYSIZEOF (*yyptr);                        \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, YY_CAST (YYSIZE_T, (Count)) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYPTRDIFF_T yyi;                      \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  59
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   370

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  66
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  31
/* YYNRULES -- Number of rules.  */
#define YYNRULES  91
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  174

#define YYUNDEFTOK  2
#define YYMAXUTOK   320


/* YYTRANSLATE(TOKEN-NUM) -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, with out-of-bounds checking.  */
#define YYTRANSLATE(YYX)                                                \
  (0 <= (YYX) && (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex.  */
static const yytype_int8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    60,    61,    62,    63,    64,
      65
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_int16 yyrline[] =
{
       0,    70,    70,    75,    79,    85,    88,    94,   100,   105,
     106,   107,   112,   113,   114,   115,   116,   117,   121,   122,
     125,   137,   144,   154,   160,   166,   167,   170,   181,   191,
     206,   211,   217,   222,   225,   231,   232,   235,   239,   245,
     248,   251,   254,   257,   260,   263,   266,   269,   272,   275,
     278,   281,   284,   287,   290,   293,   296,   299,   302,   305,
     308,   311,   314,   317,   320,   323,   326,   329,   332,   335,
     338,   341,   344,   347,   350,   353,   356,   359,   362,   365,
     374,   384,   387,   390,   393,   396,   402,   403,   404,   405,
     406,   407
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "T_CHAR", "T_INT", "T_STRING", "T_BOOL",
  "T_VOID", "T_DOUBLE", "T_ARRAY", "K_IF", "K_ELSE", "K_WHILE", "K_FOR",
  "K_SKIP", "K_BREAK", "K_CASE", "K_CONTINUE", "K_DEFAULT", "K_RET",
  "K_SWITCH", "LOP_DADD", "LOP_DSUB", "LOP_ADD", "LOP_SUB", "LOP_MULT",
  "LOP_DEV", "LOP_MOD", "LOP_NOT", "LOP_BNOT", "LOP_AND", "LOP_OR",
  "LOP_BOR", "LOP_BAND", "LOP_XOR", "QM", "COLON", "LOP_EQ", "LOP_NEQ",
  "LOP_L", "LOP_LEQ", "LOP_S", "LOP_SEQ", "LOP_SHL", "LOP_SHR",
  "LOP_ADDASS", "LOP_SUBASS", "LOP_MULTASS", "LOP_DEVASS", "LOP_MODASS",
  "LOP_ASSIGN", "SEMICOLON", "LPAREN", "RPAREN", "LBRACE", "RBRACE",
  "LBRACKET", "RBRACKET", "SYMBOL", "IDENTIFIER", "COMMA", "LOP_MUL",
  "LOP_DIV", "IFX", "UMINUS", "UADD", "$accept", "start", "program",
  "program_empty", "LB_SCOPE", "bool_expression", "statement", "call_args",
  "args", "def_func", "return_stmt", "declaration", "IDLIST", "ID_ASS",
  "if_else_stmt", "if_stmt", "while_stmt", "for_stmt", "expr",
  "assignment", "or_expr", "and_expr", "bor_expr", "xor_expr", "band_expr",
  "comp_expr", "sh_expr", "as_expr", "term", "factor", "T", YY_NULLPTR
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_int16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,   297,   298,   299,   300,   301,   302,   303,   304,
     305,   306,   307,   308,   309,   310,   311,   312,   313,   314,
     315,   316,   317,   318,   319,   320
};
# endif

#define YYPACT_NINF (-139)

#define yypact_value_is_default(Yyn) \
  ((Yyn) == YYPACT_NINF)

#define YYTABLE_NINF (-7)

#define yytable_value_is_error(Yyn) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
     272,  -139,  -139,  -139,  -139,  -139,  -139,   -31,   -29,    -3,
      35,    35,    35,    35,    35,    35,    35,    35,    35,  -139,
    -139,   -50,    33,    22,   272,  -139,  -139,  -139,    11,  -139,
    -139,  -139,  -139,    18,   154,    42,    60,    45,    64,    67,
     212,   -41,    62,   163,  -139,    53,    35,    35,   311,    50,
     163,   163,   220,   220,   163,   163,   163,   -13,    35,  -139,
    -139,   101,  -139,  -139,    35,    35,    35,    35,    35,    35,
      35,    35,    35,    35,    35,    35,    35,    35,    35,    35,
      35,    35,    35,    35,    35,    35,    35,  -139,  -139,    37,
      37,    37,    47,    55,  -139,    84,    19,    86,    82,    80,
      95,  -139,  -139,    15,  -139,    66,   154,   154,   154,   154,
     154,   154,   154,    60,    45,    45,    67,   212,   -41,   -41,
     -41,   -41,   -41,   -41,    62,    62,   163,   163,  -139,  -139,
    -139,    35,    29,    99,    95,   272,   272,    35,    35,   117,
    -139,  -139,    90,   104,  -139,   -36,  -139,   112,  -139,   161,
    -139,   123,   124,   158,   104,   119,  -139,   272,    35,    35,
     215,   121,   158,  -139,  -139,    83,    92,  -139,   128,   272,
     272,  -139,  -139,  -139
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_int8 yydefact[] =
{
      38,    87,    86,    90,    88,    89,    91,     0,     0,     0,
      38,     0,     0,     0,     0,     0,     0,     0,    38,     7,
      85,    79,     0,    38,    38,     4,    17,    12,     0,    14,
      13,    15,    16,     0,    35,    45,    47,    49,    51,    53,
      55,    62,    65,    68,    77,     0,    38,    38,    38,     0,
      74,    75,    83,    84,    81,    82,    76,     0,    38,     1,
       3,    38,     9,    10,    38,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    72,    73,     0,
       0,     0,    28,    24,    25,     0,     8,     0,     0,     0,
       0,    23,    78,     0,    11,     0,    37,    40,    41,    42,
      43,    44,    39,    46,    48,    50,    52,    54,    56,    57,
      60,    58,    61,    59,    63,    64,    66,    67,    69,    70,
      71,    38,     0,     0,     0,    38,    38,    38,    38,    28,
      80,    36,    27,     0,    20,     0,    18,     0,    26,    31,
      32,     0,     0,    38,     0,     0,    29,    38,    38,    38,
      38,     0,    38,    19,    30,     0,     0,    22,     0,    38,
      38,    21,    34,    33
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -139,  -139,     7,    43,  -138,   -46,   -19,  -139,    51,  -139,
    -139,   159,  -139,    74,  -139,  -139,  -139,  -139,   -10,   127,
    -139,   137,   -21,  -139,   136,   138,   178,    63,    -2,   -71,
     167
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,    22,   160,   161,    24,    95,    25,   145,   146,    26,
      27,    28,    93,    94,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
      49,    97,    83,    84,    60,   153,    58,    23,    57,    50,
      51,    52,    53,    54,    55,    56,   162,   154,   128,   129,
     130,    46,    -2,    47,   155,     1,     2,     3,     4,     5,
       6,    61,     7,    59,     8,     9,    96,    96,    99,    64,
     102,    10,    60,    11,    12,    13,    14,    65,   103,    48,
      15,    16,   114,   115,   105,    17,    11,    12,    13,    14,
      13,    14,    62,    15,    16,    15,    16,    64,    17,    63,
      64,    64,   140,    72,    18,    65,    19,    74,    65,    65,
      20,    21,   143,   126,   127,    85,    86,    18,   144,    18,
      73,   151,   152,    20,    21,    20,    21,   131,    75,   132,
      76,   101,    64,   133,     1,     2,     3,     4,     5,     6,
      65,     7,    92,     8,     9,   134,   149,   150,    64,   141,
      10,   142,    11,    12,    13,    14,    65,    96,    96,    15,
      16,   138,    64,   137,    17,    64,   169,   135,   164,   136,
      65,    60,    64,    65,    64,   170,   124,   125,   165,   166,
     172,   173,    65,    18,   139,    19,   104,   147,    19,    20,
      21,     1,     2,     3,     4,     5,     6,   131,     7,   156,
       8,     9,   157,   133,   158,   159,   167,    10,   144,    11,
      12,    13,    14,   171,    87,    88,    15,    16,    89,    90,
      91,    17,   106,   107,   108,   109,   110,   111,   112,    66,
      67,    68,    69,    70,    71,   168,   163,    98,   148,   113,
      18,   116,    19,    -6,   117,   100,    20,    21,     1,     2,
       3,     4,     5,     6,     0,     7,     0,     8,     9,     0,
       0,     0,     0,     0,    10,     0,    11,    12,    13,    14,
       0,    87,    88,    15,    16,    89,    90,     0,    17,    77,
      78,    79,    80,    81,    82,   118,   119,   120,   121,   122,
     123,     0,     0,     0,     0,     0,     0,    18,     0,    19,
      -5,     0,     0,    20,    21,     1,     2,     3,     4,     5,
       6,     0,     7,     0,     8,     9,     0,     0,     0,     0,
       0,    10,     0,    11,    12,    13,    14,     0,     0,     0,
      15,    16,     0,     0,     0,    17,     0,     0,     0,     0,
       0,     0,     0,     0,     1,     2,     3,     4,     5,     6,
       0,     0,     0,     0,    18,     0,    19,     0,     0,     0,
      20,    21,    11,    12,    13,    14,     0,     0,     0,    15,
      16,     0,     0,     0,    17,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    18,     0,     0,     0,     0,     0,    20,
      21
};

static const yytype_int16 yycheck[] =
{
      10,    47,    43,    44,    23,   143,    56,     0,    18,    11,
      12,    13,    14,    15,    16,    17,   154,    53,    89,    90,
      91,    52,     0,    52,    60,     3,     4,     5,     6,     7,
       8,    24,    10,     0,    12,    13,    46,    47,    48,    52,
      53,    19,    61,    21,    22,    23,    24,    60,    58,    52,
      28,    29,    73,    74,    64,    33,    21,    22,    23,    24,
      23,    24,    51,    28,    29,    28,    29,    52,    33,    51,
      52,    52,    57,    31,    52,    60,    54,    32,    60,    60,
      58,    59,    53,    85,    86,    23,    24,    52,    59,    52,
      30,   137,   138,    58,    59,    58,    59,    50,    34,    52,
      33,    51,    52,    56,     3,     4,     5,     6,     7,     8,
      60,    10,    59,    12,    13,    60,   135,   136,    52,    53,
      19,   131,    21,    22,    23,    24,    60,   137,   138,    28,
      29,    51,    52,    51,    33,    52,    53,    53,   157,    53,
      60,   160,    52,    60,    52,    53,    83,    84,   158,   159,
     169,   170,    60,    52,    59,    54,    55,    58,    54,    58,
      59,     3,     4,     5,     6,     7,     8,    50,    10,    57,
      12,    13,    11,    56,    51,    51,    55,    19,    59,    21,
      22,    23,    24,    55,    21,    22,    28,    29,    25,    26,
      27,    33,    65,    66,    67,    68,    69,    70,    71,    45,
      46,    47,    48,    49,    50,   162,   155,    48,   134,    72,
      52,    75,    54,    55,    76,    48,    58,    59,     3,     4,
       5,     6,     7,     8,    -1,    10,    -1,    12,    13,    -1,
      -1,    -1,    -1,    -1,    19,    -1,    21,    22,    23,    24,
      -1,    21,    22,    28,    29,    25,    26,    -1,    33,    37,
      38,    39,    40,    41,    42,    77,    78,    79,    80,    81,
      82,    -1,    -1,    -1,    -1,    -1,    -1,    52,    -1,    54,
      55,    -1,    -1,    58,    59,     3,     4,     5,     6,     7,
       8,    -1,    10,    -1,    12,    13,    -1,    -1,    -1,    -1,
      -1,    19,    -1,    21,    22,    23,    24,    -1,    -1,    -1,
      28,    29,    -1,    -1,    -1,    33,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,     3,     4,     5,     6,     7,     8,
      -1,    -1,    -1,    -1,    52,    -1,    54,    -1,    -1,    -1,
      58,    59,    21,    22,    23,    24,    -1,    -1,    -1,    28,
      29,    -1,    -1,    -1,    33,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    52,    -1,    -1,    -1,    -1,    -1,    58,
      59
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_int8 yystos[] =
{
       0,     3,     4,     5,     6,     7,     8,    10,    12,    13,
      19,    21,    22,    23,    24,    28,    29,    33,    52,    54,
      58,    59,    67,    68,    70,    72,    75,    76,    77,    80,
      81,    82,    83,    84,    85,    86,    87,    88,    89,    90,
      91,    92,    93,    94,    95,    96,    52,    52,    52,    84,
      94,    94,    94,    94,    94,    94,    94,    84,    56,     0,
      72,    68,    51,    51,    52,    60,    45,    46,    47,    48,
      49,    50,    31,    30,    32,    34,    33,    37,    38,    39,
      40,    41,    42,    43,    44,    23,    24,    21,    22,    25,
      26,    27,    59,    78,    79,    71,    84,    71,    77,    84,
      96,    51,    53,    84,    55,    84,    85,    85,    85,    85,
      85,    85,    85,    87,    88,    88,    90,    91,    92,    92,
      92,    92,    92,    92,    93,    93,    94,    94,    95,    95,
      95,    50,    52,    56,    60,    53,    53,    51,    51,    59,
      57,    53,    84,    53,    59,    73,    74,    58,    79,    72,
      72,    71,    71,    70,    53,    60,    57,    11,    51,    51,
      68,    69,    70,    74,    72,    84,    84,    55,    69,    53,
      53,    55,    72,    72
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_int8 yyr1[] =
{
       0,    66,    67,    68,    68,    69,    69,    70,    71,    72,
      72,    72,    72,    72,    72,    72,    72,    72,    73,    73,
      74,    75,    75,    76,    77,    78,    78,    79,    79,    79,
      80,    81,    82,    83,    83,    84,    84,    84,    84,    85,
      85,    85,    85,    85,    85,    85,    86,    86,    87,    87,
      88,    88,    89,    89,    90,    90,    91,    91,    91,    91,
      91,    91,    91,    92,    92,    92,    93,    93,    93,    94,
      94,    94,    94,    94,    94,    94,    94,    94,    95,    95,
      95,    95,    95,    95,    95,    95,    96,    96,    96,    96,
      96,    96
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_int8 yyr2[] =
{
       0,     2,     1,     2,     1,     1,     0,     1,     1,     2,
       2,     3,     1,     1,     1,     1,     1,     1,     1,     3,
       1,     8,     7,     3,     2,     1,     3,     3,     1,     4,
       7,     5,     5,     9,     9,     1,     4,     3,     0,     3,
       3,     3,     3,     3,     3,     1,     3,     1,     3,     1,
       3,     1,     3,     1,     3,     1,     3,     3,     3,     3,
       3,     3,     1,     3,     3,     1,     3,     3,     1,     3,
       3,     3,     2,     2,     2,     2,     2,     1,     3,     1,
       4,     2,     2,     2,     2,     1,     1,     1,     1,     1,
       1,     1
};


#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)
#define YYEMPTY         (-2)
#define YYEOF           0

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                    \
  do                                                              \
    if (yychar == YYEMPTY)                                        \
      {                                                           \
        yychar = (Token);                                         \
        yylval = (Value);                                         \
        YYPOPSTACK (yylen);                                       \
        yystate = *yyssp;                                         \
        goto yybackup;                                            \
      }                                                           \
    else                                                          \
      {                                                           \
        yyerror (YY_("syntax error: cannot back up")); \
        YYERROR;                                                  \
      }                                                           \
  while (0)

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256



/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)

/* This macro is provided for backward compatibility. */
#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*-----------------------------------.
| Print this symbol's value on YYO.  |
`-----------------------------------*/

static void
yy_symbol_value_print (FILE *yyo, int yytype, YYSTYPE const * const yyvaluep)
{
  FILE *yyoutput = yyo;
  YYUSE (yyoutput);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyo, yytoknum[yytype], *yyvaluep);
# endif
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/*---------------------------.
| Print this symbol on YYO.  |
`---------------------------*/

static void
yy_symbol_print (FILE *yyo, int yytype, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyo, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  yy_symbol_value_print (yyo, yytype, yyvaluep);
  YYFPRINTF (yyo, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yy_state_t *yybottom, yy_state_t *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yy_state_t *yyssp, YYSTYPE *yyvsp, int yyrule)
{
  int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %d):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       yystos[+yyssp[yyi + 1 - yynrhs]],
                       &yyvsp[(yyi + 1) - (yynrhs)]
                                              );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen(S) (YY_CAST (YYPTRDIFF_T, strlen (S)))
#  else
/* Return the length of YYSTR.  */
static YYPTRDIFF_T
yystrlen (const char *yystr)
{
  YYPTRDIFF_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
yystpcpy (char *yydest, const char *yysrc)
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYPTRDIFF_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYPTRDIFF_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
        switch (*++yyp)
          {
          case '\'':
          case ',':
            goto do_not_strip_quotes;

          case '\\':
            if (*++yyp != '\\')
              goto do_not_strip_quotes;
            else
              goto append;

          append:
          default:
            if (yyres)
              yyres[yyn] = *yyp;
            yyn++;
            break;

          case '"':
            if (yyres)
              yyres[yyn] = '\0';
            return yyn;
          }
    do_not_strip_quotes: ;
    }

  if (yyres)
    return yystpcpy (yyres, yystr) - yyres;
  else
    return yystrlen (yystr);
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYPTRDIFF_T *yymsg_alloc, char **yymsg,
                yy_state_t *yyssp, int yytoken)
{
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat: reported tokens (one for the "unexpected",
     one per "expected"). */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Actual size of YYARG. */
  int yycount = 0;
  /* Cumulated lengths of YYARG.  */
  YYPTRDIFF_T yysize = 0;

  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[+*yyssp];
      YYPTRDIFF_T yysize0 = yytnamerr (YY_NULLPTR, yytname[yytoken]);
      yysize = yysize0;
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYPTRDIFF_T yysize1
                    = yysize + yytnamerr (YY_NULLPTR, yytname[yyx]);
                  if (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM)
                    yysize = yysize1;
                  else
                    return 2;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
    default: /* Avoid compiler warnings. */
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    /* Don't count the "%s"s in the final size, but reserve room for
       the terminator.  */
    YYPTRDIFF_T yysize1 = yysize + (yystrlen (yyformat) - 2 * yycount) + 1;
    if (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM)
      yysize = yysize1;
    else
      return 2;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          ++yyp;
          ++yyformat;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
{
  YYUSE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;


/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    yy_state_fast_t yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yy_state_t yyssa[YYINITDEPTH];
    yy_state_t *yyss;
    yy_state_t *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYPTRDIFF_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYPTRDIFF_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  goto yysetstate;


/*------------------------------------------------------------.
| yynewstate -- push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;


/*--------------------------------------------------------------------.
| yysetstate -- set current state (the top of the stack) to yystate.  |
`--------------------------------------------------------------------*/
yysetstate:
  YYDPRINTF ((stderr, "Entering state %d\n", yystate));
  YY_ASSERT (0 <= yystate && yystate < YYNSTATES);
  YY_IGNORE_USELESS_CAST_BEGIN
  *yyssp = YY_CAST (yy_state_t, yystate);
  YY_IGNORE_USELESS_CAST_END

  if (yyss + yystacksize - 1 <= yyssp)
#if !defined yyoverflow && !defined YYSTACK_RELOCATE
    goto yyexhaustedlab;
#else
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYPTRDIFF_T yysize = yyssp - yyss + 1;

# if defined yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        yy_state_t *yyss1 = yyss;
        YYSTYPE *yyvs1 = yyvs;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * YYSIZEOF (*yyssp),
                    &yyvs1, yysize * YYSIZEOF (*yyvsp),
                    &yystacksize);
        yyss = yyss1;
        yyvs = yyvs1;
      }
# else /* defined YYSTACK_RELOCATE */
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yy_state_t *yyss1 = yyss;
        union yyalloc *yyptr =
          YY_CAST (union yyalloc *,
                   YYSTACK_ALLOC (YY_CAST (YYSIZE_T, YYSTACK_BYTES (yystacksize))));
        if (! yyptr)
          goto yyexhaustedlab;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
# undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YY_IGNORE_USELESS_CAST_BEGIN
      YYDPRINTF ((stderr, "Stack size increased to %ld\n",
                  YY_CAST (long, yystacksize)));
      YY_IGNORE_USELESS_CAST_END

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }
#endif /* !defined yyoverflow && !defined YYSTACK_RELOCATE */

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;


/*-----------.
| yybackup.  |
`-----------*/
yybackup:
  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);
  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  /* Discard the shifted token.  */
  yychar = YYEMPTY;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
  case 2:
#line 70 "src/main.y"
          {
    root = (yyvsp[0].node);
}
#line 1559 "src/main.tab.cpp"
    break;

  case 3:
#line 75 "src/main.y"
                    {
    ((yyvsp[-1].node)) -> addSibling((yyvsp[0].node));
    (yyval.node) = (yyvsp[-1].node);
}
#line 1568 "src/main.tab.cpp"
    break;

  case 4:
#line 79 "src/main.y"
            {
    (yyval.node) = (yyvsp[0].node);
}
#line 1576 "src/main.tab.cpp"
    break;

  case 5:
#line 85 "src/main.y"
          {
    (yyval.node) = (yyvsp[0].node);
}
#line 1584 "src/main.tab.cpp"
    break;

  case 6:
#line 88 "src/main.y"
         {
    (yyval.node) = new EmptyNode(lineno);
  }
#line 1592 "src/main.tab.cpp"
    break;

  case 7:
#line 94 "src/main.y"
         {
    scope->pushScope();
}
#line 1600 "src/main.tab.cpp"
    break;

  case 8:
#line 100 "src/main.y"
       {(yyval.node) = new OperatorNode(lineno,OperatorNode::OP_BOOL,{(yyvsp[0].node)});
}
#line 1607 "src/main.tab.cpp"
    break;

  case 9:
#line 105 "src/main.y"
                        {(yyval.node) = (yyvsp[-1].node);}
#line 1613 "src/main.tab.cpp"
    break;

  case 10:
#line 106 "src/main.y"
                 {(yyval.node) = (yyvsp[-1].node);}
#line 1619 "src/main.tab.cpp"
    break;

  case 11:
#line 107 "src/main.y"
                          {
    (yyval.node) = new StmtNode((yyvsp[-1].node)->lineno,StmtNode::STMT_SCOPE);
    (yyval.node) -> addChild((yyvsp[-1].node));
    scope_out->pushScope(scope->popScope());
}
#line 1629 "src/main.tab.cpp"
    break;

  case 12:
#line 112 "src/main.y"
              {(yyval.node) = (yyvsp[0].node);}
#line 1635 "src/main.tab.cpp"
    break;

  case 13:
#line 113 "src/main.y"
          {(yyval.node) = (yyvsp[0].node);}
#line 1641 "src/main.tab.cpp"
    break;

  case 14:
#line 114 "src/main.y"
               {(yyval.node) = (yyvsp[0].node);}
#line 1647 "src/main.tab.cpp"
    break;

  case 15:
#line 115 "src/main.y"
             {(yyval.node) = (yyvsp[0].node);}
#line 1653 "src/main.tab.cpp"
    break;

  case 16:
#line 116 "src/main.y"
           {(yyval.node) = (yyvsp[0].node);}
#line 1659 "src/main.tab.cpp"
    break;

  case 17:
#line 117 "src/main.y"
           {(yyval.node)=(yyvsp[0].node);}
#line 1665 "src/main.tab.cpp"
    break;

  case 18:
#line 121 "src/main.y"
       {(yyval.node) = (yyvsp[0].node);}
#line 1671 "src/main.tab.cpp"
    break;

  case 19:
#line 122 "src/main.y"
                       {(yyval.node)=(yyvsp[-2].node);(yyval.node)->addSibling((yyvsp[0].node));}
#line 1677 "src/main.tab.cpp"
    break;

  case 20:
#line 125 "src/main.y"
             {
    auto symbol = scope->findSymbol(*(yyvsp[0].value));
    if (symbol == nullptr) {
      std::cerr << "Line " << lineno << ": symbol " << *(yyvsp[0].value) << " is not defined." << endl;
      exit(1);
      return -1;
    }
    (yyval.node) = new ExprNode(lineno, symbol);
}
#line 1691 "src/main.tab.cpp"
    break;

  case 21:
#line 137 "src/main.y"
                                                                     {
    Callable* symbol = new Callable(currentFunType, *(yyvsp[-6].value));
    scope->insertSymbol(*(yyvsp[-6].value), (yyvsp[-1].node)->lineno, symbol);
    currFunc = symbol;
    (yyval.node) = new FunStmtNode((yyvsp[-1].node)->lineno, symbol, {(yyvsp[-1].node)});
    scope_out->pushScope(scope->getScopeStack().front());
}
#line 1703 "src/main.tab.cpp"
    break;

  case 22:
#line 144 "src/main.y"
                                                           {
    Callable* symbol = new Callable(currentFunType, *(yyvsp[-5].value));
    scope->insertSymbol(*(yyvsp[-5].value), (yyvsp[-1].node)->lineno, symbol);
    currFunc = symbol;
    (yyval.node) = new FunStmtNode((yyvsp[-1].node)->lineno, symbol, {(yyvsp[-1].node)});
    scope_out->pushScope(scope->getScopeStack().front());
}
#line 1715 "src/main.tab.cpp"
    break;

  case 23:
#line 154 "src/main.y"
                        {
    (yyval.node) = new StmtNode((yyvsp[-1].node)->lineno,StmtNode::STMT_RETURN, {(yyvsp[-1].node)});
}
#line 1723 "src/main.tab.cpp"
    break;

  case 24:
#line 160 "src/main.y"
           {
    (yyval.node) = (yyvsp[0].node);
}
#line 1731 "src/main.tab.cpp"
    break;

  case 25:
#line 166 "src/main.y"
         {(yyval.node) = (yyvsp[0].node);}
#line 1737 "src/main.tab.cpp"
    break;

  case 26:
#line 167 "src/main.y"
                      {(yyval.node)=(yyvsp[-2].node);(yyval.node)->addSibling((yyvsp[0].node));}
#line 1743 "src/main.tab.cpp"
    break;

  case 27:
#line 170 "src/main.y"
                            {
    Symbol* symbol = new Variable(currentType, *(yyvsp[-2].value));
    bool ok = scope->insertSymbol(*(yyvsp[-2].value), (yyvsp[0].node)->lineno, symbol);
    if (!ok)  {
      cerr << "Line " << lineno << ": symbol " << *(yyvsp[-2].value) << " has already been declared." << endl;
      exit(1);
      return -1;
    }
    (yyval.node) = new DeclNode((yyvsp[0].node)->lineno, symbol);
    (yyval.node) -> addChild((yyvsp[0].node));
}
#line 1759 "src/main.tab.cpp"
    break;

  case 28:
#line 181 "src/main.y"
             {
    Symbol* symbol = new Variable(currentType, *(yyvsp[0].value));
    bool ok = scope->insertSymbol(*(yyvsp[0].value), lineno, symbol);
    if (!ok)  {
      cerr << "Line " << lineno << ": symbol " << *(yyvsp[0].value) << " has already been declared." << endl;
      exit(1);
      return -1;
    }
    (yyval.node) = new DeclNode(lineno, symbol);
}
#line 1774 "src/main.tab.cpp"
    break;

  case 29:
#line 191 "src/main.y"
                                      {
    Symbol* symbol = new Variable(Symbol::VALUE_ARRAY , *(yyvsp[-3].value));
    bool ok = scope->insertSymbol(*(yyvsp[-3].value) , lineno , symbol);
    if (!ok)  {
      cerr << "Line " << lineno << ": symbol " << *(yyvsp[-3].value) << " has already been declared." << endl;
      exit(1);
      return -1;
    }
    auto var = new DeclNode(lineno , symbol);
    var -> setArrayLength((yyvsp[-1].symbol)->value);
    (yyval.node) = var;
}
#line 1791 "src/main.tab.cpp"
    break;

  case 30:
#line 206 "src/main.y"
                                                               {
    (yyval.node) = new StmtNode((yyvsp[-4].node)->lineno,StmtNode::STMT_IF_ELSE, {(yyvsp[-4].node), (yyvsp[-2].node), (yyvsp[0].node)});
}
#line 1799 "src/main.tab.cpp"
    break;

  case 31:
#line 211 "src/main.y"
                                                        {
    (yyval.node) = new StmtNode((yyvsp[-2].node)->lineno,StmtNode::STMT_IF, {(yyvsp[-2].node), (yyvsp[0].node)});
}
#line 1807 "src/main.tab.cpp"
    break;

  case 32:
#line 217 "src/main.y"
                                                 {
    (yyval.node) = new StmtNode((yyvsp[-2].node)->lineno,StmtNode::STMT_WHILE, {(yyvsp[-2].node), (yyvsp[0].node)});
}
#line 1815 "src/main.tab.cpp"
    break;

  case 33:
#line 222 "src/main.y"
                                                                             {
    (yyval.node) = new StmtNode((yyvsp[-6].node)->lineno,StmtNode::STMT_FOR, {(yyvsp[-6].node), (yyvsp[-4].node), (yyvsp[-2].node), (yyvsp[0].node)});
}
#line 1823 "src/main.tab.cpp"
    break;

  case 34:
#line 225 "src/main.y"
                                                                                    {
    (yyval.node) = new StmtNode((yyvsp[-6].node)->lineno,StmtNode::STMT_FOR, {(yyvsp[-6].node), (yyvsp[-4].node), (yyvsp[-2].node), (yyvsp[0].node)});
}
#line 1831 "src/main.tab.cpp"
    break;

  case 35:
#line 231 "src/main.y"
             {(yyval.node) = (yyvsp[0].node);}
#line 1837 "src/main.tab.cpp"
    break;

  case 36:
#line 232 "src/main.y"
                         {
    (yyval.node) = new FuncCallNode((yyvsp[-3].node)->lineno, (yyvsp[-3].node)->symbol, {(yyvsp[-1].node)});
}
#line 1845 "src/main.tab.cpp"
    break;

  case 37:
#line 235 "src/main.y"
                        {
    (yyvsp[-2].node) -> addSibling((yyvsp[0].node));
    (yyval.node) = (yyvsp[-2].node);
}
#line 1854 "src/main.tab.cpp"
    break;

  case 38:
#line 239 "src/main.y"
        {
    (yyval.node) = new EmptyNode(lineno);
}
#line 1862 "src/main.tab.cpp"
    break;

  case 39:
#line 245 "src/main.y"
                                  {
    (yyval.node) = new OperatorNode((yyvsp[-2].node)->lineno, OperatorNode::OP_ASSIGN, {(yyvsp[0].node), (yyvsp[-2].node)});
}
#line 1870 "src/main.tab.cpp"
    break;

  case 40:
#line 248 "src/main.y"
                                  {
    (yyval.node) = new OperatorNode((yyvsp[-2].node)->lineno, OperatorNode::OP_ADDASS, {(yyvsp[0].node), (yyvsp[-2].node)});
}
#line 1878 "src/main.tab.cpp"
    break;

  case 41:
#line 251 "src/main.y"
                                  {
    (yyval.node) = new OperatorNode((yyvsp[-2].node)->lineno, OperatorNode::OP_SUBASS, {(yyvsp[0].node), (yyvsp[-2].node)});
}
#line 1886 "src/main.tab.cpp"
    break;

  case 42:
#line 254 "src/main.y"
                                   {
    (yyval.node) = new OperatorNode((yyvsp[-2].node)->lineno, OperatorNode::OP_MULTASS, {(yyvsp[0].node), (yyvsp[-2].node)});
}
#line 1894 "src/main.tab.cpp"
    break;

  case 43:
#line 257 "src/main.y"
                                  {
    (yyval.node) = new OperatorNode((yyvsp[-2].node)->lineno, OperatorNode::OP_DEVASS, {(yyvsp[0].node), (yyvsp[-2].node)});
}
#line 1902 "src/main.tab.cpp"
    break;

  case 44:
#line 260 "src/main.y"
                                  {
    (yyval.node) = new OperatorNode((yyvsp[-2].node)->lineno, OperatorNode::OP_MODASS, {(yyvsp[0].node), (yyvsp[-2].node)});
}
#line 1910 "src/main.tab.cpp"
    break;

  case 45:
#line 263 "src/main.y"
         { (yyval.node) = (yyvsp[0].node); }
#line 1916 "src/main.tab.cpp"
    break;

  case 46:
#line 266 "src/main.y"
                         {
    (yyval.node) = new OperatorNode((yyvsp[-2].node)->lineno, OperatorNode::OP_OR, {(yyvsp[-2].node), (yyvsp[0].node)});
}
#line 1924 "src/main.tab.cpp"
    break;

  case 47:
#line 269 "src/main.y"
           { (yyval.node) = (yyvsp[0].node);}
#line 1930 "src/main.tab.cpp"
    break;

  case 48:
#line 272 "src/main.y"
                           {
    (yyval.node) = new OperatorNode((yyvsp[-2].node)->lineno, OperatorNode::OP_AND, {(yyvsp[-2].node), (yyvsp[0].node)});
}
#line 1938 "src/main.tab.cpp"
    break;

  case 49:
#line 275 "src/main.y"
           { (yyval.node) = (yyvsp[0].node);}
#line 1944 "src/main.tab.cpp"
    break;

  case 50:
#line 278 "src/main.y"
                           {
    (yyval.node) = new OperatorNode((yyvsp[-2].node)->lineno, OperatorNode::OP_BOR, {(yyvsp[-2].node), (yyvsp[0].node)});
}
#line 1952 "src/main.tab.cpp"
    break;

  case 51:
#line 281 "src/main.y"
           { (yyval.node) = (yyvsp[0].node);}
#line 1958 "src/main.tab.cpp"
    break;

  case 52:
#line 284 "src/main.y"
                            {
    (yyval.node) = new OperatorNode((yyvsp[-2].node)->lineno, OperatorNode::OP_XOR, {(yyvsp[-2].node), (yyvsp[0].node)});
}
#line 1966 "src/main.tab.cpp"
    break;

  case 53:
#line 287 "src/main.y"
            { (yyval.node) = (yyvsp[0].node);}
#line 1972 "src/main.tab.cpp"
    break;

  case 54:
#line 290 "src/main.y"
                              {
    (yyval.node) = new OperatorNode((yyvsp[-2].node)->lineno, OperatorNode::OP_BAND, {(yyvsp[-2].node), (yyvsp[0].node)});
}
#line 1980 "src/main.tab.cpp"
    break;

  case 55:
#line 293 "src/main.y"
            { (yyval.node) = (yyvsp[0].node);}
#line 1986 "src/main.tab.cpp"
    break;

  case 56:
#line 296 "src/main.y"
                          {
    (yyval.node) = new OperatorNode((yyvsp[-2].node)->lineno, OperatorNode::OP_EQ, {(yyvsp[-2].node), (yyvsp[0].node)});
}
#line 1994 "src/main.tab.cpp"
    break;

  case 57:
#line 299 "src/main.y"
                           {
    (yyval.node) = new OperatorNode((yyvsp[-2].node)->lineno, OperatorNode::OP_NEQ, {(yyvsp[-2].node), (yyvsp[0].node)});
}
#line 2002 "src/main.tab.cpp"
    break;

  case 58:
#line 302 "src/main.y"
                           {
    (yyval.node) = new OperatorNode((yyvsp[-2].node)->lineno, OperatorNode::OP_LEQ, {(yyvsp[-2].node), (yyvsp[0].node)});
}
#line 2010 "src/main.tab.cpp"
    break;

  case 59:
#line 305 "src/main.y"
                           {
    (yyval.node) = new OperatorNode((yyvsp[-2].node)->lineno, OperatorNode::OP_SEQ, {(yyvsp[-2].node), (yyvsp[0].node)});
}
#line 2018 "src/main.tab.cpp"
    break;

  case 60:
#line 308 "src/main.y"
                         {
    (yyval.node) = new OperatorNode((yyvsp[-2].node)->lineno, OperatorNode::OP_L, {(yyvsp[-2].node), (yyvsp[0].node)});
}
#line 2026 "src/main.tab.cpp"
    break;

  case 61:
#line 311 "src/main.y"
                         {
    (yyval.node) = new OperatorNode((yyvsp[-2].node)->lineno, OperatorNode::OP_S, {(yyvsp[-2].node), (yyvsp[0].node)});
}
#line 2034 "src/main.tab.cpp"
    break;

  case 62:
#line 314 "src/main.y"
          { (yyval.node) = (yyvsp[0].node); }
#line 2040 "src/main.tab.cpp"
    break;

  case 63:
#line 317 "src/main.y"
                         {
    (yyval.node) = new OperatorNode((yyvsp[-2].node)->lineno, OperatorNode::OP_SHL, {(yyvsp[-2].node), (yyvsp[0].node)});
}
#line 2048 "src/main.tab.cpp"
    break;

  case 64:
#line 320 "src/main.y"
                         {
    (yyval.node) = new OperatorNode((yyvsp[-2].node)->lineno, OperatorNode::OP_SHR, {(yyvsp[-2].node), (yyvsp[0].node)});
}
#line 2056 "src/main.tab.cpp"
    break;

  case 65:
#line 323 "src/main.y"
          { (yyval.node) = (yyvsp[0].node) ;}
#line 2062 "src/main.tab.cpp"
    break;

  case 66:
#line 326 "src/main.y"
                      {
    (yyval.node) = new OperatorNode((yyvsp[-2].node)->lineno, OperatorNode::OP_ADD, {(yyvsp[-2].node), (yyvsp[0].node)});
}
#line 2070 "src/main.tab.cpp"
    break;

  case 67:
#line 329 "src/main.y"
                      {
    (yyval.node) = new OperatorNode((yyvsp[-2].node)->lineno, OperatorNode::OP_SUB, {(yyvsp[-2].node), (yyvsp[0].node)});
}
#line 2078 "src/main.tab.cpp"
    break;

  case 68:
#line 332 "src/main.y"
       {(yyval.node)=(yyvsp[0].node);}
#line 2084 "src/main.tab.cpp"
    break;

  case 69:
#line 335 "src/main.y"
                     {
    (yyval.node) = new OperatorNode((yyvsp[-2].node)->lineno, OperatorNode::OP_MULT, {(yyvsp[-2].node), (yyvsp[0].node)});
}
#line 2092 "src/main.tab.cpp"
    break;

  case 70:
#line 338 "src/main.y"
                     {
    (yyval.node) = new OperatorNode((yyvsp[-2].node)->lineno, OperatorNode::OP_DEV, {(yyvsp[-2].node), (yyvsp[0].node)});
}
#line 2100 "src/main.tab.cpp"
    break;

  case 71:
#line 341 "src/main.y"
                     {
    (yyval.node) = new OperatorNode((yyvsp[-2].node)->lineno, OperatorNode::OP_MOD, {(yyvsp[-2].node), (yyvsp[0].node)});
}
#line 2108 "src/main.tab.cpp"
    break;

  case 72:
#line 344 "src/main.y"
                {
    (yyval.node) = new OperatorNode((yyvsp[-1].node)->lineno, OperatorNode::OP_DADD, {(yyvsp[-1].node)});
}
#line 2116 "src/main.tab.cpp"
    break;

  case 73:
#line 347 "src/main.y"
                {
    (yyval.node) = new OperatorNode((yyvsp[-1].node)->lineno, OperatorNode::OP_DSUB, {(yyvsp[-1].node)});
}
#line 2124 "src/main.tab.cpp"
    break;

  case 74:
#line 350 "src/main.y"
                {
    (yyval.node) = new OperatorNode((yyvsp[0].node)->lineno, OperatorNode::OP_DADD, {(yyvsp[0].node)});
}
#line 2132 "src/main.tab.cpp"
    break;

  case 75:
#line 353 "src/main.y"
                {
    (yyval.node) = new OperatorNode((yyvsp[0].node)->lineno, OperatorNode::OP_DSUB, {(yyvsp[0].node)});
}
#line 2140 "src/main.tab.cpp"
    break;

  case 76:
#line 356 "src/main.y"
               {
    (yyval.node) = new OperatorNode((yyvsp[0].node)->lineno, OperatorNode::OP_TADDR, {(yyvsp[0].node)});
}
#line 2148 "src/main.tab.cpp"
    break;

  case 77:
#line 359 "src/main.y"
         {(yyval.node) = (yyvsp[0].node);}
#line 2154 "src/main.tab.cpp"
    break;

  case 78:
#line 362 "src/main.y"
                    {
    (yyval.node) = (yyvsp[-1].node);
}
#line 2162 "src/main.tab.cpp"
    break;

  case 79:
#line 365 "src/main.y"
             {
    auto symbol = scope->findSymbol(*(yyvsp[0].value));
    if (symbol == nullptr) {
      std::cerr << "Line " << lineno << ": symbol " << *(yyvsp[0].value) << " is not defined." << endl;
      exit(1);
      return -1;
    }
    (yyval.node) = new ExprNode(lineno, symbol);
}
#line 2176 "src/main.tab.cpp"
    break;

  case 80:
#line 374 "src/main.y"
                                    {
    auto symbol = scope->findSymbol(*(yyvsp[-3].value));
    if (symbol == nullptr) {
      std::cerr << "Line " << lineno << ": symbol " << *(yyvsp[-3].value) << " is not defined." << endl;
      exit(1);
      return -1;
    }
    (yyval.node) = new ExprNode (lineno, symbol);
    (yyval.node) -> addSibling ((yyvsp[-1].node));
}
#line 2191 "src/main.tab.cpp"
    break;

  case 81:
#line 384 "src/main.y"
              {
    (yyval.node) = new OperatorNode((yyvsp[0].node)->lineno, OperatorNode::OP_NOT, {(yyvsp[0].node)});
}
#line 2199 "src/main.tab.cpp"
    break;

  case 82:
#line 387 "src/main.y"
               {
    (yyval.node) = new OperatorNode((yyvsp[0].node)->lineno, OperatorNode::OP_BNOT, {(yyvsp[0].node)});
}
#line 2207 "src/main.tab.cpp"
    break;

  case 83:
#line 390 "src/main.y"
                         {
    (yyval.node) = new OperatorNode((yyvsp[0].node)->lineno, OperatorNode::OP_ADD, {(yyvsp[0].node)});
}
#line 2215 "src/main.tab.cpp"
    break;

  case 84:
#line 393 "src/main.y"
                           {
    (yyval.node) = new OperatorNode((yyvsp[0].node)->lineno, OperatorNode::OP_UMINUS, {(yyvsp[0].node)});
}
#line 2223 "src/main.tab.cpp"
    break;

  case 85:
#line 396 "src/main.y"
         {
    (yyval.node) = new ExprNode(lineno, (yyvsp[0].symbol));
}
#line 2231 "src/main.tab.cpp"
    break;

  case 86:
#line 402 "src/main.y"
        { currentType = Symbol::VALUE_INT; if(scope->getScopeStack().size()==1) currentFunType = currentType;}
#line 2237 "src/main.tab.cpp"
    break;

  case 87:
#line 403 "src/main.y"
         { currentType = Symbol::VALUE_CHAR; if(scope->getScopeStack().size()==1) currentFunType = currentType;}
#line 2243 "src/main.tab.cpp"
    break;

  case 88:
#line 404 "src/main.y"
         {currentType = Symbol::VALUE_BOOL; if(scope->getScopeStack().size()==1) currentFunType = currentType;}
#line 2249 "src/main.tab.cpp"
    break;

  case 89:
#line 405 "src/main.y"
         { currentType = Symbol::VALUE_VOID; if(scope->getScopeStack().size()==1) currentFunType = currentType; }
#line 2255 "src/main.tab.cpp"
    break;

  case 90:
#line 406 "src/main.y"
           { currentType = Symbol::VALUE_STRING; if(scope->getScopeStack().size()==1) currentFunType = currentType;}
#line 2261 "src/main.tab.cpp"
    break;

  case 91:
#line 407 "src/main.y"
           { currentType = Symbol::VALUE_DOUBLE; if(scope->getScopeStack().size()==1) currentFunType = currentType; }
#line 2267 "src/main.tab.cpp"
    break;


#line 2271 "src/main.tab.cpp"

      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */
  {
    const int yylhs = yyr1[yyn] - YYNTOKENS;
    const int yyi = yypgoto[yylhs] + *yyssp;
    yystate = (0 <= yyi && yyi <= YYLAST && yycheck[yyi] == *yyssp
               ? yytable[yyi]
               : yydefgoto[yylhs]);
  }

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = YY_CAST (char *, YYSTACK_ALLOC (YY_CAST (YYSIZE_T, yymsg_alloc)));
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:
  /* Pacify compilers when the user code never invokes YYERROR and the
     label yyerrorlab therefore never appears in user code.  */
  if (0)
    YYERROR;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYTERROR;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;


/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;


#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif


/*-----------------------------------------------------.
| yyreturn -- parsing is finished, return the result.  |
`-----------------------------------------------------*/
yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  yystos[+*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  return yyresult;
}
#line 410 "src/main.y"


int yyerror(char const* message)
{
  cout << message << " at line " << lineno << endl;
  return -1;
}
