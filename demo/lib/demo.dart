import 'package:catex/catex.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Demo application for CaTeX.
class DemoApp extends StatelessWidget {
  /// Constructs a [DemoApp].
  const DemoApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CaTeX - Fast TeX renderer for Flutter',
      home: Scaffold(
        body: Stack(
          children: [
            Center(
              child: FractionallySizedBox(
                widthFactor: .8,
                heightFactor: .6,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Fast',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              TextSpan(
                                text: ' math TeX renderer for Flutter '
                                    'written in Dart.',
                              ),
                            ],
                            style:
                                Theme.of(context).textTheme.bodyText2.copyWith(
                                      fontSize: 38,
                                    ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: .84,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.fromBorderSide(
                                  BorderSide(
                                    color: const Color(0xff000000),
                                  ),
                                ),
                              ),
                              child: FlatButton.icon(
                                onPressed: () {
                                  launch(_pubUrl);
                                },
                                label: Text(
                                  'Pub',
                                  style: TextStyle(fontSize: 20),
                                ),
                                icon: Image.network(_pubBadgeUrl),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.fromBorderSide(
                                  BorderSide(
                                    color: const Color(0xff000000),
                                  ),
                                ),
                              ),
                              child: FlatButton.icon(
                                onPressed: () {
                                  launch(_gitHubUrl);
                                },
                                label: Text(
                                  'GitHub',
                                  style: TextStyle(fontSize: 20),
                                ),
                                icon: SizedBox(
                                  width: 32,
                                  height: 32,
                                  child: Image.network(_gitHubIconUrl),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.fromBorderSide(
                                  BorderSide(
                                    color: const Color(0xff000000),
                                  ),
                                ),
                              ),
                              child: FlatButton(
                                onPressed: () {
                                  launch(_docsUrl);
                                },
                                child: Text(
                                  'API reference',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: const _CaTeXEditor(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 32,
                  left: 128,
                ),
                child: DefaultTextStyle.merge(
                  style: TextStyle(fontSize: 60),
                  child: CaTeX(r'\CaTeX'),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 12,
                  right: 96,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 380),
                  child: Image.network(_logoUrl),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CaTeXEditor extends StatefulWidget {
  const _CaTeXEditor({Key key}) : super(key: key);

  @override
  State createState() => _CaTeXEditorState();
}

class _CaTeXEditorState extends State<_CaTeXEditor> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: r'\CaTeX = 42')
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
    return DefaultTextStyle.merge(
      style: TextStyle(
        fontSize: 32,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: FractionallySizedBox(
              widthFactor: .64,
              child: ColoredBox(
                color: Colors.grey.withOpacity(.1),
                child: Builder(
                  builder: (context) {
                    return TextField(
                      autofocus: true,
                      style: DefaultTextStyle.of(context).style,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      controller: _controller,
                    );
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: CaTeX(_controller.text),
            ),
          ),
        ],
      ),
    );
  }
}

const _logoUrl = 'https://i.imgur.com/1CoSmA6.png';
const _pubBadgeUrl = 'https://img.shields.io/pub/v/catex.svg';
const _gitHubIconUrl = 'https://i.imgur.com/B9jYEyK.png';
const _pubUrl = 'https://pub.dev/packages/catex';
const _docsUrl = 'https://pub.dev/documentation/catex/latest/';
const _gitHubUrl = 'https://github.com/simpleclub/CaTeX';
