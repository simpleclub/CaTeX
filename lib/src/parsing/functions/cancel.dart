import 'package:catex/src/lookup/context.dart';
import 'package:catex/src/lookup/functions.dart';
import 'package:catex/src/parsing/parsing.dart';
import 'package:catex/src/rendering/functions/cancel.dart';
import 'package:catex/src/widgets.dart';

// todo: probably create an accent node to group accents together
// todo| https://github.com/KaTeX/KaTeX/blob/fa8fbc0c18e5e3fe98f347ceed3a48699d561c72/src/functions/accent.js
/// [ParsingNode] for [CaTeXFunction.cancel].
class CancelNode extends SingleChildNode<RenderCancel>
    with FunctionNode<RenderCancel> {
  /// Constructs a [CancelNode] given a [context].
  CancelNode(ParsingContext context) : super(context);

  @override
  FunctionProperties get properties =>
      const FunctionProperties(arguments: 1, greediness: 1);

  @override
  NodeWidget<RenderCancel> configureWidget(CaTeXContext context) {
    super.configureWidget(context);

    return NodeWidget(
      context,
      createRenderNode,
      children: [
        child!.createWidget(context),
      ],
    );
  }

  @override
  RenderCancel createRenderNode(CaTeXContext context) {
    return RenderCancel(context);
  }
}
