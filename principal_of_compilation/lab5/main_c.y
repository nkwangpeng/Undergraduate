%{
    #include "common.h"
    #define YYSTYPE TreeNode *  
    TreeNode* root;
    extern int lineno;
    int yylex();
    int yyerror( char const * );
%}
%token TRUE FALSE

%token T_CHAR T_INT T_STRING T_BOOL

%token K_IF K_ELSE K_WHILE K_FOR K_SKIP F_PRINTF F_SCANF

%token LOP_ADD LOP_SUB LOP_MULT LOP_DEV LOP_AND LOP_OR LOP_NOT LOP_EQ LOP_NEQ LOP_L LOP_LEQ LOP_S LOP_SEQ LOP_ASSIGN

%token SEMICOLON

%token LPAREN RPAREN LBRACE RBRACE

%token IDENTIFIER INTEGER CHAR BOOL STRING

%left COMMA
%right LOP_NOT
%left LOP_MUL LOP_DIV
%left LOP_ADD LOP_SUB
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
| declaration SEMICOLON {$$ = $1;}
| assignment SEMICOLON {$$ = $1;}
| expr_stmt SEMICOLON {$$ = $1;}
| if_stmt {$$ = $1;}
| printf SEMICOLON {$$ = $1;}
| scanf SEMICOLON {$$ = $1;}
;

expr_stmt
: expr {$$ = $1;}
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
| T IDENTIFIER {
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    node->stype = STMT_DECL;
    node->addChild($1);
    node->addChild($2);
    $$ = node;   
}
;

if_stmt
: K_IF LPAREN bool_expr RPAREN statement K_ELSE statement{
    TreeNode *node = new TreeNode($3->lineno,NODE_STMT);
    node->stype = STMT_IF_ELSE;
    node->addChild($3);
    node->addChild($5);
    node->addChild($7);
    $$ =node;
}
| K_IF LPAREN bool_expr RPAREN statement{
    TreeNode *node = new TreeNode($3->lineno,NODE_STMT);
    node->stype = STMT_IF_ELSE;
    node->addChild($3);
    node->addChild($5);
    $$ =node;
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
: F_PRINTF LPAREN expr LPAREN{
    TreeNode *node = new TreeNode($3->lineno,NODE_STMT);
    node->stype = STMT_PRINTF;
    node->addChild($3);
    $$=node;
}
;

scanf
: F_SCANF LPAREN expr LPAREN{
    TreeNode *node = new TreeNode($3->lineno,NODE_STMT);
    node->stype = STMT_PRINTF;
    node->addChild($3);
    $$=node;
}
;

bool_expr
: 

expr
: IDENTIFIER {
    $$ = $1;
}
| INTEGER {
    $$ = $1;
}
| CHAR {
    $$ = $1;
}
| STRING {
    $$ = $1;
}
| expr LOP_ADD expr {
    TreeNode * node = new TreeNode($1->lineno,NODE_EXPR);
    node->optype = OP_ADD;
    node->addChild($1);
    node->addChild($3);
}
| expr LOP_SUB expr {
    TreeNode * node = new TreeNode($1->lineno,NODE_EXPR);
    node->optype = OP_SUB;
    node->addChild($1);
    node->addChild($3);
}
| expr LOP_MULT expr {
    TreeNode * node = new TreeNode($1->lineno,NODE_EXPR);
    node->optype = OP_MULT;
    node->addChild($1);
    node->addChild($3);
}
| expr LOP_DEV expr {
    TreeNode * node = new TreeNode($1->lineno,NODE_EXPR);
    node->optype = OP_DEV;
    node->addChild($1);
    node->addChild($3);
}
;

T: T_INT {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_INT;} 
| T_CHAR {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_CHAR;}
| T_BOOL {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_BOOL;}
;

%%

int yyerror(char const* message)
{
  cout << message << " at line " << lineno << endl;
  return -1;
}