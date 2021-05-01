%{
    #include "common.h"
    #define YYSTYPE TreeNode *  
    TreeNode* root;
    extern int lineno;
    int yylex();
    int yyerror( char const * );
%}
%token TRUE FALSE

%token T_CHAR T_INT T_STRING T_BOOL T_VOID IDAddr IDPtr

%token K_IF K_ELSE K_WHILE K_FOR K_SKIP F_PRINTF F_SCANF

%token LOP_ADD LOP_SUB LOP_MULT LOP_DEV LOP_MOD LOP_DADD LOP_DSUB LOP_ADDASS LOP_SUBASS LOP_MULTASS LOP_DEVASS LOP_MODASS 
%token LOP_AND LOP_OR LOP_NOT LOP_BNOT LOP_BOR LOP_BAND LOP_XOR 
%token LOP_EQ LOP_NEQ LOP_L LOP_LEQ LOP_S LOP_SEQ LOP_SHL LOP_SHR LOP_ASSIGN

%token SEMICOLON

%token LPAREN RPAREN LBRACE RBRACE

%token IDENTIFIER INTEGER CHAR BOOL STRING

%left COMMA
%right LOP_NOT
%left LOP_MUL LOP_DIV
%left LOP_ADD LOP_SUB
%left LOP_DADD LOP_DSUB
%left LOP_SEQ LOP_S LOP_LEQ LOP_L LOP_EQ LOP_NEQ
%left LOP_AND LOP_OR
%right LOP_ASSIGN
%right UMINUS UADD
%right K_ELSE

%%

program
: statements {root = new TreeNode(0, NODE_PROG);$$=root; $$->addChild($1);};

statements
:  statement {$$=$1;}
|  statements statement {$$=$1; $$->addSibling($2);}
;

statement
: SEMICOLON  {$$ = new TreeNode(lineno, NODE_STMT); $$->stype = STMT_SKIP;}
| LBRACE statements RBRACE {$$=$2;}
| declaration SEMICOLON {$$ = $1;}
| assignment SEMICOLON {$$ = $1;}
| expr_stmt SEMICOLON {$$ = $1;}
| if_stmt {$$ = $1;}
| while_stmt {$$ = $1;}
| for_stmt {$$ = $1;}
| def_func {$$=$1;}
| call_func {$$=$1;}
| printf SEMICOLON {$$ = $1;}
| scanf SEMICOLON {$$ = $1;}
;

expr_stmt
: expr {$$ = $1;}
;

call_args
: IDENTIFIER {$$=$1;}
| IDAddr {$$=$1;}
| IDPtr {$$=$1;}
| call_args COMMA IDENTIFIER {$$=$1; $$->addSibling($3);}
| call_args COMMA IDAddr {$$=$1; $$->addSibling($3);}
| call_args COMMA IDPtr {$$=$1; $$->addSibling($3);}
;
def_func
: T IDENTIFIER LPAREN call_args RPAREN statement {
    TreeNode *node=new TreeNode($2->lineno,NODE_FUNC);
    node->addChild($1);
    node->addChild($2);
    node->addChild($4);
    node->addChild($6);
    $$=node;
}
| T IDENTIFIER LPAREN RPAREN statement {
    TreeNode *node=new TreeNode($2->lineno,NODE_FUNC);
    node->addChild($1);
    node->addChild($2);
    node->addChild($5);
    $$=node;
}
;
call_func
: IDENTIFIER LPAREN call_args RPAREN statement {
    TreeNode *node=new TreeNode($2->lineno,NODE_FUNC);
    node->addChild($1);
    node->addChild($3);
    node->addChild($5);
    $$=node;
}
;

declaration
: T IDENTIFIER LOP_ASSIGN expr{  // declare and init
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    node->stype = STMT_DECL;
    node->addChild($1);
    node->addChild($2);
    node->addChild($4);
    $$ = node;   
} 
| T IDLIST {
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    node->stype = STMT_DECL;
    node->addChild($1);
    node->addChild($2);
    $$ = node;   
}
;
IDLIST
: expr COMMA IDLIST {$$=$1;$$->addSibling($3);}
| expr
;

