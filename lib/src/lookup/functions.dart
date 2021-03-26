import 'package:catex/src/lookup/fonts.dart';
import 'package:catex/src/lookup/modes.dart';
import 'package:catex/src/lookup/styles.dart';
import 'package:catex/src/parsing/functions/boxed.dart';
import 'package:catex/src/parsing/functions/cancel.dart';
import 'package:catex/src/parsing/functions/color_box.dart';
import 'package:catex/src/parsing/functions/font.dart';
import 'package:catex/src/parsing/functions/frac.dart';
import 'package:catex/src/parsing/functions/hat.dart';
import 'package:catex/src/parsing/functions/kern.dart';
import 'package:catex/src/parsing/functions/raise_box.dart';
import 'package:catex/src/parsing/functions/sqrt.dart';
import 'package:catex/src/parsing/functions/styling.dart';
import 'package:catex/src/parsing/functions/sub_sup.dart';
import 'package:catex/src/parsing/functions/text.dart';
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
  /// `\frac{}{}` displays a fraction.
  frac,

  /// `\hat{}` displays a hat above its group.
  hat,

  /// `\tt{}` uses the [CaTeXFont.typewriter] font.
  tt,

  /// `\rm{}` uses the [CaTeXFont.main] font and a normal font weight and style.
  rm,

  /// `\sf{}` uses the [CaTeXFont.sansSerif] font.
  sf,

  /// `\bf{}` uses bold font weight.
  bf,

  /// `\it{}` uses the italic font style.
  it,

  /// `\cal{}` uses the [CaTeXFont.caligraphic] font.
  cal,

  /// `\textcolor{}{}` colors text.
  textColor,

  /// `_{}` puts its group into subscript.
  sub,

  /// `^{}` puts its group into superscript.
  sup,

  /// `\colorbox{}{}` draws a colored box around its group.
  colorBox,

  /// `\boxed{}` draws a box around its group.
  boxed,

  /// `\sqrt{}` displays a square root.
  sqrt,

  /// `\displaystyle` uses [CaTeXStyle.d].
  displayStyle,

  /// `\textstyle` uses [CaTeXStyle.t].
  textStyle,

  /// `\scriptstyle` uses [CaTeXStyle.s].
  scriptStyle,

  /// `\scriptscriptstyle` uses [CaTeXStyle.ss].
  scriptScriptStyle,

  /// `\kern{}` creates horizontal spacing.
  kern,

  /// `\raisebox{}{}` shifts text vertically.
  raiseBox,

  /// `\text{}` enters text mode.
  text,

  /// `\textnormal{}` enters text mode with the normal font.
  textNormal,

  /// `\textrm{}` uses a roman serif font in text mode.
  textRm,

  /// `\textsf{}` uses a serif font in text mode.
  textSf,

  /// `\texttt{}` uses a typewriter font in text mode.
  textTt,

  /// `\textbf{}` uses a bold font weight in text mode.
  textBf,

  /// `\textmd{}` uses medium font weight in text mode.
  textMd,

  /// `\textit{}` uses an italic font style in text mode.
  textIt,

  /// `\textit{}` uses an upright font style in text mode.
  textUp,

  /// `\mathbb{}` uses the [CaTeXFont.ams] font.
  mathbb,

  /// `\cancel{}` draws a slash from the top right to the bottom left corners.
  cancel,
}

/// Names, i.e. control sequences that correspond to
/// a CaTeX function. See [_lookupFunctionData] to find the
/// function definitions and explanations in the classes.
const supportedFunctionNames = <String, CaTeXFunction>{
  r'\frac': CaTeXFunction.frac,
  r'\hat': CaTeXFunction.hat,
  r'\tt': CaTeXFunction.tt,
  r'\rm': CaTeXFunction.rm,
  r'\sf': CaTeXFunction.sf,
  r'\bf': CaTeXFunction.bf,
  r'\it': CaTeXFunction.it,
  r'\cal': CaTeXFunction.cal,
  r'\text': CaTeXFunction.text,
  r'\textnormal': CaTeXFunction.textNormal,
  r'\textrm': CaTeXFunction.textRm,
  r'\textsf': CaTeXFunction.textSf,
  r'\texttt': CaTeXFunction.textTt,
  r'\textbf': CaTeXFunction.textBf,
  r'\textmd': CaTeXFunction.textMd,
  r'\textit': CaTeXFunction.textIt,
  r'\textup': CaTeXFunction.textUp,
  r'\textcolor': CaTeXFunction.textColor,
  '_': CaTeXFunction.sub,
  '^': CaTeXFunction.sup,
  r'\colorbox': CaTeXFunction.colorBox,
  r'\boxed': CaTeXFunction.boxed,
  r'\sqrt': CaTeXFunction.sqrt,
  r'\displaystyle': CaTeXFunction.displayStyle,
  r'\textstyle': CaTeXFunction.textStyle,
  r'\scriptstyle': CaTeXFunction.scriptStyle,
  r'\scriptscriptstyle': CaTeXFunction.scriptScriptStyle,
  r'\kern': CaTeXFunction.kern,
  r'\raisebox': CaTeXFunction.raiseBox,
  r'\mathbb': CaTeXFunction.mathbb,
  r'\cancel': CaTeXFunction.cancel,
};

