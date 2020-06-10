import 'dart:ui';

import 'package:catex/src/lookup/colors.dart';
import 'package:catex/src/lookup/context.dart';
import 'package:catex/src/lookup/exception.dart';
import 'package:catex/src/lookup/functions.dart';
import 'package:catex/src/parsing/parsing.dart';
import 'package:catex/src/rendering/functions/text_color.dart';
import 'package:catex/src/widgets.dart';
import 'package:flutter/foundation.dart';

class TextColorNode extends MultiChildNode<RenderTextColor> with FunctionNode {
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
      // only has a single child because one child is used for configuration only.
      children: [
        children[1].createWidget(context.copyWith(
          color: colorFromChildNode(children[0], context: context),
        )),
      ],
    );
  }

  @override
  RenderTextColor createRenderNode(CaTeXContext context) {
    return RenderTextColor(context);
  }
}

/// Retrieves a color from [supportedColors] for the color string defined by
/// the child node (which should be a group node in order for this to work).
///
/// Throws a [ConfigurationException] if no color is found.
Color colorFromChildNode(ParsingNode child, {@required CaTeXContext context}) {
  assert(child != null);
  assert(context != null);

  final colorString = child.context.input.trim(),
      color = supportedColors[colorString];
  if (color == null) {
    throw ConfigurationException(
      reason: 'Unknown color: $colorString',
      input: context.input,
    );
  }
  return color;
}
