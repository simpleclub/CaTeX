import 'package:catex/src/lookup/context.dart';
import 'package:catex/src/parsing/functions/styling.dart';
import 'package:catex/src/rendering/rendering.dart';

/// [RenderNode] for [StylingNode].
class RenderStyling extends RenderNode with SingleChildRenderNodeMixin {
  /// Constructs a [RenderStyling] given a [context].
  RenderStyling(CaTeXContext context) : super(context);
}
