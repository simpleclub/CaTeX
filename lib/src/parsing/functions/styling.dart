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

    final function = supportedFunctionNames[context.input!];

    double sizeFactor = 1.0;

    // todo: styling is not yet supported
    // This is only a workaround to make the logo work.
    // Note that styles actually switch and do not just impact sizes by a
    // constant factor → this implementation is complete garbage (:
    switch (function) {
      case CaTeXFunction.scriptStyle:
        // Eyeballed for the logo.
        sizeFactor = .8;
        break;
      default:

      /// noop
    }

    return NodeWidget(
      context,
      createRenderNode,
      children: [
        child!.createWidget(context.copyWith(
          textSize: sizeFactor * context.textSize!,
        )),
      ],
    );
  }

  @override
  RenderStyling createRenderNode(CaTeXContext context) {
    return RenderStyling(context);
  }
}
