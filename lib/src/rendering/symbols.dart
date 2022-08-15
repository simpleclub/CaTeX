import 'package:catex/src/lookup/context.dart';
import 'package:catex/src/lookup/symbols.dart';
import 'package:catex/src/rendering/character.dart';
import 'package:flutter/foundation.dart';

class RenderSymbol extends RenderCharacter {
  RenderSymbol(CaTeXContext context, {required SymbolData data})
      : assert(data != null),
        super(context.copyWith(input: data.unicode));
}
