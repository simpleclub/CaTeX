import 'dart:math';
import 'dart:ui';

import 'package:catex/src/lookup/context.dart';
import 'package:catex/src/lookup/modes.dart';
import 'package:catex/src/lookup/symbols.dart';
import 'package:catex/src/parsing/functions/hat.dart';
import 'package:catex/src/rendering/character.dart';
import 'package:catex/src/rendering/rendering.dart';
import 'package:flutter/rendering.dart';

// todo: this has many inaccuracies; refer to
// todo| https://github.com/KaTeX/KaTeX/blob/fa8fbc0c18e5e3fe98f347ceed3a48699d561c72/src/functions/accent.js
/// [RenderNode] for [HatNode].
class RenderHat extends RenderNode with SingleChildRenderNodeMixin {
  /// Constructs a [HatNode] given a [context].
  RenderHat(CaTeXContext context) : super(context);

  TextPainter _hatPainter;

  @override
  void configure() {
    _hatPainter = TypesetPainter(context.copyWith(
      input: symbols[CaTeXMode.math][r'\hat'].unicode,
    ));
    // todo: remove this workaround and implement accents properly
    // todo| see above
    final upperCase = child.context.input.trim().isNotEmpty &&
        child.context.input.toUpperCase() == child.context.input;

    _hatPainter.layout();
    final childSize = sizeChildNode(child),
        hatSize = _hatPainter.size,
        // todo: width needs to be only the bounds of the hat
        width = max(hatSize.width, childSize.width),
        height = max(hatSize.height, childSize.height) +
            (upperCase ? hatSize.height / 10 : 0);

    child.positionNode(Offset(
        0, height - childSize.height + (upperCase ? hatSize.height / 10 : 0)));
    renderSize = Size(width, height);
  }

  @override
  void render(Canvas canvas) {
    paintChildNode(child);

    _hatPainter.paint(
      canvas,
      Offset(
        max(0, child.renderSize.width / 2 - _hatPainter.size.width / 3),
        0,
      ),
    );
  }
}
