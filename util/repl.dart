import 'dart:io';

import 'package:hetu_script/hetu_script.dart';

const cli_help = '''

  Hetu Script Command-line Tool
  Version: 0.0.1
  Usage:

  hetu [option] [file_name] [invoke_name]

  If invoke_name is provided, will switch to program style interpretation.
  Otherwise interpret file as a function.

  options:
  -r, --repl                            enter REPL mode
        ''';

void main(List<String> args) async {
  try {
    var interpreter = await HetuEnv.init();

    dynamic result;
    if (args.isNotEmpty) {
      if ((args.first == '--help') || (args.first == '-h')) {
        print(cli_help);
      } else if ((args.first == '--repl') || (args.first == '-r')) {
        stdout.write('\x1B]0;'
            'Hetu Script Read-Evaluate-Print-Loop Tool'
            'Version: 0.0.1'
            '\x07'
            'Enter your code to evaluate.\n'
            'Enter \'\\\' for multiline, enter \'quit\' to quit.\n');
        var quit = false;

        while (!quit) {
          stdout.write('>>>');
          String input = stdin.readLineSync();

          if ((input == 'exit') || (input == 'quit') || (input == 'close') || (input == 'end')) {
            quit = true;
          } else {
            if (input.endsWith('\\')) {
              input += '\n' + stdin.readLineSync();
            }

            try {
              result = interpreter.eval(input, style: ParseStyle.function);
              if (result != null) print(result);
            } catch (e) {
              print(e);
            }
          }
        }
      } else if (args.first == '-s') {
        result = interpreter.evalf(args.first, style: ParseStyle.function);
      } else {
        result = interpreter.evalf(args.first,
            style: ParseStyle.library, invokeFunc: hetuEnv.lexicon.defaultProgramMainFunc);
      }
      print(result);
    } else {
      print(cli_help);
    }
  } catch (e) {
    print(e);
  }
}
