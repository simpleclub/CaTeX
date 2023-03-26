/// The 8 different styles (display, text, script, scriptscript,
/// and cramped versions).
///
/// See *The TeXbook* from page 140 for the different styles.
/// The actual names are T', S', etc. for the cramped styles, however,
/// Dart does not allow the prime symbol for variable names.
enum CaTeXStyle {
  d,
  dc,
  t,
  tc,
  s,
  sc,
  ss,
  ssc,
}

// todo(creativecreatorormaybenot): support this.
class CaTeXStyleData {
  // Ignore the warning until this is implemented.
  // ignore: avoid_positional_boolean_parameters
  const CaTeXStyleData(this.id, this.size, this.cramped);

  final int id;
  final int size;
  final bool cramped;

  CaTeXStyleData? get sup => styles[_sup[id]];

  CaTeXStyleData? get sub => styles[_sub[id]];

  CaTeXStyleData? get fracNum => styles[_fracNum[id]];

  CaTeXStyleData? get fracDen => styles[_fracDen[id]];

  CaTeXStyleData? get cramp => styles[_cramp[id]];

  CaTeXStyleData? get text => styles[_text[id]];

  @override
  bool operator ==(dynamic other) {
    if (identical(other, this)) return true;

    if (other is CaTeXStyleData) {
      return other.id == id && other.size == size && other.cramped == cramped;
    }
    return false;
  }

  @override
  int get hashCode => id.hashCode ^ size.hashCode ^ cramped.hashCode;
}

/// Lookup tables based on https://github.com/KaTeX/KaTeX/blob/fa8fbc0c18e5e3fe98f347ceed3a48699d561c72/src/Style.js.
const List<CaTeXStyle> _sup = [
      CaTeXStyle.s,
      CaTeXStyle.sc,
      CaTeXStyle.s,
      CaTeXStyle.sc,
      CaTeXStyle.ss,
      CaTeXStyle.ssc,
      CaTeXStyle.ss,
      CaTeXStyle.ssc,
    ],
    _sub = [
      CaTeXStyle.sc,
      CaTeXStyle.sc,
      CaTeXStyle.sc,
      CaTeXStyle.sc,
      CaTeXStyle.ssc,
      CaTeXStyle.ssc,
      CaTeXStyle.ssc,
      CaTeXStyle.ssc,
    ],
    _fracNum = [
      CaTeXStyle.t,
      CaTeXStyle.tc,
      CaTeXStyle.s,
      CaTeXStyle.sc,
      CaTeXStyle.ss,
      CaTeXStyle.ssc,
      CaTeXStyle.ss,
      CaTeXStyle.ssc,
    ],
    _fracDen = [
      CaTeXStyle.tc,
      CaTeXStyle.tc,
      CaTeXStyle.sc,
      CaTeXStyle.sc,
      CaTeXStyle.ssc,
      CaTeXStyle.ssc,
      CaTeXStyle.ssc,
      CaTeXStyle.ssc,
    ],
    _cramp = [
      CaTeXStyle.dc,
      CaTeXStyle.dc,
      CaTeXStyle.tc,
      CaTeXStyle.tc,
      CaTeXStyle.sc,
      CaTeXStyle.sc,
      CaTeXStyle.ssc,
      CaTeXStyle.ssc,
    ],
    _text = [
      CaTeXStyle.d,
      CaTeXStyle.dc,
      CaTeXStyle.t,
      CaTeXStyle.tc,
      CaTeXStyle.t,
      CaTeXStyle.tc,
      CaTeXStyle.t,
      CaTeXStyle.tc,
    ];

const styles = <CaTeXStyle, CaTeXStyleData>{
  CaTeXStyle.d: CaTeXStyleData(0, 0, false),
  CaTeXStyle.dc: CaTeXStyleData(1, 0, true),
  CaTeXStyle.t: CaTeXStyleData(2, 1, false),
  CaTeXStyle.tc: CaTeXStyleData(3, 1, true),
  CaTeXStyle.s: CaTeXStyleData(4, 2, false),
  CaTeXStyle.sc: CaTeXStyleData(5, 2, true),
  CaTeXStyle.ss: CaTeXStyleData(6, 3, false),
  CaTeXStyle.ssc: CaTeXStyleData(7, 3, true),
};

/// [CaTeXStyleData] for [CaTeXStyle.d].
final displayStyle = styles[CaTeXStyle.d];

/// [CaTeXStyleData] for [CaTeXStyle.dc].
final crampedDisplayStyle = styles[CaTeXStyle.dc];

/// [CaTeXStyleData] for [CaTeXStyle.d].
final textStyle = styles[CaTeXStyle.t];

/// [CaTeXStyleData] for [CaTeXStyle.tc].
final crampedTextStyle = styles[CaTeXStyle.tc];

/// [CaTeXStyleData] for [CaTeXStyle.s].
final scriptStyle = styles[CaTeXStyle.s];

/// [CaTeXStyleData] for [CaTeXStyle.sc].
final crampedScriptStyle = styles[CaTeXStyle.sc];

/// [CaTeXStyleData] for [CaTeXStyle.ss].
final scriptScriptStyle = styles[CaTeXStyle.ss];

/// [CaTeXStyleData] for [CaTeXStyle.ssc].
final crampedScriptScriptStyle = styles[CaTeXStyle.ssc];
