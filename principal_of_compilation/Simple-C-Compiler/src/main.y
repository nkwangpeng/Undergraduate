%{
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
%}
%union {
  string *value;
  Symbol *symbol;
  TreeNode *node;
}

%token T_CHAR T_INT T_STRING T_BOOL T_VOID T_DOUBLE T_ARRAY

%token K_IF K_ELSE K_WHILE K_FOR K_SKIP K_BREAK K_CASE K_CONTINUE K_DEFAULT K_RET K_SWITCH

%token LOP_DADD LOP_DSUB

%token LOP_ADD LOP_SUB LOP_MULT LOP_DEV LOP_MOD

%token LOP_NOT LOP_BNOT

%token LOP_AND LOP_OR LOP_BOR LOP_BAND LOP_XOR 

%token QM COLON

%token LOP_EQ LOP_NEQ LOP_L LOP_LEQ LOP_S LOP_SEQ 

%token LOP_SHL LOP_SHR

%token LOP_ADDASS LOP_SUBASS LOP_MULTASS LOP_DEVASS LOP_MODASS LOP_ASSIGN

%token SEMICOLON

%token LPAREN RPAREN LBRACE RBRACE LBRACKET RBRACKET

%token <symbol> SYMBOL
%token <value> IDENTIFIER

%right COMMA
%right LOP_NOT LOP_BNOT
%left LOP_SHL LOP_SHR
%left LOP_MUL LOP_DIV LOP_MOD
%left LOP_ADD LOP_SUB
%left LOP_SEQ LOP_S LOP_LEQ LOP_L LOP_EQ LOP_NEQ
%left LOP_AND LOP_OR
%right LOP_ADDASS LOP_SUBASS LOP_MULTASS LOP_DEVASS LOP_MODASS LOP_ASSIGN
%nonassoc IFX
%right UMINUS UADD
%right K_ELSE

%type <node> declaration IDLIST assignment ID_ASS call_args args
%type <node> and_expr as_expr band_expr bor_expr comp_expr or_expr sh_expr xor_expr term factor bool_expression
%type <node> expr if_stmt if_else_stmt for_stmt while_stmt return_stmt def_func
%type <node> statement program program_empty 


%%

start 
: program {
    root = $1;
}
;
program 
: program statement {
    ($1) -> addSibling($2);
    $$ = $1;
}
| statement {
    $$ = $1;
}
;

program_empty 
: program {
    $$ = $1;
}
| %empty {
    $$ = new EmptyNode(lineno);
  }
;

LB_SCOPE
: LBRACE {
    scope->pushScope();
}
;

bool_expression 
: expr {$$ = new OperatorNode(lineno,OperatorNode::OP_BOOL,{$1});
}
;

statement
: declaration SEMICOLON {$$ = $1;}
| expr SEMICOLON {$$ = $1;}
| LB_SCOPE program RBRACE {
    $$ = new StmtNode($2->lineno,StmtNode::STMT_SCOPE);
    $$ -> addChild($2);
    scope_out->pushScope(scope->popScope());
}
| return_stmt {$$ = $1;}
| if_stmt {$$ = $1;}
| if_else_stmt {$$ = $1;}
| while_stmt {$$ = $1;}
| for_stmt {$$ = $1;}
| def_func {$$=$1;}
;

call_args
: args {$$ = $1;}
| call_args COMMA args {$$=$1;$$->addSibling($3);}

args
: IDENTIFIER {
    auto symbol = scope->findSymbol(*$1);
    if (symbol == nullptr) {
      std::cerr << "Line " << lineno << ": symbol " << *$1 << " is not defined." << endl;
      exit(1);
      return -1;
    }
    $$ = new ExprNode(lineno, symbol);
}
;

def_func
: T IDENTIFIER LPAREN call_args RPAREN LB_SCOPE program_empty RBRACE {
    Callable* symbol = new Callable(currentFunType, *$2);
    scope->insertSymbol(*$2, $7->lineno, symbol);
    currFunc = symbol;
    $$ = new FunStmtNode($7->lineno, symbol, {$7});
    scope_out->pushScope(scope->getScopeStack().front());
}
| T IDENTIFIER LPAREN RPAREN LB_SCOPE program_empty RBRACE {
    Callable* symbol = new Callable(currentFunType, *$2);
    scope->insertSymbol(*$2, $6->lineno, symbol);
    currFunc = symbol;
    $$ = new FunStmtNode($6->lineno, symbol, {$6});
    scope_out->pushScope(scope->getScopeStack().front());
}
;

return_stmt
:  K_RET expr SEMICOLON {
    $$ = new StmtNode($2->lineno,StmtNode::STMT_RETURN, {$2});
}
;

declaration
: T IDLIST {
    $$ = $2;
}
;

