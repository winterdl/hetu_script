import 'environment.dart';

class HT_Break {}

class HT_Continue {}

class HT_Error {
  String message;
  int line;
  int column;
  String fileName;

  HT_Error(this.message, this.line, this.column, this.fileName);

  @override
  String toString() {
    var result = StringBuffer();
    result.write('hetu error:');
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

class HTErr_Unsupport extends HT_Error {
  HTErr_Unsupport(String symbol, int line, int column, String fileName)
      : super('${hetuEnv.lexicon.errorUnsupport} "${symbol}"', line, column, fileName);
}

class HTErr_Expected extends HT_Error {
  HTErr_Expected(String expected, String met, int line, int column, String fileName)
      : super(
            '"${expected != '\n' ? expected : '\\n'}" ${hetuEnv.lexicon.errorExpected} "${met != '\n' ? met : '\\n'}"',
            line,
            column,
            fileName);
}

class HTErr_Unexpected extends HT_Error {
  HTErr_Unexpected(String symbol, int line, int column, String fileName)
      : super('${hetuEnv.lexicon.errorUnexpected} "${symbol != '\n' ? symbol : '\\n'}"', line, column, fileName);
}

class HTErr_Private extends HT_Error {
  HTErr_Private(String symbol, int line, int column, String fileName)
      : super('${hetuEnv.lexicon.errorPrivate} "${symbol}"', line, column, fileName);
}

class HTErr_Initialized extends HT_Error {
  HTErr_Initialized(String symbol, int line, int column, String fileName)
      : super('"${symbol}" ${hetuEnv.lexicon.errorInitialized}', line, column, fileName);
}

class HTErr_Undefined extends HT_Error {
  HTErr_Undefined(String symbol, int line, int column, String fileName)
      : super('${hetuEnv.lexicon.errorUndefined} "${symbol}"', line, column, fileName);
}

class HTErr_UndefinedOperator extends HT_Error {
  HTErr_UndefinedOperator(String symbol1, String op, int line, int column, String fileName)
      : super('${hetuEnv.lexicon.errorUndefinedOperator} "${symbol1}" "${op}"', line, column, fileName);
}

class HTErr_UndefinedBinaryOperator extends HT_Error {
  HTErr_UndefinedBinaryOperator(String symbol1, String symbol2, String op, int line, int column, String fileName)
      : super('${hetuEnv.lexicon.errorUndefinedOperator} "${symbol1}" "${op}" "${symbol2}"', line, column, fileName);
}

class HTErr_Declared extends HT_Error {
  HTErr_Declared(String symbol, int line, int column, String fileName)
      : super('"${symbol}" ${hetuEnv.lexicon.errorDeclared}', line, column, fileName);
}

class HTErr_Defined extends HT_Error {
  HTErr_Defined(String symbol, int line, int column, String fileName)
      : super('"${symbol}" ${hetuEnv.lexicon.errorDefined}', line, column, fileName);
}

class HTErr_Range extends HT_Error {
  HTErr_Range(int length, int line, int column, String fileName)
      : super('${hetuEnv.lexicon.errorRange} "${length}"', line, column, fileName);
}

class HTErr_InvalidLeftValue extends HT_Error {
  HTErr_InvalidLeftValue(String symbol, int line, int column, String fileName)
      : super('${hetuEnv.lexicon.errorInvalidLeftValue} "${symbol}"', line, column, fileName);
}

class HTErr_Callable extends HT_Error {
  HTErr_Callable(String symbol, int line, int column, String fileName)
      : super('"${symbol}" ${hetuEnv.lexicon.errorCallable}', line, column, fileName);
}

class HTErr_UndefinedMember extends HT_Error {
  HTErr_UndefinedMember(String symbol, String type, int line, int column, String fileName)
      : super('"${symbol}" ${hetuEnv.lexicon.errorUndefinedMember} "${type}"', line, column, fileName);
}

class HTErr_Condition extends HT_Error {
  HTErr_Condition(int line, int column, String fileName)
      : super(hetuEnv.lexicon.errorCondition, line, column, fileName);
}

class HTErr_MissingFuncDef extends HT_Error {
  HTErr_MissingFuncDef(String symbol, int line, int column, String fileName)
      : super('${hetuEnv.lexicon.errorMissingFuncDef} "${symbol}"', line, column, fileName);
}

class HTErr_Get extends HT_Error {
  HTErr_Get(String symbol, int line, int column, String fileName)
      : super('"${symbol}" ${hetuEnv.lexicon.errorGet}', line, column, fileName);
}

class HTErr_SubGet extends HT_Error {
  HTErr_SubGet(String symbol, int line, int column, String fileName)
      : super('"${symbol}" ${hetuEnv.lexicon.errorSubGet}', line, column, fileName);
}

class HTErr_Extends extends HT_Error {
  HTErr_Extends(String symbol, int line, int column, String fileName)
      : super('"${symbol}" ${hetuEnv.lexicon.errorExtends}', line, column, fileName);
}

class HTErr_Setter extends HT_Error {
  HTErr_Setter(int line, int column, String fileName) : super('${hetuEnv.lexicon.errorSetter}', line, column, fileName);
}

class HTErr_NullObject extends HT_Error {
  HTErr_NullObject(String symbol, int line, int column, String fileName)
      : super('"${symbol}" ${hetuEnv.lexicon.errorNullObject}', line, column, fileName);
}

class HTErr_Type extends HT_Error {
  HTErr_Type(String symbol, String value_type, String decl_value, int line, int column, String fileName)
      : super(
            '${hetuEnv.lexicon.errorType1} "${symbol}" ${hetuEnv.lexicon.errorOfType} "${decl_value}" ${hetuEnv.lexicon.errorType2} "${value_type}"',
            line,
            column,
            fileName);
}

class HTErr_Mutable extends HT_Error {
  HTErr_Mutable(String symbol, int line, int column, String fileName)
      : super('"${symbol}" ${hetuEnv.lexicon.errorMutable}', line, column, fileName);
}

class HTErr_NotType extends HT_Error {
  HTErr_NotType(String symbol, int line, int column, String fileName)
      : super('"${symbol}" ${hetuEnv.lexicon.errorNotType}', line, column, fileName);
}

class HTErr_ArgType extends HT_Error {
  HTErr_ArgType(String symbol, String assign_value, String decl_value, int line, int column, String fileName)
      : super(
            '${hetuEnv.lexicon.errorArgType1} "${assign_value}" ${hetuEnv.lexicon.errorOfType} "${assign_value}" ${hetuEnv.lexicon.errorArgType2} "${decl_value}"',
            line,
            column,
            fileName);
}

class HTErr_ReturnType extends HT_Error {
  HTErr_ReturnType(
      String returned_type, String func_name, String decl_return_type, int line, int column, String fileName)
      : super(
            '"${returned_type}" ${hetuEnv.lexicon.errorReturnType2}'
            ' "${func_name}" ${hetuEnv.lexicon.errorReturnType3} "${decl_return_type}"',
            line,
            column,
            fileName);
}

class HTErr_Arity extends HT_Error {
  HTErr_Arity(String symbol, int args_count, int params_count, int line, int column, String fileName)
      : super(
            '${hetuEnv.lexicon.errorArity1} [${args_count}] ${hetuEnv.lexicon.errorArity2} [${symbol}] [${params_count}]',
            line,
            column,
            fileName);
}
