import 'package:catex/src/lookup/context.dart';
import 'package:catex/src/lookup/functions.dart';
import 'package:catex/src/parsing/parsing.dart';
import 'package:catex/src/rendering/functions/frac.dart';
import 'package:catex/src/widgets.dart';

class FracNode extends MultiChildNode<RenderFrac>
    with FunctionNode<RenderFrac> {
  FracNode(ParsingContext context) : super(context);

  @override
  FunctionProperties get properties =>
      const FunctionProperties(arguments: 2, greediness: 2);

  @override
  NodeWidget<RenderFrac> configureWidget(CaTeXContext context) {
    super.configureWidget(context);

    final childrenContext = context.copyWith(
      // todo: properly determine size reduction
      // (some systems are already partially setup but unsupported).
      textSize: context.textSize! * .78,
    );

    return NodeWidget(
      context,
      createRenderNode,
      children: [
        for (final child in children) child!.createWidget(childrenContext),
      ],
    );
  }

  @override
  RenderFrac createRenderNode(CaTeXContext context) {
    return RenderFrac(context);
  }
}
