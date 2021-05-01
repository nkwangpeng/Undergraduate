#include "tree.h"
#include "symbol.h"
static int nodeIndex=0;
extern ofstream out;
void TreeNode::addChild(TreeNode* child) {
    if(this->child)
    {
        auto temp=this->child;
        while(temp->sibling)
        {
            temp = temp->sibling;
        }
        temp->sibling = child;
    }
    else
    {
        this->child = child;
    } 
}

void TreeNode::addSibling(TreeNode* sibling){
    if(this->sibling)
    {
        auto temp=this->sibling;
        while(temp->sibling)
        {
            temp = temp->sibling;
        }
        temp->sibling = sibling;
    }
    else
    {
        this->sibling=sibling;
    }
}

TreeNode::TreeNode(int lineno, NodeType type) {
    this->nodeType = type;
    this->lineno = lineno;
}

void TreeNode::genNodeId() {
    this->nodeID = nodeIndex++;
    if(this->child)
    {
        this->child->genNodeId();
    }
    if(this->sibling)
    {
        this->sibling->genNodeId();
    }
}

void TreeNode::printNodeInfo() {
     out<<"lno@"<<std::left << std::setw(3)<<this->lineno<<"@"<<std::left << std::setw(3)<<this->nodeID<<std::left << std::setw(12)<<this->getNodeTypeStr(this->nodeType);
}

void TreeNode::printChildrenId() {
    string childrenId="[";
    if(this->child)
    {
        childrenId+="@";
        childrenId+=to_string(this->child->nodeID);
        childrenId+=" ";
        TreeNode* temp=this->child;
        while(temp->sibling)
        {
            childrenId+="@";
            childrenId+=to_string(temp->sibling->nodeID);
            childrenId+=" ";
            temp = temp->sibling;   
        }
    }
    childrenId+="]";
    out<<"children: " <<std::left << std::setw(15)<< childrenId<< "  ";
}

