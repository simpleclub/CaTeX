import 'package:catex/src/lookup/colors.dart';
import 'package:catex/src/lookup/context.dart';
import 'package:catex/src/lookup/functions.dart';
import 'package:catex/src/parsing/parsing.dart';
import 'package:catex/src/rendering/functions/text_color.dart';
import 'package:catex/src/widgets.dart';

/// [ParsingNode] for [CaTeXFunction.textColor].
class TextColorNode extends MultiChildNode<RenderTextColor> with FunctionNode {
  /// Constructs a [TextColorNode] given a [context].
  TextColorNode(ParsingContext context) : super(context);

  @override
  FunctionProperties get properties =>
      const FunctionProperties(arguments: 2, greediness: 1);

  @override
  NodeWidget<RenderTextColor> configureWidget(CaTeXContext context) {
    super.configureWidget(context);

    return NodeWidget(
      context,
      createRenderNode,
      // The node takes two children, however, the widget
      // only has a single child because one child is used
      // for configuration only.
      children: [
        children[1]!.createWidget(context.copyWith(
          color: parseColor(children[0]!.context.input),
        )),
      ],
    );
  }

  @override
  RenderTextColor createRenderNode(CaTeXContext context) {
    return RenderTextColor(context);
  }
}