if_stmt
: K_IF LPAREN expr RPAREN statement K_ELSE statement{
    TreeNode *node = new TreeNode($3->lineno,NODE_STMT);
    node->stype = STMT_IF_ELSE;
    node->addChild($3);
    node->addChild($5);
    node->addChild($7);
    $$ =node;
}
| K_IF LPAREN expr RPAREN statement{
    TreeNode *node = new TreeNode($3->lineno,NODE_STMT);
    node->stype = STMT_IF_ELSE;
    node->addChild($3);
    node->addChild($5);
    $$ =node;
}
;
while_stmt
: K_WHILE LPAREN expr RPAREN statement{
    TreeNode *node = new TreeNode($3->lineno,NODE_STMT);
    node->stype = STMT_WHILE;
    node->addChild($3);
    node->addChild($5);
    $$ =node;
}
;
for_stmt
: K_FOR LPAREN expr SEMICOLON expr SEMICOLON expr RPAREN statement{
    TreeNode *node =new TreeNode($3->lineno,NODE_STMT);
    node->stype = STMT_FOR;
    node->addChild($3);
    node->addChild($5);
    node->addChild($7);
    node->addChild($9);
    $$ = node;
}
| K_FOR LPAREN declaration SEMICOLON expr SEMICOLON expr RPAREN statement{
    TreeNode *node =new TreeNode($3->lineno,NODE_STMT);
    node->stype = STMT_FOR;
    node->addChild($3);
    node->addChild($5);
    node->addChild($7);
    node->addChild($9);
    $$ = node;
}
;

assignment
: IDENTIFIER LOP_ASSIGN expr{
    TreeNode *node = new TreeNode($3->lineno, NODE_STMT);
    node->stype = STMT_ASSIGN;
    node->addChild($1);
    node->addChild($3);
    $$ = node;
}
;

printf
: F_PRINTF LPAREN STRING COMMA call_args RPAREN{
    TreeNode *node = new TreeNode($1->lineno,NODE_STMT);
    node->stype = STMT_PRINTF;
    node->addChild($3);
    node->addChild($5);
    $$=node;
}
| F_PRINTF LPAREN STRING RPAREN{
    TreeNode *node = new TreeNode($1->lineno,NODE_STMT);
    node->stype = STMT_PRINTF;
    node->addChild($3);
    $$=node;
}
;

scanf
: F_SCANF LPAREN STRING COMMA call_args RPAREN{
    TreeNode *node = new TreeNode($1->lineno,NODE_STMT);
    node->stype = STMT_SCANF;
    node->addChild($3);
    node->addChild($5);
    $$=node;
}
;


