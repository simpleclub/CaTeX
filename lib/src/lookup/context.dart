import 'dart:ui';

import 'package:catex/src/lookup/styles.dart';

/// Context storing variables that are passed down the widget tree
/// when creating widgets from parsed CaTeX input.
///
/// This matches the inherent tree structure of TeX quite well.
/// It is based on https://github.com/KaTeX/KaTeX/blob/fa8fbc0c18e5e3fe98f347ceed3a48699d561c72/src/Options.js.
class CaTeXContext {
  /// Constructs a [CaTeXContext] from its properties.
  const CaTeXContext({
    this.input,
    this.style,
    this.color,
    this.size,
    this.textSize,
    this.fontFamily,
    this.fontWeight,
    this.fontStyle,
  });

  /// The input for the context.
  ///
  /// This will be parts of the whole input given to CaTeX.
  final String? input;

  // todo: [style] is unsupported.
  // ignore: public_member_api_docs
  final CaTeXStyle? style;

  /// The color of rendered output.
  ///
  /// This controls the color for both font characters and other rendered
  /// output that is part of the symbols.
  final Color? color;

  // todo: [size] is unsupported.
  // ignore: public_member_api_docs
  final double? size;

  /// Size used for the rendered symbols.
  final double? textSize;

  /// Font family used for the rendered characters.
  final String? fontFamily;

  /// [FontWeight] used for the rendered characters.
  final FontWeight? fontWeight;

  /// [FontStyle] used for the rendered characters.
  final FontStyle? fontStyle;

  /// Copies the context with overridden properties.
  CaTeXContext copyWith({
    String? input,
    CaTeXStyle? style,
    Color? color,
    double? size,
    double? textSize,
    String? fontFamily,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
  }) =>
      CaTeXContext(
        input: input ?? this.input,
        style: style ?? this.style,
        color: color ?? this.color,
        size: size ?? this.size,
        textSize: textSize ?? this.textSize,
        fontFamily: fontFamily ?? this.fontFamily,
        fontWeight: fontWeight ?? this.fontWeight,
        fontStyle: fontStyle ?? this.fontStyle,
      );

  @override
  bool operator ==(dynamic other) {
    if (identical(other, this)) return true;

    if (other is CaTeXContext) {
      return other.input == input &&
          other.style == style &&
          other.color == color &&
          other.size == size &&
          other.textSize == textSize &&
          other.fontFamily == fontFamily &&
          other.fontWeight == fontWeight &&
          other.fontStyle == fontStyle;
    }
    return false;
  }

  @override
  int get hashCode =>
      input.hashCode ^
      style.hashCode ^
      color.hashCode ^
      size.hashCode ^
      textSize.hashCode ^
      fontFamily.hashCode ^
      fontWeight.hashCode ^
      fontStyle.hashCode;
}

// todo(creativecreatorormaybenot): integrate this KaTeX implementation.
//const sizeStyleMap = [
//  // Each element contains [textsize, scriptsize, scriptscriptsize].
//  // The size mappings are taken from TeX with \normalsize=10pt.
//  [1, 1, 1],    // size1: [5, 5, 5]              \tiny
//  [2, 1, 1],    // size2: [6, 5, 5]
//  [3, 1, 1],    // size3: [7, 5, 5]              \scriptsize
//  [4, 2, 1],    // size4: [8, 6, 5]              \footnotesize
//  [5, 2, 1],    // size5: [9, 6, 5]              \small
//  [6, 3, 1],    // size6: [10, 7, 5]             \normalsize
//  [7, 4, 2],    // size7: [12, 8, 6]             \large
//  [8, 6, 3],    // size8: [14.4, 10, 7]          \Large
//  [9, 7, 6],    // size9: [17.28, 12, 10]        \LARGE
//  [10, 8, 7],   // size10: [20.74, 14.4, 12]     \huge
//  [11, 10, 9],  // size11: [24.88, 20.74, 17.28] \HUGE
//];
//
//const sizeMultipliers = [
//  // fontMetrics.js:getGlobalMetrics also uses size indexes, so if
//  // you change size indexes, change that function.
//  0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.2, 1.44, 1.728, 2.074, 2.488,
//];
//
//const sizeAtStyle = function(size: number, style: StyleInterface): number {
//return style.size < 2 ? size : sizeStyleMap[size - 1][style.size - 1];
//};
