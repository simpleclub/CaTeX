import 'package:catex/catex.dart';
import 'package:flutter/material.dart';

/// Example equations to test and showcase the renderer and parser.
List<String> get equations => [
      r'\mu =: \sqrt{x}',
      r'\eta = 7^\frac{4}{2}',
      r'\epsilon = \frac 2 {3 + 2}',
      r'x_{initial} = \frac {20x} {\frac{15}{3}}',
      r'\colorbox{red}{bunt} \boxed{'
          r'\rm{\sf{\bf{'
          r'\color{red} s \color{pink}  i \color{purple}m'
          r'\color{blue}p \color{cyan}  l \color{teal}  e}'
          r'\color{lime}c \color{yellow}l \color{amber} u \color{orange} b'
          r'}}}',
      r'x_i=a^n',
      r'12^{\frac{\frac{2}{7}}{1}}',
      r'\varepsilon = \frac{\frac{2}{1}}{3}',
      r'\alpha\beta\gamma\delta',
      r'\colorbox{black}{\color{white} {black} } \colorbox{white}{\color{black} {white} }',
      r'\alpha\ \beta\ \ \gamma\ \ \ \delta',
      r'\epsilon = \frac{2}{3 + 2}',
      r'\tt {type} \color{teal}{\rm{\tt {writer} }}',
      r'l = a * t * e * x',
      r'\rm\tt{sp   a c  i n\ \bf\it g}',
      r'5 = 1 \cdot 5',
      r'{2 + 3}+{3             +4    }=12',
      r'\backslash \leftarrow \uparrow \rightarrow  \$',
      r'42\uparrow 99\Uparrow\ \  19\downarrow 1\Downarrow',
      r'5x =      25',
      r'10\cdot10 = 100',
      r'a := 96',
    ];

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
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

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tap to toggle equations'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 16),
        itemBuilder: (context, index) {
          if (index == 0) return const Highlighted(child: TextFieldEquation());
          return Highlighted(
              child: ToggleEquation(equations[(index - 1) % equations.length]));
        },
      ),
    );
  }
}

class TextFieldEquation extends StatefulWidget {
  const TextFieldEquation({Key key}) : super(key: key);

  @override
  State createState() => _TextFieldEquationState();
}

class _TextFieldEquationState extends State<TextFieldEquation> {
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
    if (_input)
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
    if (_showSource)
      return Text(
        widget.equation,
        // ignore: deprecated_member_use
        style: Theme.of(context).textTheme.subhead,
        textAlign: TextAlign.center,
      );
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

class Highlighted extends StatelessWidget {
  const Highlighted({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        color: Colors.grey[800],
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(child: child),
        ),
      ),
    );
  }
}
