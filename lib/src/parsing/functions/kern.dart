import 'package:catex/src/lookup/context.dart';
import 'package:catex/src/lookup/functions.dart';
import 'package:catex/src/lookup/sizing.dart';
import 'package:catex/src/parsing/parsing.dart';
import 'package:catex/src/rendering/functions/kern.dart';
import 'package:catex/src/widgets.dart';

/// [ParsingNode] for [CaTeXFunction.raiseBox].
class KernNode extends SingleChildNode<RenderKern>
    with FunctionNode<RenderKern> {
  /// Constructs a [KernNode] from a [context].
  KernNode(ParsingContext context) : super(context);

  @override
  FunctionProperties get properties =>
      const FunctionProperties(arguments: 1, greediness: 1);

  @override
  NodeWidget<RenderKern> configureWidget(CaTeXContext context) {
    super.configureWidget(context);

    // A kern does not render anything - it only creates horizontal spacing.
    return NodeWidget(
      context,
      createRenderNode,
    );
  }

  @override
  RenderKern createRenderNode(CaTeXContext context) {
    return RenderKern(
      context,
      space: child!.context.input.trim().parseToPx(context.textSize)!,
    );
  }
}
