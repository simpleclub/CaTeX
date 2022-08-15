import 'package:catex/src/lookup/context.dart';
import 'package:catex/src/lookup/functions.dart';
import 'package:catex/src/parsing/parsing.dart';
import 'package:catex/src/rendering/functions/sub_sup.dart';
import 'package:catex/src/widgets.dart';

class SubSupNode extends SingleChildNode<RenderSubSup>
    with FunctionNode<RenderSubSup> {
  SubSupNode(ParsingContext context) : super(context);

  @override
  FunctionProperties get properties =>
      const FunctionProperties(arguments: 1, greediness: 1);

  @override
  NodeWidget<RenderSubSup> configureWidget(CaTeXContext context) {
    super.configureWidget(context);

    return NodeWidget(
      context,
      createRenderNode,
      children: [
        child!.createWidget(context.copyWith(
          // todo: properly determine size reduction
          // (some systems are already partially setup but unsupported).
          textSize: context.textSize! * .6,
        )),
      ],
    );
  }

  @override
  RenderSubSup createRenderNode(CaTeXContext context) {
    return RenderSubSup(context);
  }
}
