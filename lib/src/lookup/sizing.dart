import 'package:catex/src/lookup/characters.dart';
import 'package:catex/src/lookup/exception.dart';
import 'package:meta/meta.dart';

/// String extension that adds functionality to parse sizes, e.g. `12px`,
/// `-.3em`, `5mu`, or `0.1ex`.
extension SizeString on String {
  /// Parses the string to a px value.
  ///
  /// Supported sizes currently are `px`, `em`, `ex`, and `mu`.
  double? parseToPx(double? fontSize) {
    // Need to create a variable to make the value accessible in the error
    // callback.
    final input = this;

    final letterIndex = runes.toList().indexWhere(
          (element) =>
              CharacterCategory.letter.matches(String.fromCharCode(element)),
        );
    if (letterIndex == -1 || length <= letterIndex + 1) {
      throw ConfigurationException(
        reason: 'No size unit specified',
        input: input,
      );
    }
    if (length > letterIndex + 2) {
      throw ConfigurationException(
        reason: 'Input found after the size unit (correct would be 1px; '
            'incorrect would be 1px5)',
        input: input,
      );
    }

    final valueString = substring(0, letterIndex);
    var value = double.tryParse(substring(0, letterIndex));

    if (value == null) {
      throw ConfigurationException(
        reason: 'Invalid double size value: $valueString',
        input: input,
      );
    }

    final sizeUnit = substring(letterIndex, letterIndex + 2);
    switch (sizeUnit) {
      case 'px':
        break;
      case 'em':
        value = emToPx(value, fontSize: fontSize!);
        break;
      case 'ex':
        value = exToPx(value, fontSize: fontSize!);
        break;
      case 'mu':
        value = muToPx(value, fontSize: fontSize!);
        break;
      default:
        throw ConfigurationException(
          reason: 'Size unit $sizeUnit is unknown; currently supported units '
              'are px, em, ex, and mu',
          input: input,
        );
    }

    return value;
  }
}

/// Converts em to px.
///
/// This is effectively an eye-balled conversion for the main font.
double emToPx(
  double em, {
  required double fontSize,
}) {
  assert(fontSize != null);
  // Assume that 1em is equal to the font size, i.e. that the
  // character m width is equal to the font size.
  return fontSize * em;
}

/// Converts ex to px.
///
/// This uses an eye-balled conversion ratio for the main font.
double exToPx(
  double ex, {
  required double fontSize,
}) {
  assert(fontSize != null);
  // Eyeballed using the TeX logo macro.
  return fontSize * ex * .52;
}

/// Converts mu to px.
double muToPx(
  double mu, {
  required double fontSize,
}) {
  assert(fontSize != null);
  return emToPx(muToEm(mu), fontSize: fontSize);
}

/// Converts math units to em.
double muToEm(double mu) {
  return mu / 18;
}
