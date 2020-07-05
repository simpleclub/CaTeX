import 'dart:math';
import 'dart:ui';

import 'package:catex/src/lookup/context.dart';
import 'package:catex/src/lookup/modes.dart';
import 'package:catex/src/lookup/symbols.dart';
import 'package:catex/src/rendering/character.dart';
import 'package:catex/src/rendering/rendering.dart';
import 'package:flutter/rendering.dart';

class RenderSqrt extends RenderNode with SingleChildRenderNodeMixin {
  RenderSqrt(CaTeXContext context) : super(context);

  TextPainter _surdPainter;
  Paint _linePaint;

  @override
  void configure() {
    _linePaint = Paint()
      ..color = context.color
      ..strokeWidth = context.textSize / 20
      ..strokeCap = StrokeCap.square;
    _surdPainter = TypesetPainter(
      context.copyWith(input: symbols[CaTeXMode.math][r'\surd'].unicode),
    );

    _surdPainter.layout();
    final childSize = sizeChildNode(child),
        surdSize = _surdPainter.size,
        height = max(surdSize.height, childSize.height);

    child.positionNode(Offset(surdSize.width, height - childSize.height));
    renderSize = Size(surdSize.width + childSize.width, height);
  }

  @override
  void render(Canvas canvas) {
    paintChildNode(child);
    _surdPainter.paint(canvas, Offset.zero);

    // Draws an overline.
    final h =
        (_surdPainter.size.height - context.textSize + _linePaint.strokeWidth) /
            2;
    canvas.drawLine(
      // todo
      Offset(_surdPainter.size.width, h),
      Offset(renderSize.width, h),
      _linePaint,
    );
  }
}
