import 'token.dart';
import 'environment.dart';
import 'expression.dart';
import 'value.dart';

/// 抽象的访问者模式，包含访问语句的抽象语法树的接口
///
/// 表达式和语句的区别在于：1，语句以";"结尾，而表达式没有";""
///
/// 2，访问语句返回void，访问表达式返回dynamic
///
/// 3，访问语句称作execute，访问表达式称作evaluate
///
/// 4，语句包含表达式，而表达式不包含语句
abstract class StmtVisitor {
  /// 导入语句
  dynamic visitImportStmt(ImportStmt stmt);

  /// 变量声明语句
  dynamic visitVarDeclStmt(VarDeclStmt stmt);

  /// 表达式语句
  dynamic visitExprStmt(ExprStmt stmt);

  /// 语句块：用于既允许单条语句，又允许语句块的场合，比如IfStatment
  dynamic visitBlockStmt(BlockStmt stmt);

  /// 返回语句
  dynamic visitReturnStmt(ReturnStmt stmt);

  /// If语句
  dynamic visitIfStmt(IfStmt stmt);

  /// While语句
  dynamic visitWhileStmt(WhileStmt stmt);

  /// Break语句
  dynamic visitBreakStmt(BreakStmt stmt);

  /// Continue语句
  dynamic visitContinueStmt(ContinueStmt stmt);

  /// 函数声明和定义
  dynamic visitFuncDeclStmt(FuncDeclStmt stmt);

  /// 类
  dynamic visitClassDeclStmt(ClassDeclStmt stmt);
}

abstract class Stmt {
  String get type;

  dynamic accept(StmtVisitor visitor);
}

class ImportStmt extends Stmt {
  @override
  String get type => hetuEnv.lexicon.importStmt;

  @override
  dynamic accept(StmtVisitor visitor) => visitor.visitImportStmt(this);

  final String location;

  final String nameSpace;

  ImportStmt(this.location, {this.nameSpace});
}

class VarDeclStmt extends Stmt {
  @override
  String get type => hetuEnv.lexicon.varStmt;

  @override
  dynamic accept(StmtVisitor visitor) => visitor.visitVarDeclStmt(this);

  final Token name;

  final HT_Type declType;

  final Expr initializer;

  final bool typeInferrence;

  final bool isMutable;

  final bool isExtern;

  final bool isStatic;

  VarDeclStmt(
    this.name, {
    this.declType,
    this.initializer,
    this.typeInferrence = true,
    this.isMutable = true,
    this.isExtern = false,
    this.isStatic = false,
  });
}

class ExprStmt extends Stmt {
  @override
  String get type => hetuEnv.lexicon.exprStmt;

  @override
  dynamic accept(StmtVisitor visitor) => visitor.visitExprStmt(this);

  /// 可能是单独的变量名，也可能是一个表达式作为函数使用
  final Expr expr;

  ExprStmt(this.expr);
}

class BlockStmt extends Stmt {
  @override
  String get type => hetuEnv.lexicon.blockStmt;

  @override
  dynamic accept(StmtVisitor visitor) => visitor.visitBlockStmt(this);

  final List<Stmt> block;

  BlockStmt(this.block);
}

class ReturnStmt extends Stmt {
  @override
  String get type => hetuEnv.lexicon.returnStmt;

  @override
  dynamic accept(StmtVisitor visitor) => visitor.visitReturnStmt(this);

  final Token keyword;

  final Expr expr;

  ReturnStmt(this.keyword, this.expr);
}

class IfStmt extends Stmt {
  @override
  String get type => hetuEnv.lexicon.ifStmt;

  @override
  dynamic accept(StmtVisitor visitor) => visitor.visitIfStmt(this);

  final Expr condition;

  final Stmt thenBranch;

  final Stmt elseBranch;

  IfStmt(this.condition, this.thenBranch, this.elseBranch);
}

class WhileStmt extends Stmt {
  @override
  String get type => hetuEnv.lexicon.whileStmt;

  @override
  dynamic accept(StmtVisitor visitor) => visitor.visitWhileStmt(this);

  final Expr condition;

  final Stmt loop;

  WhileStmt(this.condition, this.loop);
}

class BreakStmt extends Stmt {
  @override
  String get type => hetuEnv.lexicon.breakStmt;

  @override
  dynamic accept(StmtVisitor visitor) => visitor.visitBreakStmt(this);
}

class ContinueStmt extends Stmt {
  @override
  String get type => hetuEnv.lexicon.continueStmt;

  @override
  dynamic accept(StmtVisitor visitor) => visitor.visitContinueStmt(this);
}

enum FuncStmtType {
  normal,
  procedure,
  method,
  getter,
  setter,
  constructor,
}

class FuncDeclStmt extends Stmt {
  @override
  String get type => hetuEnv.lexicon.funcStmt;

  @override
  dynamic accept(StmtVisitor visitor) => visitor.visitFuncDeclStmt(this);

  final Token keyword;

  final String name;

  final List<String> typeParams = [];

  final HT_Type returnType;

  String _internalName;
  String get internalName => _internalName;

  final String className;

  final List<VarDeclStmt> params;

  final int arity;

  List<Stmt> definition;

  final bool isExtern;

  final bool isStatic;

  final bool isConst;

  final FuncStmtType funcType;

  FuncDeclStmt(this.keyword, this.name, this.returnType, this.params,
      {List<String> typeParams,
      this.arity = 0,
      this.definition,
      this.className,
      this.isExtern = false,
      this.isStatic = false,
      this.isConst = false,
      this.funcType = FuncStmtType.normal}) {
    this.definition ??= <Stmt>[];
    if (funcType == FuncStmtType.constructor) {
      _internalName = hetuEnv.lexicon.constructor + name;
    } else if (funcType == FuncStmtType.getter) {
      _internalName = hetuEnv.lexicon.getter + name;
    } else if (funcType == FuncStmtType.setter) {
      _internalName = hetuEnv.lexicon.setter + name;
    } else {
      _internalName = name;
    }

    if (typeParams != null) this.typeParams.addAll(typeParams);
  }
}

class ClassDeclStmt extends Stmt {
  @override
  String get type => hetuEnv.lexicon.classStmt;

  @override
  dynamic accept(StmtVisitor visitor) => visitor.visitClassDeclStmt(this);

  final Token keyword;

  final String name;

  final List<String> typeParams = [];

  final HT_Type superClass;

  final List<VarDeclStmt> variables;

  final List<FuncDeclStmt> methods;

  ClassDeclStmt(this.keyword, this.name, this.superClass, this.variables, this.methods, {List<String> typeParams}) {
    if (typeParams != null) this.typeParams.addAll(typeParams);
  }
}
