import 'errors.dart';
import 'expression.dart';
import 'statement.dart';
import 'token.dart';
import 'common.dart';
import 'interpreter.dart';

//> function-type
enum _FunctionType {
  none,
  normal,
  constructor,
  method,
}

enum _ClassType {
  none,
  normal,
  subClass,
}

/// 负责对语句列表进行分析，并生成变量作用域
class Resolver implements ExprVisitor, StmtVisitor {
  /// 代码块列表，每个代码块包含一个字典：key：变量标识符，value：变量是否已初始化
  var _blocks = <Map<String, bool>>[];
  Interpreter _context;
  _FunctionType _curFuncType = _FunctionType.none;
  _ClassType _curClassType = _ClassType.none;

  void _beginBlock() => _blocks.add(<String, bool>{});
  void _endBlock() => _blocks.removeLast();

  void _declare(Token varTok, {bool define = false}) {
    if (_blocks.isNotEmpty) {
      var block = _blocks.last;

      if (block.containsKey(varTok.lexeme)) {
        throw HSErr_Defined(varTok.lexeme, varTok.line, varTok.column);
      }
      block[varTok.lexeme] = define;
    }
  }

  void _define(String name) {
    if (_blocks.isNotEmpty) {
      _blocks.last[name] = true;
    }
  }

  void _addLocal(Expr expr, String varname) {
    for (var i = _blocks.length - 1; i >= 0; --i) {
      if (_blocks[i].containsKey(varname)) {
        var distance = _blocks.length - 1 - i;
        _context.addLocal(expr, distance);
        return;
      }
    }

    //print('$varname not found in local.');
    // Not found. Assume it is global.
  }

  void resolve(List<Stmt> statements, {Interpreter interpreter}) {
    if (statements != null) {
      _context = interpreter ?? globalInterpreter;
      for (var stmt in statements) {
        _resolveStmt(stmt);
      }
    }
  }

  void _resolveExpr(Expr expr) => expr.accept(this);
  void _resolveStmt(Stmt stmt) => stmt.accept(this);

  void _resolveFunction(FuncStmt stmt, _FunctionType type) {
    var enclosingFunctionType = _curFuncType;
    _curFuncType = type;

    _beginBlock();
    for (var param in stmt.params) {
      _declare(param.varname, define: true);
    }
    resolve(stmt.definition, interpreter: _context);
    _endBlock();
    _curFuncType = enclosingFunctionType;
  }

  /// 字面量并没有任何变量需要解析，因此这里留空
  @override
  dynamic visitLiteralExpr(LiteralExpr expr) {}

  @override
  dynamic visitVarExpr(VarExpr expr) {
    if (_blocks.isNotEmpty && _blocks.last[expr.name] == false) {
      throw HSErr_Undefined(expr.name.lexeme, expr.line, expr.column);
    }

    _addLocal(expr, expr.name.lexeme);
  }

  @override
  dynamic visitGroupExpr(GroupExpr expr) => _resolveExpr(expr.expr);

  @override
  dynamic visitUnaryExpr(UnaryExpr expr) {
    _resolveExpr(expr.value);
  }

  @override
  dynamic visitBinaryExpr(BinaryExpr expr) {
    _resolveExpr(expr.left);
    _resolveExpr(expr.right);
  }

  @override
  dynamic visitCallExpr(CallExpr expr) {
    _resolveExpr(expr.callee);

    for (var arg in expr.args) {
      _resolveExpr(arg);
    }
  }

  @override
  dynamic visitAssignExpr(AssignExpr expr) {
    _resolveExpr(expr.value);
    _addLocal(expr, expr.variable.lexeme);
    return null;
  }

  @override
  dynamic visitSubGetExpr(SubGetExpr expr) {}

  @override
  dynamic visitSubSetExpr(SubSetExpr expr) {}

  @override
  dynamic visitMemberGetExpr(MemberGetExpr expr) {
    _resolveExpr(expr.collection);
  }

  @override
  void visitMemberSetExpr(MemberSetExpr expr) {
    _resolveExpr(expr.collection);
    _resolveExpr(expr.value);
  }

  @override
  dynamic visitImportStmt(ImportStmt stmt) {}

  @override
  void visitVarStmt(VarStmt stmt) {
    if (stmt.initializer != null) {
      _resolveExpr(stmt.initializer);
      _declare(stmt.varname, define: true);
    } else {
      _define(stmt.varname.lexeme);
    }
    return null;
  }

  @override
  void visitExprStmt(ExprStmt stmt) => _resolveExpr(stmt.expr);

  @override
  void visitBlockStmt(BlockStmt stmt) {
    _beginBlock();
    resolve(stmt.block);
    _endBlock();
  }

  @override
  void visitReturnStmt(ReturnStmt stmt) {
    if (_curFuncType == _FunctionType.none) {
      throw HSErr_Unexpected(stmt.keyword.lexeme, stmt.keyword.line, stmt.keyword.column);
    }

    if (stmt.expr != null) {
      if (_curFuncType == _FunctionType.constructor) {
        throw HSErr_Unexpected(stmt.keyword.lexeme, stmt.keyword.line, stmt.keyword.column);
      }
      _resolveExpr(stmt.expr);
    }
  }

  @override
  void visitIfStmt(IfStmt stmt) {
    _resolveExpr(stmt.condition);
    _resolveStmt(stmt.thenBranch);
    if (stmt.elseBranch != null) {
      _resolveStmt(stmt.elseBranch);
    }
  }

  @override
  void visitWhileStmt(WhileStmt stmt) {
    _resolveExpr(stmt.condition);
    _resolveStmt(stmt.loop);
  }

  @override
  void visitBreakStmt(BreakStmt stmt) {}

  @override
  void visitFuncStmt(FuncStmt stmt) {
    if (!stmt.isConstructor) {
      _declare(stmt.name, define: true);
      _resolveFunction(stmt, _FunctionType.normal);
    } else {
      _resolveFunction(stmt, _FunctionType.constructor);
    }
  }

  @override
  void visitClassStmt(ClassStmt stmt) {
    _ClassType enclosingClass = _curClassType;

    _declare(stmt.name, define: true);

    if (stmt.superClass != null) {
      if (stmt.name.lexeme == stmt.superClass.name.lexeme) {
        throw HSErr_Unexpected(stmt.superClass.name.lexeme, stmt.superClass.name.line, stmt.superClass.name.column);
      }

      _resolveExpr(stmt.superClass);
      _beginBlock();
      _blocks.last[HS_Common.Super] = true;

      _curClassType = _ClassType.subClass;
    } else {
      _curClassType = _ClassType.normal;
    }

    _beginBlock();
    _blocks.last[HS_Common.This] = true;

    for (var method in stmt.methods) {
      if (method.isConstructor) {
        _resolveFunction(method, _FunctionType.constructor);
      } else {
        _resolveFunction(method, _FunctionType.method);
      }
    }

    for (var variable in stmt.variables) {
      visitVarStmt(variable);
    }

    _endBlock();

    if (stmt.superClass != null) _endBlock();

    _curClassType = enclosingClass;
  }

  @override
  void visitThisExpr(ThisExpr expr) {
    if (_curClassType == _ClassType.none) {
      throw HSErr_Unexpected(expr.keyword.lexeme, expr.line, expr.column);
    }

    _addLocal(expr, expr.keyword.lexeme);
  }
}