IDLIST
: ID_ASS {$$ = $1;}
| IDLIST COMMA ID_ASS {$$=$1;$$->addSibling($3);}
;
ID_ASS
: IDENTIFIER LOP_ASSIGN expr{
    Symbol* symbol = new Variable(currentType, *$1);
    bool ok = scope->insertSymbol(*$1, $3->lineno, symbol);
    if (!ok)  {
      cerr << "Line " << lineno << ": symbol " << *$1 << " has already been declared." << endl;
      exit(1);
      return -1;
    }
    $$ = new DeclNode($3->lineno, symbol);
    $$ -> addChild($3);
}
| IDENTIFIER {
    Symbol* symbol = new Variable(currentType, *$1);
    bool ok = scope->insertSymbol(*$1, lineno, symbol);
    if (!ok)  {
      cerr << "Line " << lineno << ": symbol " << *$1 << " has already been declared." << endl;
      exit(1);
      return -1;
    }
    $$ = new DeclNode(lineno, symbol);
}
| IDENTIFIER LBRACKET SYMBOL RBRACKET {
    Symbol* symbol = new Variable(Symbol::VALUE_ARRAY , *$1);
    bool ok = scope->insertSymbol(*$1 , lineno , symbol);
    if (!ok)  {
      cerr << "Line " << lineno << ": symbol " << *$1 << " has already been declared." << endl;
      exit(1);
      return -1;
    }
    auto var = new DeclNode(lineno , symbol);
    var -> setArrayLength($3->value);
    $$ = var;
}
;

if_else_stmt
: K_IF LPAREN bool_expression RPAREN statement K_ELSE statement{
    $$ = new StmtNode($3->lineno,StmtNode::STMT_IF_ELSE, {$3, $5, $7});
}
;
if_stmt
: K_IF LPAREN bool_expression RPAREN statement %prec IFX{
    $$ = new StmtNode($3->lineno,StmtNode::STMT_IF, {$3, $5});
}
;

while_stmt
: K_WHILE LPAREN bool_expression RPAREN statement{
    $$ = new StmtNode($3->lineno,StmtNode::STMT_WHILE, {$3, $5});
}
;
for_stmt
: K_FOR LPAREN expr SEMICOLON bool_expression SEMICOLON expr RPAREN statement{
    $$ = new StmtNode($3->lineno,StmtNode::STMT_FOR, {$3, $5, $7, $9});
}
| K_FOR LPAREN declaration SEMICOLON bool_expression SEMICOLON expr RPAREN statement{
    $$ = new StmtNode($3->lineno,StmtNode::STMT_FOR, {$3, $5, $7, $9});
}
;

expr
: assignment {$$ = $1;}
| expr LPAREN expr RPAREN{
    $$ = new FuncCallNode($1->lineno, $1->symbol, {$3});
}
| expr COMMA assignment {
    $1 -> addSibling($3);
    $$ = $1;
}
| %empty{
    $$ = new EmptyNode(lineno);
}
;

