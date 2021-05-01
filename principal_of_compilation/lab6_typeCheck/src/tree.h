#ifndef TREE_H
#define TREE_H

#include "pch.h"
#include "type.h"
#include "symbol.h"
#include <typeinfo>
extern ofstream out;
using namespace std;

class TreeNode {
public:

    enum NodeType{
        NODE_NONE, 
        NODE_OP,
        NODE_EXPR,
        NODE_DECL,
        NODE_FUNCCALL,
        NODE_STMT,
    };

    int nodeID;  // 用于作业的序号输出
    int lineno;
    NodeType nodeType;
    Symbol* symbol;

    TreeNode* child = nullptr;
    TreeNode* sibling = nullptr;

    void addChild(TreeNode* node);
    void addSibling(TreeNode* node);
    virtual ~TreeNode() {}
    
    void printNodeInfo();
    void printChildrenId();

    void typeCheck(TreeNode* root);
    void printAST(); // 先输出自己 + 孩子们的id；再依次让每个孩子输出AST。
    virtual void printSpecialInfo();

    void genNodeId();
    static string getNodeTypeStr(NodeType type);
    TreeNode(int lineno, NodeType type);
};

class StmtNode : public TreeNode {
public:
    enum StmtType {
        STMT_FOR,
        STMT_SCOPE,
        STMT_RETURN,
        STMT_IF,
        STMT_IF_ELSE,
        STMT_WHILE,
        STMT_PRINTF,
        STMT_SCANF,
        STMT_FUNC,
        STMT_EMPTY,
    }
    ;
public:
    StmtNode (int lineno, StmtType type, std::initializer_list<TreeNode*> children=std::initializer_list<TreeNode*>());
    ~StmtNode() {}
    StmtType type;
    static string getStmtTypeStr(StmtType type);
    void printSpecialInfo();
};

class FunStmtNode : public StmtNode {
public:
    FunStmtNode(int lineno, Callable* symbol, std::initializer_list<TreeNode*> children);
    void printSpecialInfo();
};

class DeclNode : public TreeNode {
private:
    int arrayLength;
public:
    DeclNode (int lineno, Symbol *symbol);
    ~DeclNode() {}
    void printSpecialInfo();
    inline int getArrayLength () {return this->arrayLength;}
    void setArrayLength(string length);
};

class ExprNode : public TreeNode {
public:
    ExprNode (int lineno, Symbol* symbol);
    ExprNode (int lineno, Symbol::ValueType type, string value, bool isConstant = false);
    ~ExprNode() {}
    void printSpecialInfo();
};

class FuncCallNode : public ExprNode {
public:
    FuncCallNode (int lineno, Symbol* symbol, std::initializer_list<TreeNode*> children);
    ~FuncCallNode() {}
    void printSpecialInfo();
};

class OperatorNode: public ExprNode {
public:
    enum OperatorType
    {
        OP_ASSIGN,
        OP_ADD,
        OP_SUB,
        OP_UMINUS,
        OP_MULT,
        OP_DEV,
        OP_MOD,
        OP_DADD,
        OP_DSUB,
        OP_ADDASS,
        OP_SUBASS,
        OP_MULTASS,
        OP_DEVASS,
        OP_MODASS,
        OP_AND,
        OP_OR,
        OP_NOT,
        OP_BNOT,
        OP_BAND,
        OP_BOR,
        OP_XOR,
        OP_EQ,
        OP_L,
        OP_LEQ,
        OP_S,
        OP_SEQ,
        OP_NEQ,
        OP_SHL,
        OP_SHR,
        OP_BOOL,
        OP_TADDR,
    };
public:
    OperatorNode(int lineno, OperatorType type, std::initializer_list<TreeNode*> children);
    ~OperatorNode() {}
    OperatorType type;
    static string getOpTypeStr(OperatorType type);
    void printSpecialInfo();
};

class EmptyNode : public StmtNode {
public:
    EmptyNode(int lineno);
    void printSpecialInfo();
};

#endif