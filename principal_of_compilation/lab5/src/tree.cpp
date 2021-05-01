#include "tree.h"
static int nodeIndex=0;
extern ofstream out;
void TreeNode::addChild(TreeNode* child) {
    if(this->child)
    {
        TreeNode* temp=this->child;
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
        TreeNode* temp=this->sibling;
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
     out<<"lno@"<<std::left << std::setw(3)<<this->lineno<<"@"<<std::left << std::setw(3)<<this->nodeID<<std::left << std::setw(12)<<this->nodeType2String(this->nodeType);
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


// You can output more info...
void TreeNode::printSpecialInfo() {
    switch(this->nodeType){
        case NODE_CONST:
            out<<"type: "<<this->type->getTypeInfo() << endl;
            break;
        case NODE_FUNC:
            out<<"function:"<< endl;
            break;
        case NODE_VAR:
            out<<"varname: "<<this->var_name << endl;
            break;
        case NODE_EXPR:
            if(this->optype){
                out<<"OP: "<<this->opType2String(this->optype)<<endl;
            }
            break;
        case NODE_STMT:
            out<<"stmt: "<<this->sType2String(this->stype) << endl;
            break;
        case NODE_TYPE:
            out<<"type: "<<this->type->getTypeInfo() << endl;
            break;
        case NODE_PROG:
            out<<"program: " << endl;
            break;
        default:
            cerr << "shouldn't reach here, typeinfo";
            assert(0);
            break;
    }
}

string TreeNode::sType2String(StmtType type) {
    switch(type) {
        case STMT_FOR:
            return "for";
        case STMT_SKIP:
            return "skip";
        case STMT_DECL:
            return "decl";
        case STMT_ASSIGN:
            return "assign";
        case STMT_SEQ:
            return "seq";
        case STMT_IF_ELSE:
            return "if_else";
        case STMT_WHILE:
            return "while";
        case STMT_PRINTF:
            return "printf";
        case STMT_SCANF:
            return "scanf";
        default:
            cerr << "shouldn't reach here, typeinfo";
            assert(0);
    }
    return "";
}


string TreeNode::nodeType2String (NodeType type){
    switch(type) {
        case NODE_CONST:
            return "const";
        case NODE_FUNC:
            return "function";
        case NODE_VAR:
            return "variable";
        case NODE_EXPR:
            return "expression";
        case NODE_TYPE:
            return "type";
        case NODE_STMT:
            return "statement";
        case NODE_PROG:
            return "program";
        default:
            cerr << "shouldn't reach here, typeinfo";
            assert(0);
    }
    return "";
}

string TreeNode::opType2String (OperatorType type){
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
        default:
            cerr << "shouldn't reach here, typeinfo";
            assert(0);
    }
    return "";
}

string TreeNode::vFlag2String (VarFlag flag){
    switch(flag) {
        case VAR_COMMON:
            return "COMMON";
        case VAR_ADDRESS:
            return "ADDRESS";
        case VAR_POINTER:
            return "POINTER";
    }
    return "";
}