assignment
: assignment LOP_ASSIGN assignment{
    $$ = new OperatorNode($1->lineno, OperatorNode::OP_ASSIGN, {$3, $1});
}
| assignment LOP_ADDASS assignment{
    $$ = new OperatorNode($1->lineno, OperatorNode::OP_ADDASS, {$3, $1});
}
| assignment LOP_SUBASS assignment{
    $$ = new OperatorNode($1->lineno, OperatorNode::OP_SUBASS, {$3, $1});
}
| assignment LOP_MULTASS assignment{
    $$ = new OperatorNode($1->lineno, OperatorNode::OP_MULTASS, {$3, $1});
}
| assignment LOP_DEVASS assignment{
    $$ = new OperatorNode($1->lineno, OperatorNode::OP_DEVASS, {$3, $1});
}
| assignment LOP_MODASS assignment{
    $$ = new OperatorNode($1->lineno, OperatorNode::OP_MODASS, {$3, $1});
}
| or_expr{ $$ = $1; }
;
or_expr
: or_expr LOP_OR and_expr{
    $$ = new OperatorNode($1->lineno, OperatorNode::OP_OR, {$1, $3});
}
| and_expr { $$ = $1;}
;
and_expr
: and_expr LOP_AND bor_expr{
    $$ = new OperatorNode($1->lineno, OperatorNode::OP_AND, {$1, $3});
}
| bor_expr { $$ = $1;}
;
bor_expr
: bor_expr LOP_BOR bor_expr{
    $$ = new OperatorNode($1->lineno, OperatorNode::OP_BOR, {$1, $3});
}
| xor_expr { $$ = $1;}
;
xor_expr
: xor_expr LOP_XOR band_expr{
    $$ = new OperatorNode($1->lineno, OperatorNode::OP_XOR, {$1, $3});
}
| band_expr { $$ = $1;}
;
band_expr
: band_expr LOP_BAND comp_expr{
    $$ = new OperatorNode($1->lineno, OperatorNode::OP_BAND, {$1, $3});
}
| comp_expr { $$ = $1;}
;
comp_expr
: comp_expr LOP_EQ sh_expr{
    $$ = new OperatorNode($1->lineno, OperatorNode::OP_EQ, {$1, $3});
}
| comp_expr LOP_NEQ sh_expr{
    $$ = new OperatorNode($1->lineno, OperatorNode::OP_NEQ, {$1, $3});
}
| comp_expr LOP_LEQ sh_expr{
    $$ = new OperatorNode($1->lineno, OperatorNode::OP_LEQ, {$1, $3});
}   
| comp_expr LOP_SEQ sh_expr{
    $$ = new OperatorNode($1->lineno, OperatorNode::OP_SEQ, {$1, $3});
}   
| comp_expr LOP_L sh_expr{
    $$ = new OperatorNode($1->lineno, OperatorNode::OP_L, {$1, $3});
}
| comp_expr LOP_S sh_expr{
    $$ = new OperatorNode($1->lineno, OperatorNode::OP_S, {$1, $3});
}
| sh_expr { $$ = $1; }   
;
sh_expr
: sh_expr LOP_SHL as_expr{
    $$ = new OperatorNode($1->lineno, OperatorNode::OP_SHL, {$1, $3});
}
| sh_expr LOP_SHR as_expr{
    $$ = new OperatorNode($1->lineno, OperatorNode::OP_SHR, {$1, $3});
}
| as_expr { $$ = $1 ;}
;
as_expr
: as_expr LOP_ADD term{
    $$ = new OperatorNode($1->lineno, OperatorNode::OP_ADD, {$1, $3});
}
| as_expr LOP_SUB term{
    $$ = new OperatorNode($1->lineno, OperatorNode::OP_SUB, {$1, $3});
}
| term {$$=$1;}
;
term      
:term LOP_MULT factor{
    $$ = new OperatorNode($1->lineno, OperatorNode::OP_MULT, {$1, $3});
}
| term LOP_DEV factor{
    $$ = new OperatorNode($1->lineno, OperatorNode::OP_DEV, {$1, $3});
}
| term LOP_MOD factor{
    $$ = new OperatorNode($1->lineno, OperatorNode::OP_MOD, {$1, $3});
}
| term LOP_DADD {
    $$ = new OperatorNode($1->lineno, OperatorNode::OP_DADD, {$1});
}
| term LOP_DSUB {
    $$ = new OperatorNode($1->lineno, OperatorNode::OP_DSUB, {$1});
}
| LOP_DADD term {
    $$ = new OperatorNode($2->lineno, OperatorNode::OP_DADD, {$2});
}
| LOP_DSUB term {
    $$ = new OperatorNode($2->lineno, OperatorNode::OP_DSUB, {$2});
}
| LOP_BAND term{
    $$ = new OperatorNode($2->lineno, OperatorNode::OP_TADDR, {$2});
}
| factor {$$ = $1;}
;
factor
: LPAREN expr RPAREN{
    $$ = $2;
}
| IDENTIFIER {
    auto symbol = scope->findSymbol(*$1);
    if (symbol == nullptr) {
      std::cerr << "Line " << lineno << ": symbol " << *$1 << " is not defined." << endl;
      exit(1);
      return -1;
    }
    $$ = new ExprNode(lineno, symbol);
}
| IDENTIFIER LBRACKET expr RBRACKET {
    auto symbol = scope->findSymbol(*$1);
    if (symbol == nullptr) {
      std::cerr << "Line " << lineno << ": symbol " << *$1 << " is not defined." << endl;
      exit(1);
      return -1;
    }
    $$ = new ExprNode (lineno, symbol);
    $$ -> addSibling ($3);
}
| LOP_NOT term{
    $$ = new OperatorNode($2->lineno, OperatorNode::OP_NOT, {$2});
}
| LOP_BNOT term{
    $$ = new OperatorNode($2->lineno, OperatorNode::OP_BNOT, {$2});
}
| LOP_ADD term %prec UADD{
    $$ = new OperatorNode($2->lineno, OperatorNode::OP_ADD, {$2});
}
| LOP_SUB term %prec UMINUS{
    $$ = new OperatorNode($2->lineno, OperatorNode::OP_UMINUS, {$2});
}
| SYMBOL {
    $$ = new ExprNode(lineno, $1);
}
;

T
: T_INT { currentType = Symbol::VALUE_INT; if(scope->getScopeStack().size()==1) currentFunType = currentType;}
| T_CHAR { currentType = Symbol::VALUE_CHAR; if(scope->getScopeStack().size()==1) currentFunType = currentType;}
| T_BOOL {currentType = Symbol::VALUE_BOOL; if(scope->getScopeStack().size()==1) currentFunType = currentType;}
| T_VOID { currentType = Symbol::VALUE_VOID; if(scope->getScopeStack().size()==1) currentFunType = currentType; }
| T_STRING { currentType = Symbol::VALUE_STRING; if(scope->getScopeStack().size()==1) currentFunType = currentType;}
| T_DOUBLE { currentType = Symbol::VALUE_DOUBLE; if(scope->getScopeStack().size()==1) currentFunType = currentType; }
;

%%

int yyerror(char const* message)
{
  cout << message << " at line " << lineno << endl;
  return -1;
}