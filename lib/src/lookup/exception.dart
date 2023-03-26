import 'package:catex/src/lookup/context.dart';
import 'package:flutter/foundation.dart';

/// Basis for all exceptions thrown by CaTeX.
abstract class CaTeXException implements Exception {
  /// Constructs a [CaTeXException] from a [reason], an [input], and the
  /// phase of CaTeX's output process that the exception occurred in ([during]).
  ///
  /// [reason] needs to make sense as an explanation of why the exception
  /// was thrown after a colon and followed by a comma.
  /// [during] needs to make sense between "during" and a colon.
  /// [input] should be the input that was currently processed, which can
  /// be obtained from [CaTeXContext.input] most of the time.
  const CaTeXException(String reason, String input, String during)
      : assert(reason != null),
        assert(input != null),
        assert(during != null),
        _reason = reason,
        _input = input,
        _during = during;

  final String _reason;
  final String _input;
  final String _during;

  /// Exception message constructed from the individual parts given to
  /// a [CaTeXException].
  ///
  /// This message is returned from [toString] as well.
  String get message =>
      // ignore: missing_whitespace_between_adjacent_strings
      '$CaTeXException during $_during: $_reason, for input: $_input'
      // Only show the help part of the exception in debug mode as
      // users will most likely not benefit from seeing this message at all.
      // The help appendix is directed at developers only. Because it is
      // encouraged that CaTeX error messages can be shown in release mode,
      // this needs to be considered.
      '${kDebugMode ? _helpAppendix : ''}';

  static const _helpAppendix = '\n\nFor help, '
      'consult the CaTeX README, which can be found at '
      'https://github.com/simpleclub/CaTeX, '
      'or read through the CaTeX API documentation at '
      'https://pub.dev/documentation/catex/latest. If you think '
      'that you might have encountered a bug or any other issue, '
      'feel free to look for similar issues or file a new issue at '
      'https://github.com/simpleclub/CaTeX/issues.';

  /// Returns the [message] of this CaTeX exception.
  @override
  String toString() => message;
}

/// Exception that is thrown by CaTeX during parsing.
class ParsingException extends CaTeXException {
  /// Constructs a [ParsingException] from a [reason] and an [input].
  ///
  /// See [CaTeXException] for the meaning of those.
  ParsingException({required String reason, required String input})
      : super(reason, input, 'parsing');
}

/// Exception that is thrown by CaTeX during configuration.
class ConfigurationException extends CaTeXException {
  /// Constructs a [ConfigurationException] from a [reason] and an [input].
  ///
  /// See [CaTeXException] for the meaning of those.
  ConfigurationException({required String reason, required String input})
      : super(reason, input, 'configuration');
}

/// Exception that is thrown by CaTeX during rendering.
class RenderingException extends CaTeXException {
  /// Constructs a [RenderingException] from a [reason] and an [input].
  ///
  /// See [CaTeXException] for the meaning of those.
  RenderingException({required String reason, required String input})
      : super(reason, input, 'rendering');
}
