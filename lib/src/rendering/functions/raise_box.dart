import 'package:catex/src/lookup/context.dart';
import 'package:catex/src/parsing/functions/raise_box.dart';
import 'package:catex/src/rendering/rendering.dart';
import 'package:meta/meta.dart';

/// [RenderNode] for [RaiseBoxNode].
class RenderRaiseBox extends RenderNode with SingleChildRenderNodeMixin {
  /// Constructs a [RenderRaiseBox] given a [context].
  RenderRaiseBox(
    CaTeXContext context, {
    @required this.shift,
  })  : assert(shift != null),
        super(context);

  /// Vertical shift of the raise box in pixels.
  ///
  /// This has the opposite sign of the raise value specified in the input
  /// as the box is supposed to **raise** based on the value.
  final double shift;
}