/// CaTeX functions that are available in math mode.
const List<CaTeXFunction> supportedMathFunctions = [
  CaTeXFunction.frac,
  CaTeXFunction.hat,
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
  CaTeXFunction.displayStyle,
  CaTeXFunction.textStyle,
  CaTeXFunction.scriptStyle,
  CaTeXFunction.scriptScriptStyle,
  CaTeXFunction.kern,
  CaTeXFunction.raiseBox,
  CaTeXFunction.text,
  CaTeXFunction.textNormal,
  CaTeXFunction.textRm,
  CaTeXFunction.textSf,
  CaTeXFunction.textTt,
  CaTeXFunction.textBf,
  CaTeXFunction.textMd,
  CaTeXFunction.textIt,
  CaTeXFunction.textUp,
  CaTeXFunction.mathbb,
  CaTeXFunction.cancel,
];

/// CaTeX functions that are available in text mode.
const List<CaTeXFunction> supportedTextFunctions = [
  CaTeXFunction.tt,
  CaTeXFunction.rm,
  CaTeXFunction.sf,
  CaTeXFunction.bf,
  CaTeXFunction.it,
  CaTeXFunction.cal,
  CaTeXFunction.textColor,
  CaTeXFunction.colorBox,
  CaTeXFunction.boxed,
  CaTeXFunction.displayStyle,
  CaTeXFunction.textStyle,
  CaTeXFunction.scriptStyle,
  CaTeXFunction.scriptScriptStyle,
  CaTeXFunction.kern,
  CaTeXFunction.raiseBox,
  CaTeXFunction.text,
  CaTeXFunction.textNormal,
  CaTeXFunction.textRm,
  CaTeXFunction.textSf,
  CaTeXFunction.textTt,
  CaTeXFunction.textBf,
  CaTeXFunction.textMd,
  CaTeXFunction.textIt,
  CaTeXFunction.textUp,
];

/// Looks up the [FunctionNode] subclass for a given input.
///
/// Returns the node with the appropriate [FunctionProperties] if a function for
/// the given [context] is supported, i.e. the input matches a name in
/// [supportedFunctionNames] *and* this function is in [supportedMathFunctions]
/// in math mode or in [supportedTextFunctions]
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
    case CaTeXFunction.hat:
      return HatNode(context);
    case CaTeXFunction.frac:
      return FracNode(context);
    case CaTeXFunction.tt:
    case CaTeXFunction.rm:
    case CaTeXFunction.sf:
    case CaTeXFunction.bf:
    case CaTeXFunction.it:
    case CaTeXFunction.cal:
    case CaTeXFunction.mathbb:
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
    case CaTeXFunction.raiseBox:
      return RaiseBoxNode(context);
    case CaTeXFunction.kern:
      return KernNode(context);
    case CaTeXFunction.cancel:
      return CancelNode(context);
    case CaTeXFunction.displayStyle:
    case CaTeXFunction.textStyle:
    case CaTeXFunction.scriptStyle:
    case CaTeXFunction.scriptScriptStyle:
      return StylingNode(context);
    case CaTeXFunction.text:
    case CaTeXFunction.textNormal:
    case CaTeXFunction.textRm:
    case CaTeXFunction.textSf:
    case CaTeXFunction.textTt:
    case CaTeXFunction.textBf:
    case CaTeXFunction.textMd:
    case CaTeXFunction.textIt:
    case CaTeXFunction.textUp:
      return TextNode(context);
  }
  // Not adding a default clause will make
  // the IDE help to add missing clauses.
  return null;
}

/// Properties that every function defines, giving context about its use case.
///
/// A function defines this in its [FunctionNode].
class FunctionProperties {
  /// Constructs [FunctionProperties] from the number of [arguments] and
  /// a [greediness] value.
  const FunctionProperties({
    @required this.arguments,
    @required this.greediness,
  })  : assert(arguments != null),
        assert(greediness != null),
        assert(arguments > 0),
        assert(greediness > 0);

  /// Defines how many groups after itself a function will consume.
  final int arguments;

  /// Defines how greedy a function is to grab groups.
  ///
  /// The higher the greediness, the earlier a function will be
  /// allocated its arguments. For example, `\sqrt \frac 2 {3}` should
  /// produce a fraction inside of a square root. If functions were
  /// allocated their arguments from left to right, parsing would fail.
  final int greediness;
}

// todo: build proper solution
/// Workaround solution for entering text mode until text mode is properly
/// supported.
///
/// The parser uses this to determine whether it should include spaces or not.
/// In a proper solution, the parser should never do that.
const textModeSwitchingFunctions = <CaTeXFunction>[
  CaTeXFunction.text,
  CaTeXFunction.textNormal,
  CaTeXFunction.textRm,
  CaTeXFunction.textSf,
  CaTeXFunction.textTt,
  CaTeXFunction.textBf,
  CaTeXFunction.textMd,
  CaTeXFunction.textIt,
  CaTeXFunction.textUp,
];
