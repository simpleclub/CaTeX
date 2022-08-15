import 'dart:ui';

import 'package:catex/src/lookup/characters.dart';
import 'package:catex/src/lookup/context.dart';
import 'package:catex/src/lookup/symbols.dart';
import 'package:catex/src/parsing/character.dart';
import 'package:catex/src/parsing/symbols.dart';
import 'package:catex/src/rendering/rendering.dart';
import 'package:catex/src/rendering/symbols.dart';
import 'package:flutter/rendering.dart';

/// [RenderNode] for [CharacterNode].
class RenderCharacter extends RenderNode {
  /// Constructs a [CharacterNode] from a [context] and an optional [symbol].
  RenderCharacter(
    CaTeXContext context, {
    this.symbol,
  }) : super(context);

  /// Stores the symbol resolved from the [context]'s input for a rendering
  /// workaround.
  ///
  /// Specifically, some characters are also special symbol, but they
  /// apparently need to be handled very differently from normal symbols, i.e.
  /// a [SymbolNode] cannot handle it properly.
  ///
  /// This means that [RenderSymbol] does *not* use this property and instead
  /// populates the [CaTeXContext.input] with the symbol. Any other
  /// [RenderCharacter] will pass a [symbol] explicitly if the input is to be
  /// rendered using a different unicode character.
  final SymbolData? symbol;

  late TextPainter _painter;

  @override
  void configure() {
    _painter = TypesetPainter(context.copyWith(
      // todo: solve this properly
      input: symbol?.unicode,
    ));
    _painter.layout();

    renderSize = _painter.size;
  }

  @override
  void render(Canvas canvas) {
    _painter.paint(canvas, Offset.zero);
  }
}

/// Text painter for all nodes that paint characters in a typeset way.
class TypesetPainter extends TextPainter {
  /// Constructs a typeset [TextPainter] given a [context].
  TypesetPainter(CaTeXContext context)
      : assert(context != null),
        super(
          text: TextSpan(
            text: context.input,
            style: TextStyle(
              color: context.color,
              fontFamily: context.fontFamily,
              fontSize: context.textSize,
              fontWeight: _resolveFontWeight(context),
              fontStyle: _resolveFontStyle(context),
            ),
          ),
          textDirection: TextDirection.ltr,
        );
}

/// Specifies special behavior for certain characters.
///
/// This can be overridden by functions, e.g. \rm.
FontStyle? _resolveFontStyle(CaTeXContext context) {
  if (context.fontStyle != null) return context.fontStyle;

  if (CharacterCategory.letter.matches(context.input!)) {
    return FontStyle.italic;
  }

  return FontStyle.normal;
}

/// Specifies special behavior for certain characters.
///
/// This can be overridden by functions, e.g. \rm.
FontWeight? _resolveFontWeight(CaTeXContext context) {
  if (context.fontWeight != null) return context.fontWeight;

  return FontWeight.normal;
}
