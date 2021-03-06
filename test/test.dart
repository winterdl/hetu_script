import 'package:test/test.dart';
import 'package:hetu_script/src/lexer.dart';

void main() {
  final lexer = Lexer();
  group('hetu test', () {
    test('lexer', () {
      expect(
        lexer
            .lex("// this is a comment\n"
                "var _Words: String = 'hello world'\n"
                "let n_42 = 42\n"
                "void main() {\n"
                "print(_Words);\n"
                "}")
            .toString(),
        "[var, _Words, :, String, =, 'hello world', let, n_42, =, 42, void, main, (, ), {, print, (, _Words, ), ;, }]",
      );
    });
  });
}
