#ifndef TREE_H
#define TREE_H

#include "pch.h"
#include "type.h"
extern ofstream out;
enum NodeType
{
    NODE_CONST, 
    NODE_VAR,
    NODE_EXPR,
    NODE_TYPE,
    NODE_FUNC,
    NODE_STMT,
    NODE_PROG,
};

enum OperatorType
{
    OP_ASSIGN,
    OP_ADD,
    OP_SUB,
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
};

enum StmtType {
    STMT_FOR,
    STMT_SKIP,
    STMT_DECL,
    STMT_ASSIGN,
    STMT_SEQ,
    STMT_IF_ELSE,
    STMT_WHILE,
    STMT_PRINTF,
    STMT_SCANF,
}
;
enum VarFlag
{
    VAR_COMMON,
    VAR_ADDRESS,
    VAR_POINTER
};

struct TreeNode {
public:
    int nodeID;  // 用于作业的序号输出
    int lineno;
    NodeType nodeType;

    TreeNode* child = nullptr;
    TreeNode* sibling = nullptr;

    void addChild(TreeNode*);
    void addSibling(TreeNode*);
    
    void printNodeInfo();
    void printChildrenId();

    void printAST(); // 先输出自己 + 孩子们的id；再依次让每个孩子输出AST。
    void printSpecialInfo();

    void genNodeId();

public:
    OperatorType optype;  // 如果是表达式
    Type* type;  // 变量、类型、表达式结点，有类型。
    StmtType stype;
    VarFlag vflag;
    int int_val;
    char ch_val;
    bool b_val;
    string str_val;
    string var_name;
public:
    static string nodeType2String (NodeType type);
    static string opType2String (OperatorType type);
    static string sType2String (StmtType type);
    static string vFlag2String (VarFlag flag);

public:
    TreeNode(int lineno, NodeType type);
};

#endif