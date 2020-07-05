import 'package:catex/catex.dart';
import 'package:flutter/material.dart';

/// Example equations to test and showcase the renderer and parser.
List<String> get equations => [
      r'\text{Hello, World!}',
      r'\mu =: \sqrt{x}',
      r'\eta = 7^\frac{4}{2}',
      r'\epsilon = \frac 2 {3 + 2}',
      r'x_{initial} = \frac {20x} {\frac{15}{3}}',
      // ignore: no_adjacent_strings_in_list
      r'\colorbox{red}{bunt} \boxed{ '
          r'\rm{\sf{\bf{'
          r'\textcolor{red} s \textcolor{pink}  i \textcolor{purple}m '
          r'\textcolor{blue}p \textcolor{cyan}  l \textcolor{teal}  e} '
          r'\textcolor{lime}c \textcolor{yellow}l \textcolor{amber} u '
          r'\textcolor{orange} b}}}',
      r'\TeX',
      r'\LaTeX',
      r'\KaTeX',
      r'\CaTeX',
      'x_i=a^n',
      r'\hat{y} = H y',
      r'12^{\frac{\frac{2}{7}}{1}}',
      r'\varepsilon = \frac{\frac{2}{1}}{3}',
      r'\alpha\beta\gamma\delta',
      // ignore: no_adjacent_strings_in_list
      r'\colorbox{black}{\textcolor{white} {black} } \colorbox{white} '
          r'{\textcolor{black} {white} }',
      r'\alpha\ \beta\ \ \gamma\ \ \ \delta',
      r'\epsilon = \frac{2}{3 + 2}',
      r'\tt {type} \textcolor{teal}{\rm{\tt {writer} }}',
      'l = a * t * e * x',
      r'\rm\tt{sp   a c  i n\ \bf\it g}',
      r'5 = 1 \cdot 5',
      '{2 + 3}+{3             +4    }=12',
      r'\backslash \leftarrow \uparrow \rightarrow  \$',
      r'42\uparrow 99\Uparrow\ \  19\downarrow 1\Downarrow',
      '5x =      25',
      r'10\cdot10 = 100',
      'a := 96',
    ];

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
  runApp(const App());
}

/// Example app widget that uses [MaterialApp] to display CaTeX output.
class App extends StatelessWidget {
  /// Constructs the example [App].
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CaTeX example',
      home: const Home(),
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
    );
  }
}

/// Example home page that includes an infinite list of CaTeX example widgets
/// and a text field to test out CaTeX.
class Home extends StatelessWidget {
  /// Constructs a [Home] widget.
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tap to toggle equations'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 16),
        itemBuilder: (context, index) {
          if (index == 0) {
            return const _Highlighted(
              child: _TextFieldEquation(),
            );
          }

          return _Highlighted(
            child: ToggleEquation(
              equations[(index - 1) % equations.length],
            ),
          );
        },
      ),
    );
  }
}

class _TextFieldEquation extends StatefulWidget {
  const _TextFieldEquation({Key key}) : super(key: key);

  @override
  State createState() => _TextFieldEquationState();
}

class _TextFieldEquationState extends State<_TextFieldEquation> {
  TextEditingController _controller;

  bool _input;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
    _input = true;
  }

  @override
  Widget build(BuildContext context) {
    if (_input) {
      return TextField(
        controller: _controller,
        autocorrect: false,
        enableSuggestions: false,
        onSubmitted: (_) {
          setState(() {
            _input = false;
          });
        },
      );
    }

    return InkWell(
      onTap: () {
        setState(() {
          _input = true;
        });
      },
      child: CaTeX(_controller.text),
    );
  }
}

class ToggleEquation extends StatefulWidget {
  const ToggleEquation(this.equation, {Key key}) : super(key: key);

  final String equation;

  @override
  State createState() => _ToggleEquationState();
}

class _ToggleEquationState extends State<ToggleEquation> {
  bool _showSource;

  @override
  void initState() {
    super.initState();

    _showSource = false;
  }

  Widget buildEquation(BuildContext context) {
    if (_showSource) {
      return Text(
        widget.equation,
        // ignore: deprecated_member_use
        style: Theme.of(context).textTheme.subhead,
        textAlign: TextAlign.center,
      );
    }

    return CaTeX(widget.equation);
  }

  void _toggle() {
    setState(() {
      _showSource = !_showSource;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _toggle,
      child: buildEquation(context),
    );
  }
}

class _Highlighted extends StatelessWidget {
  const _Highlighted({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        color: Colors.grey[800],
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: DefaultTextStyle.merge(
            style: const TextStyle(
              fontSize: 24,
            ),
            child: Center(
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
