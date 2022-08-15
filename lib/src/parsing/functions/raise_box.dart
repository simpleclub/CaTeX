import 'package:catex/src/lookup/context.dart';
import 'package:catex/src/lookup/functions.dart';
import 'package:catex/src/lookup/sizing.dart';
import 'package:catex/src/parsing/parsing.dart';
import 'package:catex/src/rendering/functions/raise_box.dart';
import 'package:catex/src/widgets.dart';

/// [ParsingNode] for [CaTeXFunction.raiseBox].
class RaiseBoxNode extends MultiChildNode<RenderRaiseBox>
    with FunctionNode<RenderRaiseBox> {
  /// Constructs a [RaiseBoxNode] from a [context].
  RaiseBoxNode(ParsingContext context) : super(context);

  @override
  FunctionProperties get properties =>
      const FunctionProperties(arguments: 2, greediness: 1);

  @override
  NodeWidget<RenderRaiseBox> configureWidget(CaTeXContext context) {
    super.configureWidget(context);

    return NodeWidget(
      context,
      createRenderNode,
      children: [
        children[1]!.createWidget(context),
      ],
    );
  }

  @override
  RenderRaiseBox createRenderNode(CaTeXContext context) {
    return RenderRaiseBox(
      context,
      // Negative sign because the box should be raised by the amount.
      shift: -children[0]!.context.input.trim().parseToPx(context.textSize)!,
    );
  }
}
