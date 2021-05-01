#include "scope.h"

ScopeNode::ScopeNode(int lineno, const string &name, Symbol *symbol) : lineno(lineno), name(name), symbol(symbol)
{

}

Scope::Scope()
{
    this->pushScope();
}

Symbol *Scope::findSymbol(const string &name)
{
    for (const auto& l: scopeStack) {
        for (const auto& n: l) {
            if(n.name == name)
                return n.symbol;
        }
    }
    return nullptr;
}

bool Scope::insertSymbol(const string &name, int lineno, Symbol *symbol)
{
    auto& current = scopeStack.front();
    for (const auto& n: current) {
        if(n.name == name)
            return false;
    }
    current.push_back(ScopeNode(lineno, name, symbol));
    if (currFunc) {
        funcTable[currFunc].push_back(symbol);
    }
    return true;
}

void Scope::pushScope()
{
    scopeStack.push_front(ScopeList());
    currFuncCount++;
}

void Scope::pushScope(list<ScopeNode> ScopeList){
    this->scopeStack.push_front(ScopeList);
}

list<ScopeNode> Scope::popScope()
{
    if (--currFuncCount == 0) {
        currFunc = nullptr;
    }
    list<ScopeNode> ret = scopeStack.front();
    scopeStack.pop_front();
    return ret;
}

list<list<ScopeNode>> Scope:: getScopeStack(){
    return scopeStack;
}