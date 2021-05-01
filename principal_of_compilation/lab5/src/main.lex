%option nounput
%{
#include"common.h"
#include"main.tab.h"
int lineno=1;
%}

BLOCKCOMMENT \/\*([^*"]*|".*"|\*+[^/])*\*\/
LINECOMMENT \/\/.*
EOL (\r\n|\r|\n)
WHITESPACE [[:blank:]]

INTEGER [0-9]+
DOUBLE ([0-9]+)?(\.[0-9]+)([eE](\+|-)?[0-9]+)?

CHAR \'.?\'
STRING \".+\"

IDENTIFIER [_a-zA-Z][_a-zA-Z0-9]*
IDAddr \&[[:alpha:]_][[:alpha:][:digit:]_]*
IDPtr \*[[:alpha:]_][[:alpha:][:digit:]_]*
RESERVED "auto"|"enum"|"signed"|"sizeof"|"static"|"struct"|"typedef"|"union"

%%

{BLOCKCOMMENT} /*do nothing */
{LINECOMMENT} /*do nothing */
{RESERVED} cerr << "[ line" << lineno << " ] reserved token: " << yytext;
"skip" return K_SKIP;

"true" {
    TreeNode *node = new TreeNode(lineno,NODE_CONST);
    node->type = TYPE_BOOL;
    node->b_val = true;
    yylval = node;
    return TRUE;
}
"false" {
    TreeNode *node = new TreeNode(lineno,NODE_CONST);
    node->type = TYPE_BOOL;
    node->b_val = false;
    yylval = node;
    return FALSE;
}

"int" return T_INT;
"bool" return T_BOOL;
"char" return T_CHAR;
"void" return T_VOID;

"for" return K_FOR;
"if" return K_IF;
"while" return K_WHILE;
"else" return K_ELSE;

"printf" return F_PRINTF;
"scanf" return F_SCANF;

"=" return LOP_ASSIGN;

"+" return LOP_ADD;
"-" return LOP_SUB;
"*" return LOP_MULT;
"/" return LOP_DEV;
"%" return LOP_MOD;
"++" return LOP_DADD;
"--" return LOP_DSUB;
"+=" return LOP_ADDASS;
"-=" return LOP_SUBASS;
"*=" return LOP_MULTASS;
"/=" return LOP_DEVASS;
"%=" return LOP_MODASS;

"&&" return LOP_AND;
"||" return LOP_OR;
"~" return LOP_BNOT;
"|" return LOP_BOR;
"&" return LOP_BAND;
"!" return LOP_NOT;
"^" return LOP_XOR;
"==" return LOP_EQ;
"~=" return LOP_NEQ;
"<<" return LOP_SHL;
">>" return LOP_SHR;
">" return LOP_L;
">=" return LOP_LEQ;
"<" return LOP_S;
"<=" return LOP_SEQ;

"," return COMMA;
";" return SEMICOLON;
"(" return LPAREN;
")" return RPAREN;
"{" return LBRACE;
"}" return RBRACE;

{INTEGER} {
    TreeNode *node = new TreeNode(lineno,NODE_CONST);
    node->type = TYPE_INT;
    node->int_val = atoi(yytext);
    yylval = node;
    return INTEGER;
}

{CHAR} {
    TreeNode *node = new TreeNode(lineno,NODE_CONST);
    node->type = TYPE_CHAR;
    node->int_val = yytext[1];
    yylval = node;
    return CHAR;
}

{IDENTIFIER} {
    TreeNode *node = new TreeNode(lineno,NODE_VAR);
    node->var_name = string(yytext);
    yylval = node;
    return IDENTIFIER;
}

{STRING} {
    TreeNode *node = new TreeNode(lineno,NODE_CONST);
    node->type = TYPE_STRING;
    string str=string(yytext);
    str.erase(str.begin());
    str.erase(str.find_last_not_of("\"") + 1);
    node->str_val = str;
    yylval = node;
    return STRING;
}

{IDAddr} {
    TreeNode *node = new TreeNode(lineno,NODE_VAR);
    string str = string(yytext);
    str.erase(str.begin());
    node->var_name = str;
    node->vflag = VAR_ADDRESS;
    yylval = node;
    return IDENTIFIER;
}
{IDPtr} {
    TreeNode *node = new TreeNode(lineno,NODE_VAR);
    string str = string(yytext);
    str.erase(str.begin());
    node->var_name = str;
    node->vflag = VAR_POINTER;
    yylval = node;
    return IDENTIFIER;
}

{WHITESPACE} /* DO NOTHING */

{EOL} lineno++;

. {
    cerr<<"[line "<< lineno << " ] unknown character:" << yytext <<endl;
}

%%