expr
: expr LOP_ASSIGN expr{
    TreeNode * node = new TreeNode($1->lineno,NODE_EXPR);
    node->optype = OP_ASSIGN;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| expr LOP_ADDASS expr{
    TreeNode * node = new TreeNode($1->lineno,NODE_EXPR);
    node->optype = OP_ADDASS;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| expr LOP_SUBASS expr{
    TreeNode * node = new TreeNode($1->lineno,NODE_EXPR);
    node->optype = OP_SUBASS;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| expr LOP_MULTASS expr{
    TreeNode * node = new TreeNode($1->lineno,NODE_EXPR);
    node->optype = OP_MULTASS;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| expr LOP_DEVASS expr{
    TreeNode * node = new TreeNode($1->lineno,NODE_EXPR);
    node->optype = OP_DEVASS;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| expr LOP_MODASS expr{
    TreeNode * node = new TreeNode($1->lineno,NODE_EXPR);
    node->optype = OP_MODASS;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| or_expr{ $$ = $1; }
;
or_expr
: or_expr LOP_OR and_expr{
    TreeNode * node = new TreeNode($1->lineno,NODE_EXPR);
    node->optype = OP_OR;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| and_expr { $$ = $1;}
;
and_expr
: and_expr LOP_AND bor_expr{
    TreeNode * node = new TreeNode($1->lineno,NODE_EXPR);
    node->optype = OP_AND;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| bor_expr { $$ = $1;}
;
bor_expr
: bor_expr LOP_BOR bor_expr{
    TreeNode * node = new TreeNode($1->lineno,NODE_EXPR);
    node->optype = OP_BOR;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| xor_expr { $$ = $1;}
;
xor_expr
: xor_expr LOP_XOR band_expr{
    TreeNode * node = new TreeNode($1->lineno,NODE_EXPR);
    node->optype = OP_XOR;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| band_expr { $$ = $1;}
;
band_expr
: band_expr LOP_BAND comp_expr{
    TreeNode * node = new TreeNode($1->lineno,NODE_EXPR);
    node->optype = OP_BAND;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| comp_expr { $$ = $1;}
;
comp_expr
: TRUE {$$=$1;}
| FALSE {$$=$1;}
| comp_expr LOP_EQ sh_expr{
    TreeNode * node = new TreeNode($1->lineno,NODE_EXPR);
    node->optype = OP_EQ;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| comp_expr LOP_NEQ sh_expr{
    TreeNode * node = new TreeNode($1->lineno,NODE_EXPR);
    node->optype = OP_NEQ;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| comp_expr LOP_LEQ sh_expr{
    TreeNode * node = new TreeNode($1->lineno,NODE_EXPR);
    node->optype = OP_LEQ;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}   
| comp_expr LOP_SEQ sh_expr{
    TreeNode * node = new TreeNode($1->lineno,NODE_EXPR);
    node->optype = OP_SEQ;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}   
| comp_expr LOP_L sh_expr{
    TreeNode * node = new TreeNode($1->lineno,NODE_EXPR);
    node->optype = OP_L;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| comp_expr LOP_S sh_expr{
    TreeNode * node = new TreeNode($1->lineno,NODE_EXPR);
    node->optype = OP_S;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| sh_expr { $$ = $1; }   
;
sh_expr
: sh_expr LOP_SHL as_expr{
    TreeNode * node = new TreeNode($1->lineno,NODE_EXPR);
    node->optype = OP_SHL;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| sh_expr LOP_SHR as_expr{
    TreeNode * node = new TreeNode($1->lineno,NODE_EXPR);
    node->optype = OP_SHR;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| as_expr { $$ = $1 ;}
;
as_expr
: as_expr LOP_ADD term{
    TreeNode * node = new TreeNode($1->lineno,NODE_EXPR);
    node->optype = OP_ADD;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| as_expr LOP_SUB term{
    TreeNode * node = new TreeNode($1->lineno,NODE_EXPR);
    node->optype = OP_SUB;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| term {$$=$1;}
;
term      
:term LOP_MULT factor{
    TreeNode * node = new TreeNode($1->lineno,NODE_EXPR);
    node->optype = OP_MULT;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| term LOP_DEV factor{
    TreeNode * node = new TreeNode($1->lineno,NODE_EXPR);
    node->optype = OP_DEV;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| term LOP_MOD factor{
    TreeNode * node = new TreeNode($1->lineno,NODE_EXPR);
    node->optype = OP_MOD;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| term LOP_DADD {
    TreeNode * node = new TreeNode($1->lineno,NODE_EXPR);
    node->optype = OP_DADD;
    node->addChild($1);
    $$=node;
}
| term LOP_DSUB {
    TreeNode * node = new TreeNode($1->lineno,NODE_EXPR);
    node->optype = OP_DSUB;
    node->addChild($1);
    $$=node;
}
| factor {$$ = $1;}
;
factor
: LPAREN expr RPAREN{
    $$ = $2;
}
| IDENTIFIER {
    $$ = $1;
}
| INTEGER {
    $$ = $1;
}
| CHAR {
    $$ = $1;
}
| LOP_NOT term{
    TreeNode *node = new TreeNode($2->lineno,NODE_EXPR);
    node->optype = OP_NOT;
    node->addChild($2);
    $$ = node;
}
| LOP_BNOT term{
    TreeNode *node = new TreeNode($2->lineno,NODE_EXPR);
    node->optype = OP_BNOT;
    node->addChild($2);
    $$ = node;
}
| STRING {
    $$ = $1;
}
;

T: T_INT {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_INT;} 
| T_CHAR {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_CHAR;}
| T_BOOL {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_BOOL;}
| T_VOID {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = FUNC_VOID;}
| T_STRING {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_STRING;}
;

%%

int yyerror(char const* message)
{
  cout << message << " at line " << lineno << endl;
  return -1;
}