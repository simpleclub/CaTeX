import 'dart:io';

import 'package:path/path.dart' as p;

const header = '''
/// This file was automatically generated - do not edit manually.
/// See `gen/macros.dart` instead.

const macros = <String, String>{''';

/// Writes the code for supported macros to a file called `macros.g.dart`.
///
/// The directory is determined by the path specified as the first argument.
Future<void> main(List<String> args) async {
  final file = File(p.join(args.first, 'macros.g.dart'));

  // This makes sure the code does not run for nothing.
  if (file.existsSync()) file.deleteSync();
  file.createSync();

  // ignore: omit_local_variable_types
  final List<String> lines = [...header.split('\\n')];
  final Map<String, String> macros = {};

  // This only supports rewrite macros, i.e. string to string mapping for now.
  void defineMacro(
    String name,
    String rewrite,
  ) {
    assert(
      name != null && rewrite != null && !macros.containsKey(name),
      'Input `defineMacro($name, $rewrite)` is invalid.',
    );

    macros[name] = rewrite;
  }

  // These are inspired by https://github.com/KaTeX/KaTeX/blob/c2e5a289c0245b15a5a7a0cc3041b9026cf4eb8c/src/macros.js
  // for now, however, it would in fact be nice if this could just be based
  // on that, i.e. if the macros could be copied for the most part.
  // This is not possible because KaTeX supports way more functionality than
  // CaTeX does.
  defineMacro("\\u00b7", "\\\\cdotp");
  defineMacro("\\u27C2", "\\\\perp");
  defineMacro("\\\\larr", "\\\\leftarrow");
  defineMacro("\\\\lArr", "\\\\Leftarrow");
  defineMacro("\\\\Larr", "\\\\Leftarrow");
  defineMacro("\\\\lrarr", "\\\\leftrightarrow");
  defineMacro("\\\\lrArr", "\\\\Leftrightarrow");
  defineMacro("\\\\Lrarr", "\\\\Leftrightarrow");
  defineMacro("\\\\infin", "\\\\infty");
  defineMacro("\\\\harr", "\\\\leftrightarrow");
  defineMacro("\\\\hArr", "\\\\Leftrightarrow");
  defineMacro("\\\\Harr", "\\\\Leftrightarrow");
  defineMacro("\\\\hearts", "\\\\heartsuit");

  defineMacro("\\\\TeX",
      "\\\\rm{T\\\\kern{-.1667em}\\\\raisebox{-.5ex}{E}\\\\kern{-.125em}X}");
  defineMacro(
      "\\\\LaTeX",
      "\\\\rm{L\\\\kern{-.36em}\\\\raisebox{.205em}{\\\\scriptstyle A} "
          "\\\\kern{-.15em}\\\\TeX}");
  defineMacro(
      "\\\\KaTeX",
      "\\\\rm{K\\\\kern{-.17em}\\\\raisebox{0.205em}{\\\\scriptstyle A} "
          "\\\\kern{-.15em}\\\\TeX}");
  defineMacro(
      "\\\\CaTeX",
      "\\\\rm{\\\\raisebox{-0.05em}C\\\\kern{-.12em}\\\\raisebox{0.2em}"
          "{\\\\scriptstyle A}\\\\kern{-.15em}\\\\TeX}");

  for (final entry in macros.entries) {
    lines.add(" '${entry.key}': '${entry.value}',");
  }
  lines.add('};\n');

  await file.writeAsString(lines.join('\n'));
}