void TreeNode::typeCheck(TreeNode* root) {
    if (root == nullptr)
        return;
    auto children = root->child;
    while (children)
    {
        typeCheck(children);
        children = children->sibling;
    }
    Symbol *ownSymbol = nullptr;
    Symbol *cl = nullptr;
    Symbol *cr = nullptr;

    switch (root->nodeType)
    {
    case TreeNode::NODE_NONE:
        break;
    case TreeNode::NODE_STMT:
        switch (static_cast<StmtNode *>(root)->type)
        {
        case StmtNode::STMT_EMPTY:
            break;
        case StmtNode::STMT_SCOPE:
            break;
        case StmtNode::STMT_RETURN:
            break;
        case StmtNode::STMT_WHILE:
            break;
        case StmtNode::STMT_FOR:
            break;
        case StmtNode::STMT_FUNC:
            if(root->child)
            {   
                auto funSymbol = static_cast<FunStmtNode *>(root)->symbol;
                auto result = root->child;
                while(result && result->sibling) result = result->sibling;
                if(Symbol::getSymbolName(funSymbol)=="void" && static_cast<StmtNode *>(result)->type == StmtNode::STMT_RETURN)
                {
                    cerr<<"function whose type is void shouldn't return any value" << endl;
                    exit(1);
                }
            }
            break;
        case StmtNode::STMT_IF_ELSE:
            break;
        case StmtNode::STMT_PRINTF:
            if (root->child->symbol->type == Symbol::VALUE_BOOL)
            {
                cerr << " output can't be bool" << endl;
                assert(0);
            }
            if(root->child->sibling!=nullptr && root->child->sibling->symbol->type == Symbol::VALUE_BOOL){
                cerr << " output can't be bool" << endl;
                assert(0);
            }
            break;
        case StmtNode::STMT_SCANF:
            string str = root->child->symbol->value;
            if(str == "%d" && root->child->sibling->symbol->type != Symbol::VALUE_INT) {
                cerr << " expected type is [int] , but input type is [" <<Symbol::getSymbolName(root->child->sibling->symbol) <<"]"<<endl;
                assert(0);          
            }
            if(str == "%c" && root->child->sibling->symbol->type != Symbol::VALUE_CHAR) {
                cerr << " expected type is [char] , but input type is [" <<Symbol::getSymbolName(root->child->sibling->symbol) <<"]"<<endl;
                assert(0);          
            }
            if(str == "%s" && root->child->sibling->symbol->type != Symbol::VALUE_STRING) {
                cerr << " expected type is [string] , but input type is [" <<Symbol::getSymbolName(root->child->sibling->symbol) <<"]"<<endl;
                assert(0);          
            }
            if(str == "%f" && root->child->sibling->symbol->type != Symbol::VALUE_DOUBLE) {
                cerr << " expected type is [double] , but input type is [" <<Symbol::getSymbolName(root->child->sibling->symbol) <<"]"<<endl;
                assert(0);          
            }
        }
        break;

    case TreeNode::NODE_FUNCCALL:
        break;
    case TreeNode::NODE_DECL:
        break;
    case TreeNode::NODE_EXPR:
        break;

    case TreeNode::NODE_OP:
        switch (static_cast<OperatorNode *>(root)->type)
        {
        case OperatorNode::OP_NOT:
        case OperatorNode::OP_BOOL:
            if (root->child->symbol->type != Symbol::VALUE_BOOL)
            {
                cerr <<"line: "<<root->child->lineno<< " expression is not BOOL-TYPE  " << endl;
                assert(0);
            }
            ownSymbol = root->symbol = new OpNode(Symbol::VALUE_BOOL, "");
            break;
        case OperatorNode::OP_TADDR:
            ownSymbol = root->symbol = new OpNode(Symbol::VALUE_INT, "");
            break;
        case OperatorNode::OP_AND:
        case OperatorNode::OP_OR:
            cl = static_cast<DeclNode *>(root->child)->symbol;
            cr = static_cast<DeclNode *>(root->child->sibling)->symbol;
            if (cr->type != cl->type || cl->type != Symbol::VALUE_BOOL || cr->type != Symbol::VALUE_BOOL)
            {
                cerr << endl
                     << "type is error [" << Symbol::getSymbolName(cl)
                     << " , " << Symbol::getSymbolName(cr) << " ] or maybe they are not bool";
                assert(0);
            }
            ownSymbol = root->symbol = new OpNode(Symbol::VALUE_BOOL, "");
            break;
        case OperatorNode::OP_L:
        case OperatorNode::OP_LEQ:
        case OperatorNode::OP_S:
        case OperatorNode::OP_SEQ:
        case OperatorNode::OP_EQ:
        case OperatorNode::OP_NEQ:
            cl = static_cast<DeclNode *>(root->child)->symbol;
            cr = static_cast<DeclNode *>(root->child->sibling)->symbol;
            if (cr->type != cl->type)
            {
                cerr << endl <<"line: "<<root->lineno
                     << "type is error(compare) [" << Symbol::getSymbolName(cl)
                     << " , " << Symbol::getSymbolName(cr) << " ]";
                assert(0);
            }
            ownSymbol = root->symbol = new OpNode(Symbol::VALUE_BOOL, "");
            break;
        case OperatorNode::OP_BNOT:
        case OperatorNode::OP_DADD:
        case OperatorNode::OP_DSUB:
            ownSymbol = root->symbol = new OpNode(root->child->symbol->type, "");
            break;
        case OperatorNode::OP_UMINUS:
            ownSymbol = root->symbol = new OpNode(Symbol::VALUE_INT, "");
            break;
        default:
            cl = static_cast<DeclNode *>(root->child)->symbol;
            cr = static_cast<DeclNode *>(root->child->sibling)->symbol;
            if (cr->type != cl->type)
            {
                cerr << endl
                     << "type is error [" << Symbol::getSymbolName(cl)
                     << " , " << Symbol::getSymbolName(cr) << " ]";
                assert(0);
            }
            ownSymbol = root->symbol = new OpNode(root->child->symbol->type, "");
            break;
        }
        break;
    }
}

void TreeNode::printAST() {
    this->printNodeInfo();
    this->printChildrenId();
    this->printSpecialInfo();
    if(this->child){
        this->child->printAST();
    }
    if(this->sibling){
        this->sibling->printAST();
    }
}

StmtNode::StmtNode(int lineno, StmtType type, std::initializer_list<TreeNode *> children)
    : TreeNode(lineno, NODE_STMT), type(type)
{
    for( auto elem : children )
        this->addChild(elem);
}

FunStmtNode::FunStmtNode(int lineno, Callable *symbol, std::initializer_list<TreeNode*> children) : StmtNode (lineno, STMT_FUNC, children)
{
    this->symbol = symbol;
}


DeclNode::DeclNode(int lineno, Symbol *symbol)
    : TreeNode(lineno, NODE_DECL)
{
    this->symbol = symbol;
}

void DeclNode::setArrayLength(string length) {
    this->arrayLength = atoi(length.c_str());
}

ExprNode::ExprNode(int lineno, Symbol *symbol)
    : TreeNode(lineno, NODE_EXPR)
{
    this->symbol = symbol;
}

ExprNode::ExprNode(int lineno, Symbol::ValueType type, string value, bool isConstant)
    : TreeNode(lineno, NODE_EXPR)
{
    if (isConstant)
        this->symbol = new Constant(type, value);
    else
        this->symbol = new Variable(type, value);
}

