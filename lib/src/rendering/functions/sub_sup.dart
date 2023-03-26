import 'package:catex/src/lookup/context.dart';
import 'package:catex/src/rendering/group.dart';
import 'package:catex/src/rendering/rendering.dart';

/// Delegates rendering and sizing to its child.
///
/// The positioning of this has to be performed in the containing group node.
/// If there is no group node, there is no way to shift the child as there
/// is nothing to shift relative to.
///
/// See also:
///  * [RenderGroup]
class RenderSubSup extends RenderNode<NodeParentData> with SingleChildRenderNodeMixin {
  RenderSubSup(CaTeXContext context) : super(context);
}
