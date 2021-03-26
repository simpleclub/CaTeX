import 'dart:ui';

import 'package:catex/src/lookup/context.dart';
import 'package:catex/src/rendering/rendering.dart';

/// [RenderNode] for [CancelNode].
class RenderCancel extends RenderNode {
  /// Constructs a [RenderCancel] given a [context].
  RenderCancel(CaTeXContext context) : super(context);

  Paint _linePaint;

  @override
  void configure() {
    final childSize = sizeChildNode(children[0]);

    renderSize = childSize;

    _linePaint = Paint()
      ..strokeWidth = 2
      ..color = context.color;
  }

  @override
  void render(Canvas canvas) {
    paintChildNode(children[0]);
    final double horizontalPadding = renderSize.width * .05;
    final double verticalPadding = renderSize.height * .05;

    canvas.drawLine(
      Offset(renderSize.width - horizontalPadding, verticalPadding),
      Offset(horizontalPadding, renderSize.height - verticalPadding),
      _linePaint,
    );
  }
}
