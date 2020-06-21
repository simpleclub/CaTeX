import 'package:catex/src/lookup/context.dart';

/// Base for all exceptions thrown in/by CaTeX.
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

  final String _reason, _input, _during;

  String get message =>
      '$CaTeXException during $_during: $_reason, for input: $_input';

  @override
  String toString() => message;
}

/// Exception that is thrown by CaTeX during parsing.
class ParsingException extends CaTeXException {
  /// Constructs a [ParsingException] from a [reason] and an [input].
  ///
  /// See [CaTeXException] for the meaning of those.
  ParsingException({String reason, String input})
      : super(reason, input, 'parsing');
}

/// Exception that is thrown by CaTeX during configuration.
class ConfigurationException extends CaTeXException {
  /// Constructs a [ConfigurationException] from a [reason] and an [input].
  ///
  /// See [CaTeXException] for the meaning of those.
  ConfigurationException({String reason, String input})
      : super(reason, input, 'configuration');
}

/// Exception that is thrown by CaTeX during rendering.
class RenderingException extends CaTeXException {
  /// Constructs a [RenderingException] from a [reason] and an [input].
  ///
  /// See [CaTeXException] for the meaning of those.
  RenderingException({String reason, String input})
      : super(reason, input, 'rendering');
}
