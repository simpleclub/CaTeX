import 'package:catex/catex.dart';
import 'package:demo/src/strings.dart';
import 'package:flutter/material.dart';

/// Widget that allows editing a CaTeX input and displays its output.
class CaTeXEditor extends StatefulWidget {
  /// Constructs a [CaTeXEditor].
  const CaTeXEditor({Key key}) : super(key: key);

  @override
  State createState() => _CaTeXEditorState();
}

class _CaTeXEditorState extends State<CaTeXEditor> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: defaultInput)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 4e2,
          ),
          child: ColoredBox(
            color: Colors.grey.withOpacity(.2),
            child: TextField(
              autofocus: true,
              enableInteractiveSelection: false,
              style: const TextStyle(
                fontSize: 24,
              ),
              cursorColor: Theme.of(context).primaryColor,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              controller: _controller,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 16,
            bottom: 8,
          ),
          child: DefaultTextStyle.merge(
            style: const TextStyle(
              fontSize: 36,
            ),
            child: const CaTeX(r'\Downarrow'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
          ),
          child: DefaultTextStyle.merge(
            style: const TextStyle(
              fontSize: 32,
            ),
            child: CaTeX(_controller.text),
          ),
        ),
      ],
    );
  }
}
