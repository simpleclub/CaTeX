import 'package:catex/src/lookup/context.dart';
import 'package:catex/src/lookup/symbols.dart';
import 'package:catex/src/parsing/parsing.dart';
import 'package:catex/src/rendering/character.dart';
import 'package:catex/src/widgets.dart';

/// [ParsingNode] for all regular character.
class CharacterNode extends LeafNode<RenderCharacter> {
  /// Constructs a [CharacterNode] from a [context].
  CharacterNode(ParsingContext context)
      : _context = context,
        super(context);

  /// Stores the [ParsingContext] for a workaround solution.
  final ParsingContext _context;

  @override
  NodeWidget<RenderCharacter> configureWidget(CaTeXContext context) {
    super.configureWidget(context);

    return NodeWidget(context, createRenderNode);
  }

  @override
  RenderCharacter createRenderNode(CaTeXContext context) {
    // todo: remove this workaround solution of correcting how some symbols
    // todo| are rendered
    // The symbol is passed explicitly as the input needs to stay the same for
    // correct spacing etc.
    final symbol = symbols[_context.mode]![context.input!];

    return RenderCharacter(
      context,
      symbol: symbol,
    );
  }
}
