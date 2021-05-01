%{
#include"common.h"
#include"main.tab.h"
int lineno=1;
%}

LINECOMMENT \/\/.*
EOL (\r\n|\r|\n)
WHITESPACE [[:blank:]]

INTEGER [0-9]+
DOUBLE ([0-9]+)?(\.[0-9]+)([eE](\+|-)?[0-9]+)?
CHAR  \'.+\'
STRING \".+\"

IDENTIFIER [_a-zA-Z][_a-zA-Z0-9]*
RESERVED "auto"|"enum"|"signed"|"sizeof"|"static"|"struct"|"typedef"|"union"

%%

"/*" {
  int c;
  while((c = yyinput()) != 0)
  {
    if(c == '\n')
      ++lineno;
    else if(c == '*')
    {
      if((c = yyinput()) == '/')
        break;
      else
        unput(c);
    }
  }
}
{LINECOMMENT} /*do nothing */
{RESERVED} cerr << "[ line" << lineno << " ] reserved token: " << yytext;
"skip" return K_SKIP;

"true" {
    yylval.symbol = new Constant(Constant::VALUE_BOOL, "true"); 
    return SYMBOL;
}
"false" {
    yylval.symbol = new Constant(Constant::VALUE_BOOL, "false"); 
    return SYMBOL;
}

"int" return T_INT;
"bool" return T_BOOL;
"string" return T_STRING;
"double"|"float" return T_DOUBLE;
"char" return T_CHAR;
"void" return T_VOID;

"for" return K_FOR;
"if" return K_IF;
"while" return K_WHILE;
"else" return K_ELSE;
"break"	return K_BREAK;
"case" return K_CASE;
"continue"	return K_CONTINUE;
"return" return K_RET;
"switch" return K_SWITCH;
"default" return K_DEFAULT;

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
"!=" return LOP_NEQ;
"<<" return LOP_SHL;
">>" return LOP_SHR;
">" return LOP_L;
">=" return LOP_LEQ;
"<" return LOP_S;
"<=" return LOP_SEQ;
"?" return QM;
":" return COLON;


"," return COMMA;
";" return SEMICOLON;
"(" return LPAREN;
")" return RPAREN;
"[" return LBRACKET;
"]" return RBRACKET;
"{" return LBRACE;
"}" return RBRACE;
"scanf" {
  yylval.symbol = new Callable(Constant::VALUE_INT, "scanf");
  return SYMBOL;
}
"printf" {
  yylval.symbol = new Callable(Constant::VALUE_INT, "printf");
  return SYMBOL;
}

{INTEGER} {
    yylval.symbol = new Constant(Constant::VALUE_INT, yytext);
    return SYMBOL;
}

{CHAR} {
    const char* text = yytext;
    string str = string(text + 1);
    size_t len = str.length() -1;
    str = (len > 0) ? str.substr(0, len) : string();
    yylval.symbol = new Constant(Constant::VALUE_CHAR, str);
    return SYMBOL;
}

{IDENTIFIER} {
    yylval.value = new string(yytext);
    return IDENTIFIER;
}

{STRING} {
    const char* text = yytext;
    string str = string(text + 1);
    size_t len = str.length() -1;
    str = (len > 0) ? str.substr(0, len) : string();
    yylval.symbol = new Constant(Constant::VALUE_STRING, str);
    return SYMBOL;
}

{DOUBLE} {
    yylval.symbol = new Constant(Constant::VALUE_DOUBLE, yytext);
    return SYMBOL;
}

{WHITESPACE} /* DO NOTHING */

{EOL} lineno++;

. {
    cerr<<"[line "<< lineno << " ] unknown character:" << yytext <<endl;
}

%%