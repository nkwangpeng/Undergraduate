%option noyywrap
%top{
#include <iostream>
#include <fstream>
#include <cstring>
#include <iomanip>
#include <unordered_map>
}
%{
using namespace std;
void lexing_out(string word,string yytext);
int num_lines=0;
int id_count=0;
unordered_map<string,int>idlist;
ifstream in;
ofstream out;
%}

newline         \n
space           [ \t\f\v]+
digit           [0-9]
octDigit 		[0-7]
hexDigit 		[0-9a-fA-F]
octal			(0)({octDigit}+)
hex				(0)[xX]({hexDigit}+)
ID	            [a-zA-Z_]([a-zA-Z_]|{digit})*
decimal	        (({digit}|[1-9]{digit}+)(((\.){digit}+)?))|(\.){digit}+
number			{decimal}
charval         '([^\n\\]|(\\.)|(\\{octDigit}{1,3})|(\\[xX]{hexDigit}{1,2}))'
stringval       \"(\\.|[^\\"\n])*\"
commentbegin    "/*"
commentelement  .|\n
commentend      "*/"
commentLinebegin "//"
commentLineelement .
commentLineend	 \n
%x COMMENT
%x COMMENT1


IF					if
ELSE				else
WHILE				while
THIS				this
INT					int
CHAR				char
STRING  			string
DOUBLE				double
FLOAT				float
LONG				long
SHORT				short
UNSIGNED			unsigned
CONST				const
FOR					for
BREAK				break
CONTINUE			continue
AUTO				auto
CLASS				class
OPERATOR			operator
CASE				case
DO					do
TYPEDEF				typedef
STATIC				static
FRIEND				friend
TEMPLATE			template
DEFAULT				default
NEW					new
VOID				void
RETURN				return
INLINE				inline
SIZEOF				sizeof
SWITCH				switch
PRIVATE				private
PROTECTED			protected
PUBLIC				public
STRUCT				struct
BOOL				bool
TRUE	            true
FALSE				false
NAMESPACE			namespace
USING				using
WCHAR_T				wchar_T



LBRACE    \{
RBRACE    \}
LPAREN    \(
RPAREN    \)
LSQPAREN  \[
RSQPAREN  \]
SEMI      \;
COMMA     \,
PLUS	  \+
MINUS     \-
MUL       \*
DIV       \/
MOD       \%
ASSIGN    \=
ADDASS    \+\=
SUBASS    \-\=
MULASS	  \*\=
DIVASS    \/\=
MODASS	  \%\=
ANDASS    \&\=
XORASS	  \^\=
ORASS	  \|\=
SHRASS	  ">>="
SHLASS	  "<<="
		
EQ        \=\=
LE        \<\=
LT        \<
NE		  \!\=
GT        \>
GE        \>\=
AND       \&\&
OR		  \|\|
NOT		  \!
INC       \+\+
DEC       \-\-
BAND	  \&
BOR		  \|
NOR		  \^
BNOT	  \~
LSHIFT	  \<\<
RSHIFT	  \>\>

%%
{newline}       {num_lines++;}
{space}         {/*skip*/;}

