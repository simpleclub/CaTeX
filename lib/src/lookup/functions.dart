import 'package:catex/src/lookup/modes.dart';
import 'package:catex/src/parsing/functions/boxed.dart';
import 'package:catex/src/parsing/functions/color_box.dart';
import 'package:catex/src/parsing/functions/font.dart';
import 'package:catex/src/parsing/functions/frac.dart';
import 'package:catex/src/parsing/functions/sqrt.dart';
import 'package:catex/src/parsing/functions/sub_sup.dart';
import 'package:catex/src/parsing/functions/text_color.dart';
import 'package:catex/src/parsing/parsing.dart';
import 'package:flutter/foundation.dart';

/// Enumeration of supported CaTeX function.
///
/// This provides easy use in code. There is probably a way
/// to reduce the number of lists in this file by writing some helper
/// functions. However, these would not be constant.
/// Instead, code generation to create these as constants without that much
/// manual work seems reasonable.
/// Either way, the conversion will be a simple process.
enum CaTeXFunction {
  frac,
  tt,
  rm,
  sf,
  bf,
  it,
  cal,
  textColor,
  sub,
  sup,
  colorBox,
  boxed,
  sqrt,
}

/// Names, i.e. control sequences that correspond to
/// a CaTeX function. See [_lookupFunctionData] to find the
/// function definitions and explanations in the classes.
const supportedFunctionNames = <String, CaTeXFunction>{
  r'\frac': CaTeXFunction.frac,
  r'\tt': CaTeXFunction.tt,
  r'\rm': CaTeXFunction.rm,
  r'\sf': CaTeXFunction.sf,
  r'\bf': CaTeXFunction.bf,
  r'\it': CaTeXFunction.it,
  r'\cal': CaTeXFunction.cal,
  r'\textcolor': CaTeXFunction.textColor,
  r'_': CaTeXFunction.sub,
  r'^': CaTeXFunction.sup,
  r'\colorbox': CaTeXFunction.colorBox,
  r'\boxed': CaTeXFunction.boxed,
  r'\sqrt': CaTeXFunction.sqrt,
};

const List<CaTeXFunction>

    /// CaTeX functions that are available in math mode.
    supportedMathFunctions = [
      CaTeXFunction.frac,
      CaTeXFunction.tt,
      CaTeXFunction.rm,
      CaTeXFunction.sf,
      CaTeXFunction.bf,
      CaTeXFunction.it,
      CaTeXFunction.cal,
      CaTeXFunction.textColor,
      CaTeXFunction.sub,
      CaTeXFunction.sup,
      CaTeXFunction.colorBox,
      CaTeXFunction.boxed,
      CaTeXFunction.sqrt,
    ],

    /// CaTeX functions that are available in text mode.
    supportedTextFunctions = [
      CaTeXFunction.tt,
      CaTeXFunction.rm,
      CaTeXFunction.sf,
      CaTeXFunction.bf,
      CaTeXFunction.it,
      CaTeXFunction.cal,
      CaTeXFunction.textColor,
      CaTeXFunction.colorBox,
      CaTeXFunction.boxed,
    ];

/// Looks up the [FunctionNode] subclass for a given input.
///
/// Returns the node with the appropriate [FunctionProperties] if a function for
/// the given [context] is supported, i.e. the input matches a name in [supportedFunctionNames]
/// *and* this function is in [supportedMathFunctions] in math mode or in [supportedTextFunctions]
/// in text mode. Otherwise, this function returns `null`.
FunctionNode lookupFunction(ParsingContext context) {
  final input = context.input,
      mode = context.mode,
      function = supportedFunctionNames[input];

  switch (mode) {
    case CaTeXMode.math:
      if (!supportedMathFunctions.contains(function)) return null;
      break;
    case CaTeXMode.text:
      if (!supportedTextFunctions.contains(function)) return null;
      break;
  }

  switch (function) {
    case CaTeXFunction.frac:
      return FracNode(context);
    case CaTeXFunction.tt:
    case CaTeXFunction.rm:
    case CaTeXFunction.sf:
    case CaTeXFunction.bf:
    case CaTeXFunction.it:
    case CaTeXFunction.cal:
      return FontNode(context);
    case CaTeXFunction.textColor:
      return TextColorNode(context);
    case CaTeXFunction.sub:
    case CaTeXFunction.sup:
      return SubSupNode(context);
    case CaTeXFunction.colorBox:
      return ColorBoxNode(context);
    case CaTeXFunction.boxed:
      return BoxedNode(context);
    case CaTeXFunction.sqrt:
      return SqrtNode(context);
  }
  // Not adding a default clause will make
  // the IDE help to add missing clauses.
  return null;
}

class FunctionProperties {
  const FunctionProperties(
      {@required this.arguments, @required this.greediness})
      : assert(arguments != null),
        assert(greediness != null),
        assert(arguments > 0),
        assert(greediness > 0);

  final int

      /// Defines how many groups after itself a function will consume.
      arguments,

      /// Defines how greedy a function is to grab groups.
      ///
      /// The higher the greediness, the earlier a function will be allocated its arguments.
      /// For example, `\sqrt \frac 2 {3}` should produce a fraction inside of a square root.
      /// If functions were allocated their arguments from left to right, parsing would fail.
      greediness;
}
