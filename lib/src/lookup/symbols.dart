export 'generated/symbols.g.dart';

enum SymbolFont {
  main,
  ams,
}

enum SymbolGroup {
  accent,
  bin,
  close,
  inner,
  mathord,
  op,
  open,
  punct,
  rel,
  spacing,
  textord,
}

class SymbolData {
  const SymbolData(
    this.unicode,
    this.font,
    this.group,
  );

  final SymbolFont font;
  final SymbolGroup group;
  final String? unicode;
}
