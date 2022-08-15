import 'dart:ui';

import 'package:catex/src/lookup/context.dart';
import 'package:catex/src/lookup/fonts.dart';
import 'package:catex/src/lookup/functions.dart';
import 'package:catex/src/parsing/parsing.dart';
import 'package:catex/src/rendering/functions/font.dart';
import 'package:catex/src/widgets.dart';

class FontNode extends SingleChildNode<RenderFont>
    implements FunctionNode<RenderFont> {
  FontNode(ParsingContext context) : super(context);

  @override
  FunctionProperties get properties =>
      const FunctionProperties(arguments: 1, greediness: 1);

  @override
  NodeWidget<RenderFont> configureWidget(CaTeXContext context) {
    super.configureWidget(context);

    final function = supportedFunctionNames[context.input!];

    FontWeight? weight;
    FontStyle? style;
    String? family;

    // The different functions override different parts of the font style.
    switch (function) {
      case CaTeXFunction.tt:
        family = CaTeXFont.typewriter.family;
        break;
      case CaTeXFunction.rm:
        weight = FontWeight.normal;
        style = FontStyle.normal;
        family = CaTeXFont.main.family;
        break;
      case CaTeXFunction.sf:
        family = CaTeXFont.sansSerif.family;
        break;
      case CaTeXFunction.bf:
        weight = FontWeight.bold;
        break;
      case CaTeXFunction.it:
        style = FontStyle.italic;
        break;
      case CaTeXFunction.cal:
        family = CaTeXFont.caligraphic.family;
        break;
      case CaTeXFunction.mathbb:
        weight = FontWeight.normal;
        style = FontStyle.normal;
        family = CaTeXFont.ams.family;
        break;
      default: // noop
    }

    return NodeWidget(
      context,
      createRenderNode,
      children: [
        child!.createWidget(context.copyWith(
          fontWeight: weight,
          fontStyle: style,
          fontFamily: family,
        )),
      ],
    );
  }

  @override
  RenderFont createRenderNode(CaTeXContext context) {
    return RenderFont(context);
  }
}
