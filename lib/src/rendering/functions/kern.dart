import 'dart:ui';

import 'package:catex/src/lookup/context.dart';
import 'package:catex/src/parsing/functions/kern.dart';
import 'package:catex/src/rendering/group.dart';
import 'package:catex/src/rendering/rendering.dart';
import 'package:meta/meta.dart';

/// [RenderNode] for [KernNode].
class RenderKern extends RenderNode {
  /// Constructs a [RenderKern] given a [context].
  RenderKern(
    CaTeXContext context, {
    required this.space,
  })  : assert(space != null),
        super(context);

  /// Horizontal space of the kern in pixels.
  ///
  /// This can be a negative value. In that case, the kern shifts the next
  /// child forward in [RenderGroup].
  final double space;

  @override
  void configure() {
    // This works out of box as a complete kern implementation because the
    // renderSize is used in RenderGroup to determine spacing and the actual
    // RenderBox size is clamped to the constraints (:
    // This means that a negative size will result in a zero sized RenderBox.
    renderSize = Size(space, 0);
  }

  @override
  void render(Canvas canvas) {}
}
