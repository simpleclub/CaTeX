import 'package:catex/src/lookup/context.dart';
import 'package:catex/src/lookup/functions.dart';
import 'package:catex/src/parsing/parsing.dart';
import 'package:catex/src/rendering/functions/styling.dart';
import 'package:catex/src/widgets.dart';

/// [ParsingNode] for [CaTeXFunction.raiseBox].
class StylingNode extends SingleChildNode<RenderStyling>
    with FunctionNode<RenderStyling> {
  /// Constructs a [StylingNode] from a [context].
  StylingNode(ParsingContext context) : super(context);

  @override
  FunctionProperties get properties =>
      const FunctionProperties(arguments: 1, greediness: 1);

  @override
  NodeWidget<RenderStyling> configureWidget(CaTeXContext context) {
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
  RenderStyling createRenderNode(CaTeXContext context) {
    return RenderStyling(context);
  }
}