{commentbegin}  {BEGIN COMMENT;}
<COMMENT>{commentelement}   {}
<COMMENT>{commentend}   {BEGIN INITIAL;}
{commentLinebegin}  {BEGIN COMMENT1;}
<COMMENT1>{commentLineelement}   {}
<COMMENT1>{commentLineend}   {BEGIN INITIAL;}
{charval}           {lexing_out("CHARVAL",yytext);}
{stringval}         {lexing_out("STRINGVAL",yytext);}
{IF}				{lexing_out("IF",yytext);}
{ELSE}				{lexing_out("ELSE",yytext);}
{WHILE}				{lexing_out("WHILE",yytext);}
{THIS}				{lexing_out("THIS",yytext);}
{INT}				{lexing_out("INT",yytext);}
{CHAR}				{lexing_out("CHAR",yytext);}
{STRING}         	{lexing_out("STRING",yytext);}
{DOUBLE}			{lexing_out("DOUBLE",yytext);}
{FLOAT}				{lexing_out("FLOAT",yytext);}
{LONG}				{lexing_out("LONG",yytext);}
{SHORT}				{lexing_out("SHORT",yytext);}
{UNSIGNED}	        {lexing_out("UNSIGNED",yytext);}
{CONST}				{lexing_out("CONST",yytext);}
{FOR}				{lexing_out("FOR",yytext);}
{BREAK}				{lexing_out("BREAK",yytext);}
{CONTINUE}			{lexing_out("CONTINUE",yytext);}
{AUTO}				{lexing_out("AUTO",yytext);}
{CLASS}				{lexing_out("CLASS",yytext);}
{OPERATOR}			{lexing_out("OPERATOR",yytext);}
{CASE}				{lexing_out("CASE",yytext);}
{DO}				{lexing_out("DO",yytext);}
{TYPEDEF}			{lexing_out("TYPEDEF",yytext);}
{STATIC}			{lexing_out("STATIC",yytext);}
{FRIEND}			{lexing_out("FRIEND",yytext);}
{TEMPLATE}			{lexing_out("TEMPLATE",yytext);}
{DEFAULT}			{lexing_out("DEFAULT",yytext);}
{NEW}				{lexing_out("NEW",yytext);}
{VOID}				{lexing_out("VOID",yytext);}
{RETURN}			{lexing_out("RETURN",yytext);}
{INLINE}			{lexing_out("INLINE",yytext);}			
{SIZEOF}			{lexing_out("SIZEOF",yytext);}	
{SWITCH}			{lexing_out("SWITCH",yytext);}
{PRIVATE}			{lexing_out("PRIVATE",yytext);}
{PROTECTED}			{lexing_out("PROTECTED",yytext);}
{PUBLIC}			{lexing_out("PUBLIC",yytext);}
{STRUCT}			{lexing_out("STRUCT",yytext);}
{BOOL}				{lexing_out("BOOL",yytext);}
{TRUE}	            {lexing_out("TRUE",yytext);}
{FALSE}				{lexing_out("FALSE",yytext);}
{NAMESPACE}			{lexing_out("NAMESPACE",yytext);}
{USING}				{lexing_out("USING",yytext);}
{WCHAR_T}			{lexing_out("WCHAR_T",yytext);}

{LBRACE}            {lexing_out("LBRACE",yytext);}
{RBRACE}            {lexing_out("RBRACE",yytext);}
{LPAREN}            {lexing_out("LPAREN",yytext);}
{RPAREN}            {lexing_out("RPAREN",yytext);}
{SEMI}              {lexing_out("SEMI",yytext);}
{COMMA}             {lexing_out("COMMA",yytext);}

{PLUS}              {lexing_out("PLUS",yytext);}
{MINUS}             {lexing_out("MINUS",yytext);}
{MUL}               {lexing_out("MUL",yytext);}
{DIV}               {lexing_out("DIV",yytext);}
{MOD}               {lexing_out("MOD",yytext);}
{INC}               {lexing_out("INC",yytext);}
{DEC}               {lexing_out("DEC",yytext);}
{BAND}              {lexing_out("BAND",yytext);}
{BOR}               {lexing_out("BOR",yytext);}
{NOR}               {lexing_out("NOR",yytext);}
{BNOT}              {lexing_out("BNOT",yytext);}
{LSHIFT}            {lexing_out("LSHIFT",yytext);}
{RSHIFT}            {lexing_out("RSHIFT",yytext);}

{ASSIGN}            {lexing_out("ASSIGN",yytext);}
{EQ}                {lexing_out("EQ",yytext);}
{LE}                {lexing_out("LE",yytext);}
{LT}                {lexing_out("LT",yytext);}
{GE}                {lexing_out("GE",yytext);}
{GT}                {lexing_out("GT",yytext);}
{NE}                {lexing_out("NE",yytext);}

{AND}               {lexing_out("AND",yytext);}
{OR}                {lexing_out("OR",yytext);}
{NOT}               {lexing_out("NOT",yytext);}

{number}        {out<<std::setw(8)<<"NUMBER"<<std::setw(8)<<yytext<<std::setw(8)<<atof(yytext)<<"\n";}
{octal}         {out<<std::setw(8)<<"NUMBER"<<std::setw(8)<<yytext<<std::setw(8)<<atof(yytext)<<"\n";}
{hex}			{out<<std::setw(8)<<"NUMBER"<<std::setw(8)<<yytext<<std::setw(8)<<yytext<<"\n";}

{ID}            {if(idlist.find(yytext)==idlist.end())
				{
					idlist[yytext]=id_count;
					id_count++;
				}
				out<<std::setw(8)<<"ID"<<std::setw(8)<<yytext<<std::setw(8)<<idlist[yytext]<<"\n";}


%%

void lexing_out(string word,string yytext){out<<std::setw(8)<<word<<std::setw(8)<<yytext<<"\n";}
int main(int argc,char **argv){
	if(argc>1){
		in.open(argv[1]);
		yyFlexLexer lexer(&in);
		if(argc>2){
			out.open(argv[2]);
			out<<std::setw(10)<<"单词"<<std::setw(10)<<"词素"<<std::setw(10)<<"属性"<<"\n";
			lexer.yylex();
		}
	}
	in.close();
	out.close();
	return 0;
}