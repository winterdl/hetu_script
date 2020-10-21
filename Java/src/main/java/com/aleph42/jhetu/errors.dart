import 'common.java';

class HS_Break {}

class HS_Continue {}

class HS_Error {
  String message;
  int line;
  int column;
  String fileName;

  HS_Error(this.message, this.line, this.column, this.fileName);

  @override
  String toString() {
    var result = StringBuffer();
    result.write('Hetu error:');
    if (fileName != null) {
      result.write(' [file: $fileName]');
    }
    if ((line != null) && (column != null)) {
      result.write(' [line: $line, column: $column]');
    }
    result.writeln('\n${message}');
    return result.toString();
  }

  static final _warnings = <String>[];

  static void add(String message) => _warnings.add(message);

  static void output() {
    for (var msg in _warnings) {
      print('Warning: $msg');
    }
  }

  static void clear() => _warnings.clear();
}

class HSErr_Unsupport extends HS_Error {
  HSErr_Unsupport(String symbol, int line, int column, String fileName)
      : super('${HS_Common.errorUnsupport} "${symbol}"', line, column, fileName);
}

class HSErr_Expected extends HS_Error {
  HSErr_Expected(String expected, String met, int line, int column, String fileName)
      : super('"${expected != '\n' ? expected : '\\n'}" ${HS_Common.errorExpected} "${met != '\n' ? met : '\\n'}"',
            line, column, fileName);
}

class HSErr_Unexpected extends HS_Error {
  HSErr_Unexpected(String symbol, int line, int column, String fileName)
      : super('${HS_Common.errorUnexpected} "${symbol != '\n' ? symbol : '\\n'}"', line, column, fileName);
}

class HSErr_Private extends HS_Error {
  HSErr_Private(String symbol, int line, int column, String fileName)
      : super('${HS_Common.errorPrivate} "${symbol}"', line, column, fileName);
}

class HSErr_Initialized extends HS_Error {
  HSErr_Initialized(String symbol, int line, int column, String fileName)
      : super('"${symbol}" ${HS_Common.errorInitialized}', line, column, fileName);
}

class HSErr_Undefined extends HS_Error {
  HSErr_Undefined(String symbol, int line, int column, String fileName)
      : super('${HS_Common.errorUndefined} "${symbol}"', line, column, fileName);
}

class HSErr_UndefinedOperator extends HS_Error {
  HSErr_UndefinedOperator(String symbol1, String op, int line, int column, String fileName)
      : super('${HS_Common.errorUndefinedOperator} "${symbol1}" "${op}"', line, column, fileName);
}

class HSErr_UndefinedBinaryOperator extends HS_Error {
  HSErr_UndefinedBinaryOperator(String symbol1, String symbol2, String op, int line, int column, String fileName)
      : super('${HS_Common.errorUndefinedOperator} "${symbol1}" "${op}" "${symbol2}"', line, column, fileName);
}

class HSErr_Declared extends HS_Error {
  HSErr_Declared(String symbol, int line, int column, String fileName)
      : super('"${symbol}" ${HS_Common.errorDeclared}', line, column, fileName);
}

class HSErr_Defined extends HS_Error {
  HSErr_Defined(String symbol, int line, int column, String fileName)
      : super('"${symbol}" ${HS_Common.errorDefined}', line, column, fileName);
}

class HSErr_Range extends HS_Error {
  HSErr_Range(int length, int line, int column, String fileName)
      : super('${HS_Common.errorRange} "${length}"', line, column, fileName);
}

class HSErr_InvalidLeftValue extends HS_Error {
  HSErr_InvalidLeftValue(String symbol, int line, int column, String fileName)
      : super('${HS_Common.errorInvalidLeftValue} "${symbol}"', line, column, fileName);
}

class HSErr_Callable extends HS_Error {
  HSErr_Callable(String symbol, int line, int column, String fileName)
      : super('"${symbol}" ${HS_Common.errorCallable}', line, column, fileName);
}

class HSErr_UndefinedMember extends HS_Error {
  HSErr_UndefinedMember(String symbol, String type, int line, int column, String fileName)
      : super('"${symbol}" ${HS_Common.errorUndefinedMember} "${type}"', line, column, fileName);
}

class HSErr_Condition extends HS_Error {
  HSErr_Condition(int line, int column, String fileName) : super(HS_Common.errorCondition, line, column, fileName);
}

class HSErr_MissingFuncDef extends HS_Error {
  HSErr_MissingFuncDef(String symbol, int line, int column, String fileName)
      : super('${HS_Common.errorMissingFuncDef} "${symbol}"', line, column, fileName);
}

class HSErr_Get extends HS_Error {
  HSErr_Get(String symbol, int line, int column, String fileName)
      : super('"${symbol}" ${HS_Common.errorGet}', line, column, fileName);
}

class HSErr_SubGet extends HS_Error {
  HSErr_SubGet(String symbol, int line, int column, String fileName)
      : super('"${symbol}" ${HS_Common.errorSubGet}', line, column, fileName);
}

class HSErr_Extends extends HS_Error {
  HSErr_Extends(String symbol, int line, int column, String fileName)
      : super('"${symbol}" ${HS_Common.errorExtends}', line, column, fileName);
}

class HSErr_Setter extends HS_Error {
  HSErr_Setter(int line, int column, String fileName) : super('${HS_Common.errorSetter}', line, column, fileName);
}

class HSErr_NullObject extends HS_Error {
  HSErr_NullObject(String symbol, int line, int column, String fileName)
      : super('"${symbol}" ${HS_Common.errorNullObject}', line, column, fileName);
}

class HSErr_Type extends HS_Error {
  HSErr_Type(String symbol, String value_type, String decl_value, int line, int column, String fileName)
      : super(
            '${HS_Common.errorType1} "${symbol}" ${HS_Common.errorOfType} "${decl_value}" ${HS_Common.errorType2} "${value_type}"',
            line,
            column,
            fileName);
}

class HSErr_Mutable extends HS_Error {
  HSErr_Mutable(String symbol, int line, int column, String fileName)
      : super('"${symbol}" ${HS_Common.errorMutable}', line, column, fileName);
}

class HSErr_ArgType extends HS_Error {
  HSErr_ArgType(String symbol, String assign_value, String decl_value, int line, int column, String fileName)
      : super(
            '${HS_Common.errorArgType1} "${assign_value}" ${HS_Common.errorOfType} "${assign_value}" ${HS_Common.errorArgType2} "${decl_value}"',
            line,
            column,
            fileName);
}

class HSErr_ReturnType extends HS_Error {
  HSErr_ReturnType(
      String returned_type, String func_name, String decl_return_type, int line, int column, String fileName)
      : super(
            '"${returned_type}" ${HS_Common.errorReturnType2}'
            ' "${func_name}" ${HS_Common.errorReturnType3} "${decl_return_type}"',
            line,
            column,
            fileName);
}

class HSErr_Arity extends HS_Error {
  HSErr_Arity(String symbol, int args_count, int params_count, int line, int column, String fileName)
      : super('${HS_Common.errorArity1} [${args_count}] ${HS_Common.errorArity2} [${symbol}] [${params_count}]', line,
            column, fileName);
}