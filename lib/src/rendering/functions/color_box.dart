import 'dart:ui';

import 'package:catex/src/lookup/context.dart';
import 'package:catex/src/parsing/functions/color_box.dart';
import 'package:catex/src/rendering/group.dart';
import 'package:catex/src/rendering/rendering.dart';

/// [RenderNode] for [ColorBoxNode].
class RenderColorBox extends RenderNode with SingleChildRenderNodeMixin {
  /// Constructs a [RenderColorBox] given a [context].
  RenderColorBox(CaTeXContext context) : super(context);

  Paint _backgroundPaint;

  @override
  void configure() {
    final childSize = sizeChildNode(child);
    // Add padding equal to a third of a character to both sides horizontally.
    final horizontalPadding = mockCharacterSize(context).width * 2 / 3;
    renderSize = Size(childSize.width + horizontalPadding, childSize.height);
    child.positionNode(Offset(horizontalPadding / 2, 0));

    _backgroundPaint = Paint()..color = context.color;
  }

  @override
  void render(Canvas canvas) {
    // Draw the color as the background of the box.
    canvas.drawRect(Offset.zero & size, _backgroundPaint);
    super.render(canvas); // Paint child;
  }
}
