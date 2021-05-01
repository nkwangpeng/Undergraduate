%{
/*
code by wangpeng 1811431
2020-10-20
*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifndef YYSTYPE
#define YYSTYPE double
#endif
char idStr[50];
double dataValue;
int count=0;
int i;
typedef struct
{
  char str[50];
  float num;
}tokenTable;
tokenTable pair[50];
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
%token ID

%right '='
%left ADD SUB
%left MUL DIV
%right UMINUS

%%

lines   :   lines expr ';'
        |   lines ';'
        |
        ;
expr    : expr ADD expr {$$=$1+$3;}
        | expr SUB expr {$$=$1-$3;}
        | expr MUL expr {$$=$1*$3;}
        | expr DIV expr {$$=$1/$3;}
        | LP expr RP {$$=$2;}
        | SUB expr %prec UMINUS {$$=-$2;}
        | NUMBER {$$=dataValue;}
        | ID {int exist_num=0;for(i=0;i<count;i++){if(strcmp(pair[i].str,idStr)==0) {$$=pair[i].num;exist_num=1;/*printf("%s：",pair[i].str);printf("%fdd\n",pair[i].num);*/}} if(exist_num==0){$$=0;strcpy(pair[count].str,idStr);pair[count++].num=0;}}
        | expr '=' expr {int exist_num=0; for(i=0;i<count;i++){if(strcmp(pair[i].str,idStr)==0) {$$=$3;pair[i].num=$3;exist_num=1;break;}} printf("%s：",idStr);printf("%f\n",pair[i].num);}
        ;
%%

int yylex(){
    int t;
    while(1){
        t=getchar();
        if(t==' '||t=='\r'||t=='\n')
            ;
        else if(isdigit(t)){
            double tmp=0;
            while(isdigit(t)){
                tmp=t+tmp*10-'0';
                t=getchar();
            }
            dataValue=tmp;
            ungetc(t,stdin);
            return NUMBER;
        }
        else if((t>='a'&&t<='z')||(t>='A'&&t<='Z')||(t=='_')){
            int ti=0;
            char tmp[50];
            while((t>='a'&&t<='z')||(t>='A'&&t<='Z')||(t=='_')||(t>='0'&&t<='9')){
                tmp[ti]=t;
                ti++;
                t=getchar();
            }
            tmp[ti]='\0';
            strcpy(idStr,tmp);
            ungetc(t,stdin);
            return ID;
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
        else if(t=='=')
            return '=';
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