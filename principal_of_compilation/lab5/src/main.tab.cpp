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
    #define YYSTYPE TreeNode *  
    TreeNode* root;
    extern int lineno;
    int yylex();
    int yyerror( char const * );

#line 79 "src/main.tab.cpp"

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
#define YYLAST   320

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  62
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  28
/* YYNRULES -- Number of rules.  */
#define YYNRULES  89
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  175

#define YYUNDEFTOK  2
#define YYMAXUTOK   316


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
      55,    56,    57,    58,    59,    60,    61
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_int16 yyrline[] =
{
       0,    39,    39,    42,    43,    47,    48,    49,    50,    51,
      52,    53,    54,    55,    56,    57,    58,    62,    66,    67,
      68,    69,    70,    71,    74,    82,    91,   101,   109,   118,
     119,   123,   131,   140,   149,   158,   170,   180,   187,   196,
     207,   214,   221,   228,   235,   242,   249,   252,   259,   262,
     269,   272,   279,   282,   289,   292,   299,   302,   303,   304,
     311,   318,   325,   332,   339,   346,   349,   356,   363,   366,
     373,   380,   383,   390,   397,   404,   410,   416,   419,   422,
     425,   428,   431,   437,   443,   448,   449,   450,   451,   452
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "TRUE", "FALSE", "T_CHAR", "T_INT",
  "T_STRING", "T_BOOL", "T_VOID", "IDAddr", "IDPtr", "K_IF", "K_ELSE",
  "K_WHILE", "K_FOR", "K_SKIP", "F_PRINTF", "F_SCANF", "LOP_ADD",
  "LOP_SUB", "LOP_MULT", "LOP_DEV", "LOP_MOD", "LOP_DADD", "LOP_DSUB",
  "LOP_ADDASS", "LOP_SUBASS", "LOP_MULTASS", "LOP_DEVASS", "LOP_MODASS",
  "LOP_AND", "LOP_OR", "LOP_NOT", "LOP_BNOT", "LOP_BOR", "LOP_BAND",
  "LOP_XOR", "LOP_EQ", "LOP_NEQ", "LOP_L", "LOP_LEQ", "LOP_S", "LOP_SEQ",
  "LOP_SHL", "LOP_SHR", "LOP_ASSIGN", "SEMICOLON", "LPAREN", "RPAREN",
  "LBRACE", "RBRACE", "IDENTIFIER", "INTEGER", "CHAR", "BOOL", "STRING",
  "COMMA", "LOP_MUL", "LOP_DIV", "UMINUS", "UADD", "$accept", "program",
  "statements", "statement", "expr_stmt", "call_args", "def_func",
  "call_func", "declaration", "IDLIST", "if_stmt", "while_stmt",
  "for_stmt", "assignment", "printf", "scanf", "expr", "or_expr",
  "and_expr", "bor_expr", "xor_expr", "band_expr", "comp_expr", "sh_expr",
  "as_expr", "term", "factor", "T", YY_NULLPTR
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
     315,   316
};
# endif

#define YYPACT_NINF (-128)

#define yypact_value_is_default(Yyn) \
  ((Yyn) == YYPACT_NINF)

#define YYTABLE_NINF (-1)

