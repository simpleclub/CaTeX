/// Fonts supported by CaTeX, i.e. the supported font families.
///
/// Note that these are the fonts taken from the KaTeX project.
enum CaTeXFont {
  ams,
  caligraphic,
  fraktur,
  main,
  math,
  sansSerif,
  script,
  size1,
  size2,
  size3,
  size4,
  typewriter,
}

/// Extension for [CaTeXFont]s that adds stringify functionality.
extension RetrieveFont on CaTeXFont {
  /// Returns the font family with the package path.
  /// This means that you should not provide the `package`
  /// parameter to a text style.
  String get family {
    final buffer = StringBuffer('packages/catex/KaTeX ');

    switch (this) {
      case CaTeXFont.ams:
        buffer.write('AMS');
        break;
      case CaTeXFont.caligraphic:
        buffer.write('Caligraphic');
        break;
      case CaTeXFont.fraktur:
        buffer.write('Fraktur');
        break;
      case CaTeXFont.main:
        buffer.write('Main');
        break;
      case CaTeXFont.math:
        buffer.write('Math');
        break;
      case CaTeXFont.sansSerif:
        buffer.write('SansSerif');
        break;
      case CaTeXFont.script:
        buffer.write('Script');
        break;
      case CaTeXFont.size1:
        buffer.write('Size1');
        break;
      case CaTeXFont.size2:
        buffer.write('Size2');
        break;
      case CaTeXFont.size3:
        buffer.write('Size3');
        break;
      case CaTeXFont.size4:
        buffer.write('Size4');
        break;
      case CaTeXFont.typewriter:
        buffer.write('Typewriter');
        break;
      default:
        throw UnimplementedError();
    }
    return buffer.toString();
  }
}
