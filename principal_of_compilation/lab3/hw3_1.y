%{
/*
code by wangpeng 1811431
2020-10-20
*/
#include <stdio.h>
#include <stdlib.h>
#ifndef YYSTYPE
#define YYSTYPE double
#endif
int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);
%}

%token ADD
%token SUB
%token MUL
%token DIV
%token LP
%token RP
%token NUMBER

%left ADD SUB
%left MUL DIV
%right UMINUS

%%

lines   :   lines expr ';' {printf("%f\n",$2);}
        |   lines ';'
        |
        ;
expr    : expr ADD expr {$$=$1+$3;}
        | expr SUB expr {$$=$1-$3;}
        | expr MUL expr {$$=$1*$3;}
        | expr DIV expr {$$=$1/$3;}
        | LP expr RP {$$=$2;}
        | SUB expr %prec UMINUS {$$=-$2;}
        | NUMBER
        ;
%%

int yylex(){
    int t;
    while(1){
        t=getchar();
        if(t==' '||t=='\r'||t=='\n')
            ;
        else if(isdigit(t)){
            yylval=t-'0';
            return NUMBER;
        }
        else if(t=='+')
            return ADD;
        else if(t=='-')
            return SUB;
        else if(t=='*')
            return MUL;
        else if(t=='/')
            return DIV;
        else if(t=='(')
            return LP;
        else if(t==')')
            return RP;
        else
            return t;
    }
}
int main(void){
    yyin=stdin;
    do{
        yyparse();
    }while(!feof(yyin));
    return 0;
}
void yyerror(const char*s){
    fprintf(stderr,"Parse error:%s\n",s);
    exit(1);
}