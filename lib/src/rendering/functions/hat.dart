import 'dart:math';
import 'dart:ui';

import 'package:catex/src/lookup/context.dart';
import 'package:catex/src/lookup/modes.dart';
import 'package:catex/src/lookup/symbols.dart';
import 'package:catex/src/rendering/character.dart';
import 'package:catex/src/rendering/rendering.dart';
import 'package:flutter/rendering.dart';

class RenderHat extends RenderNode with SingleChildRenderNodeMixin {
  RenderHat(CaTeXContext context) : super(context);

  TextPainter _hatPainter;

  @override
  void configure() {
    _hatPainter = TypesetPainter(
        context.copyWith(input: symbols[CaTeXMode.math][r'\hat'].unicode));

    _hatPainter.layout();
    final childSize = sizeChildNode(child),
        hatSize = _hatPainter.size,
        height = max(hatSize.height, childSize.height);

    child.positionNode(Offset(0, height - childSize.height));
    renderSize = Size(childSize.width, height);
  }

  @override
  void render(Canvas canvas) {
    paintChildNode(child);
    _hatPainter.paint(canvas, Offset(child.size.width / 4, 0));
  }
}
