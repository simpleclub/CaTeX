import 'dart:ui';

import 'package:catex/src/lookup/context.dart';
import 'package:catex/src/parsing/functions/boxed.dart';
import 'package:catex/src/rendering/group.dart';
import 'package:catex/src/rendering/rendering.dart';

/// [RenderNode] for [BoxedNode].
class RenderBoxed extends RenderNode with SingleChildRenderNodeMixin {
  /// Constructs a [RenderBoxed] given a [context].
  RenderBoxed(CaTeXContext context) : super(context);

  Paint _borderPaint;

  @override
  void configure() {
    final childSize = sizeChildNode(child);
    // Add padding equal to a third of a character to both sides horizontally.
    final horizontalPadding = mockCharacterSize(context).width * 2 / 3,
        // Add a quarter of that as vertical padding.
        verticalPadding = horizontalPadding / 4;
    renderSize = Size(childSize.width + horizontalPadding,
        childSize.height + verticalPadding);
    child.positionNode(Offset(horizontalPadding / 2, verticalPadding / 2));

    _borderPaint = Paint()
      ..color = context.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(Offset.zero & size, _borderPaint);
    super.render(canvas); // Paint child;
  }
}
