import 'dart:ui';

import 'package:catex/src/lookup/characters.dart';
import 'package:catex/src/lookup/context.dart';
import 'package:catex/src/rendering/rendering.dart';
import 'package:flutter/rendering.dart';

class RenderCharacter extends RenderNode {
  RenderCharacter(CaTeXContext context) : super(context);

  TextPainter _painter;

  @override
  void configure() {
    _painter = TypesetPainter(context);
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
FontStyle _resolveFontStyle(CaTeXContext context) {
  if (context.fontStyle != null) return context.fontStyle;

  if (CharacterCategory.letter.matches(context.input)) {
    return FontStyle.italic;
  }

  return FontStyle.normal;
}

/// Specifies special behavior for certain characters.
///
/// This can be overridden by functions, e.g. \rm.
FontWeight _resolveFontWeight(CaTeXContext context) {
  if (context.fontWeight != null) return context.fontWeight;

  return FontWeight.normal;
}
