import 'package:catex/src/lookup/context.dart';
import 'package:catex/src/rendering/rendering.dart';

/// [RenderNode] for [TextNode].
class RenderText extends RenderNode with SingleChildRenderNodeMixin {
  /// Constructs a [RenderText] given a [context].
  RenderText(CaTeXContext context) : super(context);
}
