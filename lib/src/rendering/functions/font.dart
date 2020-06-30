import 'package:catex/src/lookup/context.dart';
import 'package:catex/src/parsing/functions/font.dart';
import 'package:catex/src/rendering/rendering.dart';

/// [RenderNode] for [FontNode].
class RenderFont extends RenderNode with SingleChildRenderNodeMixin {
  /// Constructs a [RenderFont] given a [context].
  RenderFont(CaTeXContext context) : super(context);
}