#define yytable_value_is_error(Yyn) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
     182,  -128,  -128,  -128,  -128,  -128,  -128,  -128,   -40,    18,
      24,    29,    33,   193,   193,  -128,    31,   182,    34,  -128,
    -128,  -128,    43,   182,  -128,    46,  -128,  -128,    50,  -128,
    -128,  -128,    57,    58,    70,   137,    86,    89,    87,   104,
     108,   117,    -3,    72,   183,  -128,    42,    31,    31,    15,
      91,    94,  -128,   183,   183,   224,   128,    31,    -1,  -128,
    -128,  -128,  -128,  -128,  -128,  -128,    31,    31,    31,    31,
      31,    31,    31,    31,    31,    31,    31,   193,   193,   193,
     193,   193,   193,   193,   193,   193,   193,   193,   193,   193,
    -128,  -128,    40,  -128,    73,   229,   234,   105,    80,   169,
     -32,   111,  -128,  -128,   137,  -128,  -128,  -128,   -17,   137,
     137,   137,   137,   137,   137,    89,    87,    87,   108,   117,
      -3,    -3,    -3,    -3,    -3,    -3,    72,    72,   183,   183,
    -128,  -128,  -128,    31,     1,    31,   182,   182,    31,    31,
     123,  -128,    -1,    -1,   182,     3,   137,   182,    -5,  -128,
     138,  -128,   268,   273,     5,    21,  -128,  -128,  -128,  -128,
    -128,   182,   182,    31,    31,  -128,  -128,  -128,  -128,   239,
     263,   182,   182,  -128,  -128
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_int8 yydefact[] =
{
       0,    57,    58,    86,    85,    89,    87,    88,     0,     0,
       0,     0,     0,     0,     0,     5,     0,     0,    79,    80,
      81,    84,     0,     2,     3,     0,    13,    14,     0,    10,
      11,    12,     0,     0,     0,    17,    46,    48,    50,    52,
      54,    56,    65,    68,    71,    77,     0,     0,     0,     0,
       0,     0,    79,    82,    83,     0,     0,     0,     0,     1,
       4,     9,     7,     8,    15,    16,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      75,    76,    79,    28,    30,     0,     0,     0,     0,     0,
       0,     0,    78,     6,    36,    19,    20,    18,     0,    41,
      42,    43,    44,    45,    40,    47,    49,    51,    53,    55,
      59,    60,    63,    61,    64,    62,    66,    67,    69,    70,
      72,    73,    74,     0,     0,     0,     0,     0,     0,     0,
      79,    38,     0,     0,     0,     0,    27,     0,     0,    29,
      32,    33,     0,     0,     0,     0,    26,    22,    23,    21,
      25,     0,     0,     0,     0,    37,    39,    24,    31,     0,
       0,     0,     0,    35,    34
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -128,  -128,   153,   -23,  -128,  -127,  -128,  -128,   122,    39,
    -128,  -128,  -128,  -128,  -128,  -128,   -10,  -128,   120,    38,
    -128,   102,   119,   -51,    32,   -12,   -84,   144
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int8 yydefgoto[] =
{
      -1,    22,    23,    24,    25,   108,    26,    27,    28,    93,
      29,    30,    31,    32,    33,    34,    35,    36,    37,    38,
      39,    40,    41,    42,    43,    44,    45,    46
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_uint8 yytable[] =
{
      60,    53,    54,   130,   131,   132,    55,   148,    47,   105,
     106,   105,   106,   157,   158,   154,   155,   141,     1,     2,
       3,     4,     5,     6,     7,   142,   120,   121,   122,   123,
     124,   125,   144,    60,     1,     2,    94,    95,    96,    98,
     145,    83,    84,    59,   161,     1,     2,   104,    13,    14,
     147,   107,   145,   107,   165,   159,   109,   110,   111,   112,
     113,   114,   145,    16,    13,    14,    48,    52,    19,    20,
     166,    21,    49,   128,   129,    13,    14,    50,   145,    16,
      57,    51,    58,    52,    19,    20,   133,    21,   134,    94,
      16,    85,    86,    61,    92,    19,    20,    62,    21,    66,
      67,    68,    69,    70,    63,    64,    66,    67,    68,    69,
      70,   116,   117,   150,   151,   126,   127,    65,    72,    71,
      73,   156,    74,   146,   160,    94,    71,   139,   152,   153,
     135,     1,     2,     3,     4,     5,     6,     7,   167,   168,
       8,    75,     9,    10,    76,    11,    12,   100,   173,   174,
     101,   162,   138,   169,   170,    77,    78,    79,    80,    81,
      82,    13,    14,    66,    67,    68,    69,    70,   143,   133,
      56,    97,     1,     2,   149,    15,    16,   118,    17,   103,
      18,    19,    20,    71,    21,     1,     2,     3,     4,     5,
       6,     7,   115,    99,     8,   119,     9,    10,     0,    11,
      12,     0,    13,    14,    87,    88,    89,    90,    91,     0,
       0,     0,     0,     0,     0,    13,    14,    16,     0,     0,
       0,   140,    19,    20,     0,    21,    13,    14,     0,    15,
      16,     0,    17,     0,    18,    19,    20,     0,    21,     0,
       0,    16,     0,     0,     0,    52,    19,    20,     0,    21,
      66,    67,    68,    69,    70,    66,    67,    68,    69,    70,
      66,    67,    68,    69,    70,    66,    67,    68,    69,    70,
      71,     0,     0,   102,     0,    71,     0,     0,   136,     0,
      71,     0,     0,   137,     0,    71,     0,     0,   171,    66,
      67,    68,    69,    70,    66,    67,    68,    69,    70,    66,
      67,    68,    69,    70,     0,     0,     0,     0,     0,    71,
       0,     0,   172,     0,    71,   163,     0,     0,     0,    71,
     164
};

static const yytype_int16 yycheck[] =
{
      23,    13,    14,    87,    88,    89,    16,   134,    48,    10,
      11,    10,    11,    10,    11,   142,   143,    49,     3,     4,
       5,     6,     7,     8,     9,    57,    77,    78,    79,    80,
      81,    82,    49,    56,     3,     4,    46,    47,    48,    49,
      57,    44,    45,     0,    49,     3,     4,    57,    33,    34,
      49,    52,    57,    52,    49,    52,    66,    67,    68,    69,
      70,    71,    57,    48,    33,    34,    48,    52,    53,    54,
      49,    56,    48,    85,    86,    33,    34,    48,    57,    48,
      46,    48,    48,    52,    53,    54,    46,    56,    48,    99,
      48,    19,    20,    47,    52,    53,    54,    47,    56,    26,
      27,    28,    29,    30,    47,    47,    26,    27,    28,    29,
      30,    73,    74,   136,   137,    83,    84,    47,    32,    46,
      31,   144,    35,   133,   147,   135,    46,    47,   138,   139,
      57,     3,     4,     5,     6,     7,     8,     9,   161,   162,
      12,    37,    14,    15,    36,    17,    18,    56,   171,   172,
      56,    13,    47,   163,   164,    38,    39,    40,    41,    42,
      43,    33,    34,    26,    27,    28,    29,    30,    57,    46,
      17,    49,     3,     4,   135,    47,    48,    75,    50,    51,
      52,    53,    54,    46,    56,     3,     4,     5,     6,     7,
       8,     9,    72,    49,    12,    76,    14,    15,    -1,    17,
      18,    -1,    33,    34,    21,    22,    23,    24,    25,    -1,
      -1,    -1,    -1,    -1,    -1,    33,    34,    48,    -1,    -1,
      -1,    52,    53,    54,    -1,    56,    33,    34,    -1,    47,
      48,    -1,    50,    -1,    52,    53,    54,    -1,    56,    -1,
      -1,    48,    -1,    -1,    -1,    52,    53,    54,    -1,    56,
      26,    27,    28,    29,    30,    26,    27,    28,    29,    30,
      26,    27,    28,    29,    30,    26,    27,    28,    29,    30,
      46,    -1,    -1,    49,    -1,    46,    -1,    -1,    49,    -1,
      46,    -1,    -1,    49,    -1,    46,    -1,    -1,    49,    26,
      27,    28,    29,    30,    26,    27,    28,    29,    30,    26,
      27,    28,    29,    30,    -1,    -1,    -1,    -1,    -1,    46,
      -1,    -1,    49,    -1,    46,    47,    -1,    -1,    -1,    46,
      47
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_int8 yystos[] =
{
       0,     3,     4,     5,     6,     7,     8,     9,    12,    14,
      15,    17,    18,    33,    34,    47,    48,    50,    52,    53,
      54,    56,    63,    64,    65,    66,    68,    69,    70,    72,
      73,    74,    75,    76,    77,    78,    79,    80,    81,    82,
      83,    84,    85,    86,    87,    88,    89,    48,    48,    48,
      48,    48,    52,    87,    87,    78,    64,    46,    48,     0,
      65,    47,    47,    47,    47,    47,    26,    27,    28,    29,
      30,    46,    32,    31,    35,    37,    36,    38,    39,    40,
      41,    42,    43,    44,    45,    19,    20,    21,    22,    23,
      24,    25,    52,    71,    78,    78,    78,    70,    78,    89,
      56,    56,    49,    51,    78,    10,    11,    52,    67,    78,
      78,    78,    78,    78,    78,    80,    81,    81,    83,    84,
      85,    85,    85,    85,    85,    85,    86,    86,    87,    87,
      88,    88,    88,    46,    48,    57,    49,    49,    47,    47,
      52,    49,    57,    57,    49,    57,    78,    49,    67,    71,
      65,    65,    78,    78,    67,    67,    65,    10,    11,    52,
      65,    49,    13,    47,    47,    49,    49,    65,    65,    78,
      78,    49,    49,    65,    65
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_int8 yyr1[] =
{
       0,    62,    63,    64,    64,    65,    65,    65,    65,    65,
      65,    65,    65,    65,    65,    65,    65,    66,    67,    67,
      67,    67,    67,    67,    68,    68,    69,    70,    70,    71,
      71,    72,    72,    73,    74,    74,    75,    76,    76,    77,
      78,    78,    78,    78,    78,    78,    78,    79,    79,    80,
      80,    81,    81,    82,    82,    83,    83,    84,    84,    84,
      84,    84,    84,    84,    84,    84,    85,    85,    85,    86,
      86,    86,    87,    87,    87,    87,    87,    87,    88,    88,
      88,    88,    88,    88,    88,    89,    89,    89,    89,    89
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_int8 yyr2[] =
{
       0,     2,     1,     1,     2,     1,     3,     2,     2,     2,
       1,     1,     1,     1,     1,     2,     2,     1,     1,     1,
       1,     3,     3,     3,     6,     5,     5,     4,     2,     3,
       1,     7,     5,     5,     9,     9,     3,     6,     4,     6,
       3,     3,     3,     3,     3,     3,     1,     3,     1,     3,
       1,     3,     1,     3,     1,     3,     1,     1,     1,     3,
       3,     3,     3,     3,     3,     1,     3,     3,     1,     3,
       3,     1,     3,     3,     3,     2,     2,     1,     3,     1,
       1,     1,     2,     2,     1,     1,     1,     1,     1,     1
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
#line 39 "src/main.y"
             {root = new TreeNode(0, NODE_PROG);yyval=root; yyval->addChild(yyvsp[0]);}
#line 1518 "src/main.tab.cpp"
    break;

  case 3:
#line 42 "src/main.y"
             {yyval=yyvsp[0];}
#line 1524 "src/main.tab.cpp"
    break;

  case 4:
#line 43 "src/main.y"
                        {yyval=yyvsp[-1]; yyval->addSibling(yyvsp[0]);}
#line 1530 "src/main.tab.cpp"
    break;

  case 5:
#line 47 "src/main.y"
             {yyval = new TreeNode(lineno, NODE_STMT); yyval->stype = STMT_SKIP;}
#line 1536 "src/main.tab.cpp"
    break;

  case 6:
#line 48 "src/main.y"
                           {yyval=yyvsp[-1];}
#line 1542 "src/main.tab.cpp"
    break;

  case 7:
#line 49 "src/main.y"
                        {yyval = yyvsp[-1];}
#line 1548 "src/main.tab.cpp"
    break;

  case 8:
#line 50 "src/main.y"
                       {yyval = yyvsp[-1];}
#line 1554 "src/main.tab.cpp"
    break;

  case 9:
#line 51 "src/main.y"
                      {yyval = yyvsp[-1];}
#line 1560 "src/main.tab.cpp"
    break;

  case 10:
#line 52 "src/main.y"
          {yyval = yyvsp[0];}
#line 1566 "src/main.tab.cpp"
    break;

  case 11:
#line 53 "src/main.y"
             {yyval = yyvsp[0];}
#line 1572 "src/main.tab.cpp"
    break;

  case 12:
#line 54 "src/main.y"
           {yyval = yyvsp[0];}
#line 1578 "src/main.tab.cpp"
    break;

  case 13:
#line 55 "src/main.y"
           {yyval=yyvsp[0];}
#line 1584 "src/main.tab.cpp"
    break;

  case 14:
#line 56 "src/main.y"
            {yyval=yyvsp[0];}
#line 1590 "src/main.tab.cpp"
    break;

  case 15:
#line 57 "src/main.y"
                   {yyval = yyvsp[-1];}
#line 1596 "src/main.tab.cpp"
    break;

  case 16:
#line 58 "src/main.y"
                  {yyval = yyvsp[-1];}
#line 1602 "src/main.tab.cpp"
    break;

  case 17:
#line 62 "src/main.y"
       {yyval = yyvsp[0];}
#line 1608 "src/main.tab.cpp"
    break;

  case 18:
#line 66 "src/main.y"
             {yyval=yyvsp[0];}
#line 1614 "src/main.tab.cpp"
    break;

  case 19:
#line 67 "src/main.y"
         {yyval=yyvsp[0];}
#line 1620 "src/main.tab.cpp"
    break;

  case 20:
#line 68 "src/main.y"
        {yyval=yyvsp[0];}
#line 1626 "src/main.tab.cpp"
    break;

  case 21:
#line 69 "src/main.y"
                             {yyval=yyvsp[-2]; yyval->addSibling(yyvsp[0]);}
#line 1632 "src/main.tab.cpp"
    break;

  case 22:
#line 70 "src/main.y"
                         {yyval=yyvsp[-2]; yyval->addSibling(yyvsp[0]);}
#line 1638 "src/main.tab.cpp"
    break;

  case 23:
#line 71 "src/main.y"
                        {yyval=yyvsp[-2]; yyval->addSibling(yyvsp[0]);}
#line 1644 "src/main.tab.cpp"
    break;

  case 24:
#line 74 "src/main.y"
                                                 {
    TreeNode *node=new TreeNode(yyvsp[-4]->lineno,NODE_FUNC);
    node->addChild(yyvsp[-5]);
    node->addChild(yyvsp[-4]);
    node->addChild(yyvsp[-2]);
    node->addChild(yyvsp[0]);
    yyval=node;
}
#line 1657 "src/main.tab.cpp"
    break;

  case 25:
#line 82 "src/main.y"
                                       {
    TreeNode *node=new TreeNode(yyvsp[-3]->lineno,NODE_FUNC);
    node->addChild(yyvsp[-4]);
    node->addChild(yyvsp[-3]);
    node->addChild(yyvsp[0]);
    yyval=node;
}
#line 1669 "src/main.tab.cpp"
    break;

  case 26:
#line 91 "src/main.y"
                                               {
    TreeNode *node=new TreeNode(yyvsp[-3]->lineno,NODE_FUNC);
    node->addChild(yyvsp[-4]);
    node->addChild(yyvsp[-2]);
    node->addChild(yyvsp[0]);
    yyval=node;
}
#line 1681 "src/main.tab.cpp"
    break;

  case 27:
#line 101 "src/main.y"
                              {  // declare and init
    TreeNode* node = new TreeNode(yyvsp[-3]->lineno, NODE_STMT);
    node->stype = STMT_DECL;
    node->addChild(yyvsp[-3]);
    node->addChild(yyvsp[-2]);
    node->addChild(yyvsp[0]);
    yyval = node;   
}
#line 1694 "src/main.tab.cpp"
    break;

  case 28:
#line 109 "src/main.y"
           {
    TreeNode* node = new TreeNode(yyvsp[-1]->lineno, NODE_STMT);
    node->stype = STMT_DECL;
    node->addChild(yyvsp[-1]);
    node->addChild(yyvsp[0]);
    yyval = node;   
}
#line 1706 "src/main.tab.cpp"
    break;

  case 29:
#line 118 "src/main.y"
                    {yyval=yyvsp[-2];yyval->addSibling(yyvsp[0]);}
#line 1712 "src/main.tab.cpp"
    break;

  case 31:
#line 123 "src/main.y"
                                                    {
    TreeNode *node = new TreeNode(yyvsp[-4]->lineno,NODE_STMT);
    node->stype = STMT_IF_ELSE;
    node->addChild(yyvsp[-4]);
    node->addChild(yyvsp[-2]);
    node->addChild(yyvsp[0]);
    yyval =node;
}
#line 1725 "src/main.tab.cpp"
    break;

  case 32:
#line 131 "src/main.y"
                                   {
    TreeNode *node = new TreeNode(yyvsp[-2]->lineno,NODE_STMT);
    node->stype = STMT_IF_ELSE;
    node->addChild(yyvsp[-2]);
    node->addChild(yyvsp[0]);
    yyval =node;
}
#line 1737 "src/main.tab.cpp"
    break;

  case 33:
#line 140 "src/main.y"
                                      {
    TreeNode *node = new TreeNode(yyvsp[-2]->lineno,NODE_STMT);
    node->stype = STMT_WHILE;
    node->addChild(yyvsp[-2]);
    node->addChild(yyvsp[0]);
    yyval =node;
}
#line 1749 "src/main.tab.cpp"
    break;

  case 34:
#line 149 "src/main.y"
                                                                  {
    TreeNode *node =new TreeNode(yyvsp[-6]->lineno,NODE_STMT);
    node->stype = STMT_FOR;
    node->addChild(yyvsp[-6]);
    node->addChild(yyvsp[-4]);
    node->addChild(yyvsp[-2]);
    node->addChild(yyvsp[0]);
    yyval = node;
}
#line 1763 "src/main.tab.cpp"
    break;

  case 35:
#line 158 "src/main.y"
                                                                         {
    TreeNode *node =new TreeNode(yyvsp[-6]->lineno,NODE_STMT);
    node->stype = STMT_FOR;
    node->addChild(yyvsp[-6]);
    node->addChild(yyvsp[-4]);
    node->addChild(yyvsp[-2]);
    node->addChild(yyvsp[0]);
    yyval = node;
}
#line 1777 "src/main.tab.cpp"
    break;

  case 36:
#line 170 "src/main.y"
                            {
    TreeNode *node = new TreeNode(yyvsp[0]->lineno, NODE_STMT);
    node->stype = STMT_ASSIGN;
    node->addChild(yyvsp[-2]);
    node->addChild(yyvsp[0]);
    yyval = node;
}
#line 1789 "src/main.tab.cpp"
    break;

  case 37:
#line 180 "src/main.y"
                                               {
    TreeNode *node = new TreeNode(yyvsp[-5]->lineno,NODE_STMT);
    node->stype = STMT_PRINTF;
    node->addChild(yyvsp[-3]);
    node->addChild(yyvsp[-1]);
    yyval=node;
}
#line 1801 "src/main.tab.cpp"
    break;

  case 38:
#line 187 "src/main.y"
                               {
    TreeNode *node = new TreeNode(yyvsp[-3]->lineno,NODE_STMT);
    node->stype = STMT_PRINTF;
    node->addChild(yyvsp[-1]);
    yyval=node;
}
#line 1812 "src/main.tab.cpp"
    break;

  case 39:
#line 196 "src/main.y"
                                              {
    TreeNode *node = new TreeNode(yyvsp[-5]->lineno,NODE_STMT);
    node->stype = STMT_SCANF;
    node->addChild(yyvsp[-3]);
    node->addChild(yyvsp[-1]);
    yyval=node;
}
#line 1824 "src/main.tab.cpp"
    break;

  case 40:
#line 207 "src/main.y"
                      {
    TreeNode * node = new TreeNode(yyvsp[-2]->lineno,NODE_EXPR);
    node->optype = OP_ASSIGN;
    node->addChild(yyvsp[-2]);
    node->addChild(yyvsp[0]);
    yyval=node;
}
#line 1836 "src/main.tab.cpp"
    break;

  case 41:
#line 214 "src/main.y"
                      {
    TreeNode * node = new TreeNode(yyvsp[-2]->lineno,NODE_EXPR);
    node->optype = OP_ADDASS;
    node->addChild(yyvsp[-2]);
    node->addChild(yyvsp[0]);
    yyval=node;
}
#line 1848 "src/main.tab.cpp"
    break;

  case 42:
#line 221 "src/main.y"
                      {
    TreeNode * node = new TreeNode(yyvsp[-2]->lineno,NODE_EXPR);
    node->optype = OP_SUBASS;
    node->addChild(yyvsp[-2]);
    node->addChild(yyvsp[0]);
    yyval=node;
}
#line 1860 "src/main.tab.cpp"
    break;

  case 43:
#line 228 "src/main.y"
                       {
    TreeNode * node = new TreeNode(yyvsp[-2]->lineno,NODE_EXPR);
    node->optype = OP_MULTASS;
    node->addChild(yyvsp[-2]);
    node->addChild(yyvsp[0]);
    yyval=node;
}
#line 1872 "src/main.tab.cpp"
    break;

  case 44:
#line 235 "src/main.y"
                      {
    TreeNode * node = new TreeNode(yyvsp[-2]->lineno,NODE_EXPR);
    node->optype = OP_DEVASS;
    node->addChild(yyvsp[-2]);
    node->addChild(yyvsp[0]);
    yyval=node;
}
#line 1884 "src/main.tab.cpp"
    break;

  case 45:
#line 242 "src/main.y"
                      {
    TreeNode * node = new TreeNode(yyvsp[-2]->lineno,NODE_EXPR);
    node->optype = OP_MODASS;
    node->addChild(yyvsp[-2]);
    node->addChild(yyvsp[0]);
    yyval=node;
}
#line 1896 "src/main.tab.cpp"
    break;

  case 46:
#line 249 "src/main.y"
         { yyval = yyvsp[0]; }
#line 1902 "src/main.tab.cpp"
    break;

  case 47:
#line 252 "src/main.y"
                         {
    TreeNode * node = new TreeNode(yyvsp[-2]->lineno,NODE_EXPR);
    node->optype = OP_OR;
    node->addChild(yyvsp[-2]);
    node->addChild(yyvsp[0]);
    yyval=node;
}
#line 1914 "src/main.tab.cpp"
    break;

  case 48:
#line 259 "src/main.y"
           { yyval = yyvsp[0];}
#line 1920 "src/main.tab.cpp"
    break;

  case 49:
#line 262 "src/main.y"
                           {
    TreeNode * node = new TreeNode(yyvsp[-2]->lineno,NODE_EXPR);
    node->optype = OP_AND;
    node->addChild(yyvsp[-2]);
    node->addChild(yyvsp[0]);
    yyval=node;
}
#line 1932 "src/main.tab.cpp"
    break;

  case 50:
#line 269 "src/main.y"
           { yyval = yyvsp[0];}
#line 1938 "src/main.tab.cpp"
    break;

  case 51:
#line 272 "src/main.y"
                           {
    TreeNode * node = new TreeNode(yyvsp[-2]->lineno,NODE_EXPR);
    node->optype = OP_BOR;
    node->addChild(yyvsp[-2]);
    node->addChild(yyvsp[0]);
    yyval=node;
}
#line 1950 "src/main.tab.cpp"
    break;

  case 52:
#line 279 "src/main.y"
           { yyval = yyvsp[0];}
#line 1956 "src/main.tab.cpp"
    break;

  case 53:
#line 282 "src/main.y"
                            {
    TreeNode * node = new TreeNode(yyvsp[-2]->lineno,NODE_EXPR);
    node->optype = OP_XOR;
    node->addChild(yyvsp[-2]);
    node->addChild(yyvsp[0]);
    yyval=node;
}
#line 1968 "src/main.tab.cpp"
    break;

  case 54:
#line 289 "src/main.y"
            { yyval = yyvsp[0];}
#line 1974 "src/main.tab.cpp"
    break;

  case 55:
#line 292 "src/main.y"
                              {
    TreeNode * node = new TreeNode(yyvsp[-2]->lineno,NODE_EXPR);
    node->optype = OP_BAND;
    node->addChild(yyvsp[-2]);
    node->addChild(yyvsp[0]);
    yyval=node;
}
#line 1986 "src/main.tab.cpp"
    break;

  case 56:
#line 299 "src/main.y"
            { yyval = yyvsp[0];}
#line 1992 "src/main.tab.cpp"
    break;

  case 57:
#line 302 "src/main.y"
       {yyval=yyvsp[0];}
#line 1998 "src/main.tab.cpp"
    break;

  case 58:
#line 303 "src/main.y"
        {yyval=yyvsp[0];}
#line 2004 "src/main.tab.cpp"
    break;

  case 59:
#line 304 "src/main.y"
                          {
    TreeNode * node = new TreeNode(yyvsp[-2]->lineno,NODE_EXPR);
    node->optype = OP_EQ;
    node->addChild(yyvsp[-2]);
    node->addChild(yyvsp[0]);
    yyval=node;
}
#line 2016 "src/main.tab.cpp"
    break;

  case 60:
#line 311 "src/main.y"
                           {
    TreeNode * node = new TreeNode(yyvsp[-2]->lineno,NODE_EXPR);
    node->optype = OP_NEQ;
    node->addChild(yyvsp[-2]);
    node->addChild(yyvsp[0]);
    yyval=node;
}
#line 2028 "src/main.tab.cpp"
    break;

  case 61:
#line 318 "src/main.y"
                           {
    TreeNode * node = new TreeNode(yyvsp[-2]->lineno,NODE_EXPR);
    node->optype = OP_LEQ;
    node->addChild(yyvsp[-2]);
    node->addChild(yyvsp[0]);
    yyval=node;
}
#line 2040 "src/main.tab.cpp"
    break;

  case 62:
#line 325 "src/main.y"
                           {
    TreeNode * node = new TreeNode(yyvsp[-2]->lineno,NODE_EXPR);
    node->optype = OP_SEQ;
    node->addChild(yyvsp[-2]);
    node->addChild(yyvsp[0]);
    yyval=node;
}
#line 2052 "src/main.tab.cpp"
    break;

  case 63:
#line 332 "src/main.y"
                         {
    TreeNode * node = new TreeNode(yyvsp[-2]->lineno,NODE_EXPR);
    node->optype = OP_L;
    node->addChild(yyvsp[-2]);
    node->addChild(yyvsp[0]);
    yyval=node;
}
#line 2064 "src/main.tab.cpp"
    break;

  case 64:
#line 339 "src/main.y"
                         {
    TreeNode * node = new TreeNode(yyvsp[-2]->lineno,NODE_EXPR);
    node->optype = OP_S;
    node->addChild(yyvsp[-2]);
    node->addChild(yyvsp[0]);
    yyval=node;
}
#line 2076 "src/main.tab.cpp"
    break;

  case 65:
#line 346 "src/main.y"
          { yyval = yyvsp[0]; }
#line 2082 "src/main.tab.cpp"
    break;

  case 66:
#line 349 "src/main.y"
                         {
    TreeNode * node = new TreeNode(yyvsp[-2]->lineno,NODE_EXPR);
    node->optype = OP_SHL;
    node->addChild(yyvsp[-2]);
    node->addChild(yyvsp[0]);
    yyval=node;
}
#line 2094 "src/main.tab.cpp"
    break;

  case 67:
#line 356 "src/main.y"
                         {
    TreeNode * node = new TreeNode(yyvsp[-2]->lineno,NODE_EXPR);
    node->optype = OP_SHR;
    node->addChild(yyvsp[-2]);
    node->addChild(yyvsp[0]);
    yyval=node;
}
#line 2106 "src/main.tab.cpp"
    break;

  case 68:
#line 363 "src/main.y"
          { yyval = yyvsp[0] ;}
#line 2112 "src/main.tab.cpp"
    break;

  case 69:
#line 366 "src/main.y"
                      {
    TreeNode * node = new TreeNode(yyvsp[-2]->lineno,NODE_EXPR);
    node->optype = OP_ADD;
    node->addChild(yyvsp[-2]);
    node->addChild(yyvsp[0]);
    yyval=node;
}
#line 2124 "src/main.tab.cpp"
    break;

  case 70:
#line 373 "src/main.y"
                      {
    TreeNode * node = new TreeNode(yyvsp[-2]->lineno,NODE_EXPR);
    node->optype = OP_SUB;
    node->addChild(yyvsp[-2]);
    node->addChild(yyvsp[0]);
    yyval=node;
}
#line 2136 "src/main.tab.cpp"
    break;

  case 71:
#line 380 "src/main.y"
       {yyval=yyvsp[0];}
#line 2142 "src/main.tab.cpp"
    break;

  case 72:
#line 383 "src/main.y"
                     {
    TreeNode * node = new TreeNode(yyvsp[-2]->lineno,NODE_EXPR);
    node->optype = OP_MULT;
    node->addChild(yyvsp[-2]);
    node->addChild(yyvsp[0]);
    yyval=node;
}
#line 2154 "src/main.tab.cpp"
    break;

  case 73:
#line 390 "src/main.y"
                     {
    TreeNode * node = new TreeNode(yyvsp[-2]->lineno,NODE_EXPR);
    node->optype = OP_DEV;
    node->addChild(yyvsp[-2]);
    node->addChild(yyvsp[0]);
    yyval=node;
}
#line 2166 "src/main.tab.cpp"
    break;

  case 74:
#line 397 "src/main.y"
                     {
    TreeNode * node = new TreeNode(yyvsp[-2]->lineno,NODE_EXPR);
    node->optype = OP_MOD;
    node->addChild(yyvsp[-2]);
    node->addChild(yyvsp[0]);
    yyval=node;
}
#line 2178 "src/main.tab.cpp"
    break;

  case 75:
#line 404 "src/main.y"
                {
    TreeNode * node = new TreeNode(yyvsp[-1]->lineno,NODE_EXPR);
    node->optype = OP_DADD;
    node->addChild(yyvsp[-1]);
    yyval=node;
}
#line 2189 "src/main.tab.cpp"
    break;

  case 76:
#line 410 "src/main.y"
                {
    TreeNode * node = new TreeNode(yyvsp[-1]->lineno,NODE_EXPR);
    node->optype = OP_DSUB;
    node->addChild(yyvsp[-1]);
    yyval=node;
}
#line 2200 "src/main.tab.cpp"
    break;

  case 77:
#line 416 "src/main.y"
         {yyval = yyvsp[0];}
#line 2206 "src/main.tab.cpp"
    break;

  case 78:
#line 419 "src/main.y"
                    {
    yyval = yyvsp[-1];
}
#line 2214 "src/main.tab.cpp"
    break;

  case 79:
#line 422 "src/main.y"
             {
    yyval = yyvsp[0];
}
#line 2222 "src/main.tab.cpp"
    break;

  case 80:
#line 425 "src/main.y"
          {
    yyval = yyvsp[0];
}
#line 2230 "src/main.tab.cpp"
    break;

  case 81:
#line 428 "src/main.y"
       {
    yyval = yyvsp[0];
}
#line 2238 "src/main.tab.cpp"
    break;

  case 82:
#line 431 "src/main.y"
              {
    TreeNode *node = new TreeNode(yyvsp[0]->lineno,NODE_EXPR);
    node->optype = OP_NOT;
    node->addChild(yyvsp[0]);
    yyval = node;
}
#line 2249 "src/main.tab.cpp"
    break;

  case 83:
#line 437 "src/main.y"
               {
    TreeNode *node = new TreeNode(yyvsp[0]->lineno,NODE_EXPR);
    node->optype = OP_BNOT;
    node->addChild(yyvsp[0]);
    yyval = node;
}
#line 2260 "src/main.tab.cpp"
    break;

  case 84:
#line 443 "src/main.y"
         {
    yyval = yyvsp[0];
}
#line 2268 "src/main.tab.cpp"
    break;

  case 85:
#line 448 "src/main.y"
         {yyval = new TreeNode(lineno, NODE_TYPE); yyval->type = TYPE_INT;}
#line 2274 "src/main.tab.cpp"
    break;

  case 86:
#line 449 "src/main.y"
         {yyval = new TreeNode(lineno, NODE_TYPE); yyval->type = TYPE_CHAR;}
#line 2280 "src/main.tab.cpp"
    break;

  case 87:
#line 450 "src/main.y"
         {yyval = new TreeNode(lineno, NODE_TYPE); yyval->type = TYPE_BOOL;}
#line 2286 "src/main.tab.cpp"
    break;

  case 88:
#line 451 "src/main.y"
         {yyval = new TreeNode(lineno, NODE_TYPE); yyval->type = FUNC_VOID;}
#line 2292 "src/main.tab.cpp"
    break;

  case 89:
#line 452 "src/main.y"
           {yyval = new TreeNode(lineno, NODE_TYPE); yyval->type = TYPE_STRING;}
#line 2298 "src/main.tab.cpp"
    break;


#line 2302 "src/main.tab.cpp"

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
#line 455 "src/main.y"


int yyerror(char const* message)
{
  cout << message << " at line " << lineno << endl;
  return -1;
}
