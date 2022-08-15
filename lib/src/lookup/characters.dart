/// These are the 16 categories defined in *The TeXbook* chapter 7.
///
/// Categories that have an "ignored" comment are unsupported at the moment.
enum CharacterCategory {
  /// Backslash `\` character.
  escapeCharacter,

  /// Left curly brace `{` character.
  beginningOfGroup,

  /// Right curly brace `}` character.
  endOfGroup,

  /// Dollar sign `$` character.
  mathShift,

  /// Ampersand `&` character.
  alignmentTab, // todo: [alignmentTab] is unsupported.

  /// Return character.
  endOfLine, // todo: [endOfLine] is unsupported.

  /// Hash `#` character.
  parameter, // todo: [parameter] is unsupported.

  /// Carat `^` character.
  superscript,

  /// Underscore `_` character.
  subscript,

  /// Special ignored character.
  ignoredCharacter, // todo: [ignoredCharacter] is unsupported.
  /// Space ` ` character.
  space,

  /// A-Z and a-z.
  letter,

  /// Any character that is not included in the other categories.
  otherCharacter,

  /// Tile `~` character.
  activeCharacter, // todo: [activeCharacter] is unsupported.

  /// Percent `%` character.
  commentCharacter, // todo: [commentCharacter] is unsupported.

  /// Delete character.
  invalidCharacter, // todo: [invalidCharacter] is unsupported.
}

final _matches = <CharacterCategory, RegExp?>{
  CharacterCategory.escapeCharacter: RegExp(r'\\'),
  CharacterCategory.beginningOfGroup: RegExp('{'),
  CharacterCategory.endOfGroup: RegExp('}'),
  CharacterCategory.mathShift: RegExp(r'\$'),
  // todo: [mathShift] is unsupported.
  CharacterCategory.alignmentTab: null,
  CharacterCategory.endOfLine: null,
  CharacterCategory.parameter: null,
  CharacterCategory.superscript: RegExp(r'\^'),
  // todo: [superscript] is unsupported.
  CharacterCategory.subscript: RegExp('_'),
  // todo: [subscript] is unsupported.
  CharacterCategory.ignoredCharacter: null,
  CharacterCategory.space: RegExp(r'[ \t]'),
  // todo: [space] is unsupported.
  CharacterCategory.letter: RegExp('[A-Za-z]'),
  CharacterCategory.otherCharacter: RegExp(r'[^A-Za-z\\{}\^_\$ \t]+'),
  // This needs to be updated when new categories are supported.
  CharacterCategory.activeCharacter: null,
  CharacterCategory.commentCharacter: null,
  CharacterCategory.invalidCharacter: null,
};

/// Extension for [CharacterCategory] adding matching functionality.
extension CategoryMatcher on CharacterCategory {
  /// Checks if the [CharacterCategory] contains the given [character].
  ///
  /// A [character] can either be an [int] or a [String] of length 1.
  bool matches(String character) {
    assert(_matches[this] != null, '$this is not currently supported.');
    assert(character.length == 1, 'Only single characters can be checked.');

    return _matches[this]!.hasMatch(character);
  }
}
