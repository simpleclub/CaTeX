import 'package:catex/src/lookup/context.dart';
import 'package:catex/src/lookup/functions.dart';
import 'package:catex/src/parsing/parsing.dart';
import 'package:catex/src/rendering/functions/hat.dart';
import 'package:catex/src/rendering/rendering.dart';
import 'package:catex/src/widgets.dart';

class HatNode extends SingleChildNode with FunctionNode {
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
