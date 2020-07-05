import 'package:catex/src/lookup/context.dart';
import 'package:catex/src/lookup/functions.dart';
import 'package:catex/src/parsing/parsing.dart';
import 'package:catex/src/rendering/functions/hat.dart';
import 'package:catex/src/rendering/rendering.dart';
import 'package:catex/src/widgets.dart';

// todo: probably create an accent node to group accents together
// todo| https://github.com/KaTeX/KaTeX/blob/fa8fbc0c18e5e3fe98f347ceed3a48699d561c72/src/functions/accent.js
/// [ParsingNode] for [CaTeXFunction.hat].
class HatNode extends SingleChildNode with FunctionNode {
  /// Constructs a [HatNode] given a [context].
  HatNode(ParsingContext context) : super(context);

  @override
  FunctionProperties get properties =>
      const FunctionProperties(arguments: 1, greediness: 1);

  @override
  NodeWidget configureWidget(CaTeXContext context) {
    super.configureWidget(context);

    return NodeWidget(
      context,
      createRenderNode,
      children: [
        child.createWidget(context),
      ],
    );
  }

  @override
  RenderNode<NodeParentData> createRenderNode(CaTeXContext context) {
    return RenderHat(context);
  }
}
