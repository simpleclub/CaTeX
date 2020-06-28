import 'package:catex/catex.dart';
import 'package:demo/src/editor.dart';
import 'package:demo/src/link_button.dart';
import 'package:demo/src/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';

/// Demo application for CaTeX.
class DemoApp extends StatelessWidget {
  /// Constructs a [DemoApp].
  const DemoApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttons = [
      LinkButton(
        label: pubLabel,
        url: pubUrl,
        child: Image.network(pubBadgeUrl),
      ),
      LinkButton(
        label: gitHubLabel,
        url: gitHubUrl,
        child: Image.network(gitHubIconUrl),
      ),
      const LinkButton(
        label: docsLabel,
        url: docsUrl,
      ),
    ];

    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.amber,
        accentColor: Colors.amberAccent,
      ),
      home: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                bottom: 8,
              ),
              child: MouseRegion(
                cursor: MaterialStateMouseCursor.clickable,
                child: GestureDetector(
                  onTap: () {
                    launch(katexUrl);
                  },
                  child: DefaultTextStyle.merge(
                    style: const TextStyle(fontSize: 48),
                    child: const CaTeX(r'\CaTeX'),
                  ),
                ),
              ),
            ),
            const Divider(
              thickness: 1,
              height: 1,
            ),
            Expanded(
              child: Material(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 32,
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 64,
                                right: 64,
                                bottom: 8,
                              ),
                              child: Text.rich(
                                TextSpan(
                                  children: const [
                                    TextSpan(
                                      text: descriptionPrefix,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' $description',
                                    ),
                                  ],
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5
                                      .copyWith(
                                        fontSize: 28,
                                      ),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            if (constraints.maxWidth < 6e2) ...[
                              for (final button in buttons)
                                Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: button,
                                ),
                            ] else
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (final button in buttons)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 16,
                                      ),
                                      child: button,
                                    ),
                                ],
                              ),
                            const SizedBox(
                              height: 56,
                            ),
                            Text(
                              editorHeadline,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(
                                    fontStyle: FontStyle.italic,
                                  ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                top: 16,
                                left: 24,
                                right: 24,
                              ),
                              child: CaTeXEditor(),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            const Divider(
              thickness: 1,
              height: 1,
            ),
            MouseRegion(
              cursor: MaterialStateMouseCursor.clickable,
              child: GestureDetector(
                onTap: () {
                  launch(organizationUrl);
                },
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 264),
                  child: Image.network(logoUrl),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
