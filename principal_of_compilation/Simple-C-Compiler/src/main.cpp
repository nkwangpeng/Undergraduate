#include "common.h"
#include <fstream>
#include "tree.h"
extern TreeNode *root;
extern FILE *yyin;
extern Scope* scope;
extern Scope* scope_out;
extern int yyparse();
using namespace std;
ofstream out("result.txt");
int main(int argc, char *argv[])
{
    if (argc == 2)
    {
        FILE *fin = fopen(argv[1], "r");
        if (fin != nullptr)
        {
            yyin = fin;
        }
        else
        {
            cerr << "failed to open file: " << argv[1] << endl;
        }
    }
    yyparse();
    if(root != NULL) {
        root->genNodeId();
        root->typeCheck(root);
        root->printAST();
        extern void generateASM();
        generateASM();
    }
    list<list<ScopeNode>> scopeStack = scope_out->getScopeStack();
    int i = 0,j = 0;
    list<list<ScopeNode>>::iterator itor;
    for(itor = scopeStack.begin();itor != scopeStack.end();itor++){
        list<ScopeNode>::iterator itor2;
        for(itor2 = itor->begin();itor2 != itor->end(); itor2++){
            out<< itor2 -> symbol ->value <<":"<< i <<" " << j<<"    ";
            j++;
        }
        i++;
        j = 0 ;
        out << endl;
    }
    return 0;
}