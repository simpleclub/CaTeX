import 'package:catex/src/lookup/context.dart';
import 'package:catex/src/lookup/exception.dart';
import 'package:catex/src/lookup/fonts.dart';
import 'package:catex/src/lookup/modes.dart';
import 'package:catex/src/lookup/symbols.dart';
import 'package:catex/src/parsing/parsing.dart';
import 'package:catex/src/rendering/symbols.dart';
import 'package:catex/src/widgets.dart';

class SymbolNode extends LeafNode<RenderSymbol> {
  SymbolNode(ParsingContext context)
      : _context = context,
        super(context);

  final ParsingContext _context;

  @override
  NodeWidget<RenderSymbol> configureWidget(CaTeXContext context) {
    super.configureWidget(context);

    return NodeWidget(context, createRenderNode);
  }

  @override
  RenderSymbol createRenderNode(CaTeXContext context) {
    final symbol = symbols[_context.mode]![context.input!];

    if (symbol == null) {
      throw ConfigurationException(
        reason: 'Unknown symbol in ${_context.mode}',
        input: context.input!,
      );
    }

    return RenderSymbol(
      context.copyWith(
          fontFamily: (symbol.font == SymbolFont.ams
                  ? CaTeXFont.ams
                  : _context.mode == CaTeXMode.math
                      ? CaTeXFont.math
                      : CaTeXFont.main)
              .family),
      data: symbol,
    );
  }
}