OperatorNode::OperatorNode(int lineno, OperatorNode::OperatorType type, std::initializer_list<TreeNode *> children)
    : ExprNode (lineno, nullptr), type(type)
{
    nodeType = NODE_OP;
    for( auto elem : children )
        this->addChild(elem);
}

EmptyNode::EmptyNode(int lineno) : StmtNode (lineno, STMT_EMPTY){ }

FuncCallNode::FuncCallNode(int lineno, Symbol *symbol, std::initializer_list<TreeNode *> children) : ExprNode (lineno, symbol)
{
    nodeType = NODE_FUNCCALL;
    for( auto elem : children )
        this->addChild(elem);
}

string StmtNode::getStmtTypeStr(StmtType type) {
    switch(type) {
        case STMT_FOR:
            return "for";
        case STMT_IF_ELSE:
            return "if_else";
        case STMT_WHILE:
            return "while";
        case STMT_PRINTF:
            return "printf";
        case STMT_SCANF:
            return "scanf";
        case STMT_SCOPE:
            return "LB_SCOPE";
        case STMT_RETURN:
            return "return";
        case STMT_IF:
            return "IF";
        default:
            cerr << "shouldn't reach here, typeinfo";
            assert(0);
    }
    return "";
}


string TreeNode::getNodeTypeStr (NodeType type){
    switch(type) {
        case NODE_NONE:
            return "node";
        case NODE_FUNCCALL:
            return "function_call";
        case NODE_DECL:
            return "declaration";
        case NODE_EXPR:
            return "expression";
        case NODE_OP:
            return "op";
        case NODE_STMT:
            return "statement";
        default:
            cerr << "shouldn't reach here, typeinfo";
            assert(0);
    }
    return "";
}

string OperatorNode::getOpTypeStr(OperatorType type)
{
    switch(type) {
        case OP_ASSIGN:
            return "ASSIGN";
        case OP_ADD:
            return "ADD";
        case OP_SUB:
            return "SUB";
        case OP_MULT:
            return "MULT";
        case OP_DEV:
            return "DEV";
        case OP_MOD:
            return "MOD";
        case OP_DADD:
            return "DADD";
        case OP_DSUB:
            return "DSUB";
        case OP_ADDASS:
            return "ADDASS";
        case OP_SUBASS:
            return "SUBASS";
        case OP_MULTASS:
            return "MULTASS";
        case OP_DEVASS:
            return "DEVASS";
        case OP_MODASS:
            return "MODASS";
        case OP_AND:
            return "AND";
        case OP_OR:
            return "OR";
        case OP_NOT:
            return "NOT";
        case OP_BNOT:
            return "BNOT";
        case OP_BAND:
            return "BAND";
        case OP_BOR:
            return "BOR";
        case OP_XOR:
            return "XOR";
        case OP_EQ:
            return "EQ";
        case OP_L:
            return "L";
        case OP_LEQ:
            return "LEQ";
        case OP_S:
            return "S";
        case OP_SEQ:
            return "SEQ";
        case OP_NEQ:
            return "NEQ";
        case OP_SHL:
            return "SHL";
        case OP_SHR:
            return "SHR";
        case OP_BOOL:
            return "BOOL";
        case OP_TADDR:
            return "TADDR";
        case OP_UMINUS:
            return "UMINUS";
        default:
            cerr << "shouldn't reach here, typeinfo";
            assert(0);
    }
    return "";
}


// You can output more info...
void TreeNode::printSpecialInfo() {
    out<<endl;
}
void StmtNode::printSpecialInfo(){
    out<<"stmt: "<<this->getStmtTypeStr(this->type) << endl;
}
void ExprNode::printSpecialInfo(){
    out<<"expr: "<<this->symbol->getSymbolName(this->symbol)<<" "<<this->symbol->value<<endl;
}
void OperatorNode::printSpecialInfo(){
    out<<"op: "<<this->getOpTypeStr(this->type) << endl;
}
void DeclNode::printSpecialInfo(){
    out<<"decl: "<<this->symbol->getSymbolName(this->symbol)<<" "<<this->symbol->value<<"  ";
    if(this->symbol->type == Symbol::VALUE_ARRAY) {
        out << this->getArrayLength() << endl;
    }
    else {
        out << endl;
    }
}
void FunStmtNode::printSpecialInfo(){
    out<<"function: "<<this->symbol->getSymbolName(this->symbol)<<" "<<this->symbol->value<<endl;
}
void FuncCallNode::printSpecialInfo(){
    out<<"function_call: "<<endl;
}
void EmptyNode::printSpecialInfo(){
    out<<"empty: "<<endl;
}
