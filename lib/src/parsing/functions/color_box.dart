import 'package:catex/src/lookup/colors.dart';
import 'package:catex/src/lookup/context.dart';
import 'package:catex/src/lookup/functions.dart';
import 'package:catex/src/parsing/parsing.dart';
import 'package:catex/src/rendering/functions/color_box.dart';
import 'package:catex/src/widgets.dart';
import 'package:flutter/cupertino.dart';

/// [ParsingNode] for [CaTeXFunction.colorBox].
class ColorBoxNode extends MultiChildNode<RenderColorBox> with FunctionNode {
  /// Constructs a [ColorBoxNode] given a [context].
  ColorBoxNode(ParsingContext context) : super(context);

  @override
  FunctionProperties get properties =>
      const FunctionProperties(arguments: 2, greediness: 1);

  @override
  NodeWidget<RenderColorBox> configureWidget(CaTeXContext context) {
    super.configureWidget(context);

    return NodeWidget(
      context,
      createRenderNode,
      // Only take the color from the first child and render the second one.
      children: [
        children[1]!.createWidget(context.copyWith(
          // Letters in a color box are not italic by default.
          // Hence, we need to override the font style.
          fontStyle: FontStyle.normal,
        )),
      ],
    );
  }

  @override
  RenderColorBox createRenderNode(CaTeXContext context) {
    return RenderColorBox(context.copyWith(
      // Only modify the context of the actual box node with the color
      // because the children are unaffected by the colored background.
      color: parseColor(children[0]!.context.input),
    ));
  }
}
