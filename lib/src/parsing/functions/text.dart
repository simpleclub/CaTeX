import 'dart:ui';

import 'package:catex/src/lookup/context.dart';
import 'package:catex/src/lookup/fonts.dart';
import 'package:catex/src/lookup/functions.dart';
import 'package:catex/src/parsing/parsing.dart';
import 'package:catex/src/rendering/functions/text.dart';
import 'package:catex/src/widgets.dart';

/// [ParsingNode] for [CaTeXFunction.text] et al.
///
/// Handles text functions.
class TextNode extends SingleChildNode<RenderText>
    with FunctionNode<RenderText> {
  /// Constructs a [TextNode] from a [context].
  TextNode(ParsingContext context) : super(context);

  @override
  FunctionProperties get properties =>
      const FunctionProperties(arguments: 1, greediness: 2);

  @override
  NodeWidget<RenderText> configureWidget(CaTeXContext context) {
    super.configureWidget(context);

    final function = supportedFunctionNames[context.input!];

    FontWeight? weight;
    FontStyle? style;
    String? family;

    // The different functions override different parts of the font style.
    switch (function) {
      case CaTeXFunction.text:
      case CaTeXFunction.textNormal:
      case CaTeXFunction.textRm:
        weight = FontWeight.normal;
        style = FontStyle.normal;
        family = CaTeXFont.main.family;
        break;
      case CaTeXFunction.textSf:
        family = CaTeXFont.sansSerif.family;
        break;
      case CaTeXFunction.textTt:
        family = CaTeXFont.typewriter.family;
        break;
      case CaTeXFunction.textBf:
        weight = FontWeight.bold;
        break;
      case CaTeXFunction.textMd:
        weight = FontWeight.normal;
        break;
      case CaTeXFunction.textIt:
        style = FontStyle.italic;
        break;
      case CaTeXFunction.textUp:
        style = FontStyle.normal;
        break;
      default:
        throw UnimplementedError();
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
  RenderText createRenderNode(CaTeXContext context) {
    return RenderText(context);
  }
}
