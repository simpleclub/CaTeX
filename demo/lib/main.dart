import 'package:catex/catex.dart';
import 'package:demo/src/app.dart';
import 'package:flutter/material.dart';

void main() {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    final exception = details.exception;
    if (exception is CaTeXException) {
      return ErrorWidget(exception);
    }

    var message = '';
    // The assert ensures that any exceptions that are not CaTeX exceptions
    // are not shown in release and profile mode. This ensures that no
    // stack traces or other sensitive information (information that the user
    // is in no way interested in) is shown on screen.
    assert(() {
      message = '${details.exception}\n'
          'See also: https://flutter.dev/docs/testing/errors';
      return true;
    }());

    return ErrorWidget.withDetails(
      message: message,
      error: exception is FlutterError ? exception : null,
    );
  };

  runApp(const DemoApp());
}
