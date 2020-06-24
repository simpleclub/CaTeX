![logo][]

# CaTeX [![][shield]][pub]

Flutter package that outputs **TeX** equations (like LaTeX, KaTeX, MathJax, etc.) inline using a 
widget and *Flutter only*.

The implementation is mainly based on [*The TeXbook* by Donald E. Knuth][TeXbook], 
[*TeX by Topic* by Victor Eijkhout][TeX by Topic], and the [KaTeX project][KaTeX GitHub].

## Supported inputs

This version is only a proof of concept. For a few supported equations, 
see the [`example`][example] app.

To get a feel of even what set of *characters* is only supported, see the
[`Category` enum in `characters.dart`][categories].

## Usage

In order to manually input TeX equations to CaTeX you should use 
raw Dart strings (`r'<input>'` or `'''<input>'''`):

```dart
Widget build(BuildContext context) => CaTeX(r'\epsilon = \frac 2 {3 + 2}');
```

If you fetch the strings from a database, you can just pass them to `CaTeX`:

```dart
CaTeX(equation);
```

### Fonts & licenses

The included fonts are taken from [the `katex-fonts` repository][katex-fonts] and licensed under 
the [**SIL Open Font License**][fonts license].  
Additionally, some code, e.g. what is used for translating symbols is from KaTeX.  
You can find the [license for the main KaTeX repo here][KaTeX license].

The CaTeX open source project was created by [simpleclub][], initially by 
[creativecreatorormaybenot][] individually (see the [`LICENSE` file][license]).  
CaTeX itself is an open source project with the aim of providing a way to render TeX
fast in Flutter. This was needed for the [simpleclub app][simpleclub], hence, the association.

## Implementation

CaTeX basically uses two trees from input to displaying all nodes:

1. **Parsing** tree, which consists of nodes storing only information about separation, i.e. 
   the current *mode* (math or text) and the *input* for a given node.  
   Each node in this tree will have the necessary information to create 
   a render object from itself for the rendering tree.
1. **Rendering** tree, which makes use of Flutter's render objects and takes care 
   of *sizing* and *rendering* (using a canvas).

## Exception handling

There are three types of exceptions that are commonly thrown by CaTeX:

1. `ParsingException`, which will be thrown if CaTeX does *not understand* your input, i.e.
   even before it tries to display your input. This will commonly occur when something about
   your input is wrong, e.g. the wrong number of arguments for a function.  
   This type of exception will be shown on the screen by the default `CaTeX` widget 
   (like a normal Flutter error).
1. `ConfigurationException`, which will be thrown when CaTeX fails to *display* your input, i.e.
   when something about your input is not quite right (from CaTeX's point of view).
   Commonly, this means that something is not *configured* right, e.g. the name of a symbol.  
   This type of exception will also be shown on the screen by the default `CaTeX` widget 
   (like a normal Flutter error).
1. `RenderingException`, which will only be thrown when the constraints given to CaTeX to render
   your input are not sufficient for your input.  
   This type of exception is **not shown on screen**. Instead, CaTeX will only clip the output.
   However, you can still see the exception reported by Flutter during `performLayout()` 
   in the logs.

If you want to customize the look of how `ParsingException`s and `ConfigurationException`s are
displayed, [consider overriding `ErrorWidget.builder`](https://flutter.dev/docs/testing/errors).
If you want to see CaTeX errors in release mode, you will have to override the builder and ensure
that any `CaTeXException` is handled differently than normal. An example override might look like
this:

```dart
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
```

See the [example app][example] for more examples.

## Expanding supported functionality

This package is far from complete in terms of supporting all TeX functionality.  
If you want support for more functions, symbols, macros, etc., we appreciate your contribution!  
Please refer to the [contribution guide][contributing] 
to understand how you can easily add functions and more.

To help prioritization of function development, we conducted some research examining how often 
certain functions appear in some of simpleclub's content. 
This should give a rough feeling for what is most commonly used. A CSV file with the list of 
used functions and the frequency of appearance can be found [here][function_frequency].

If you find something that is fundamentally flawed, please propose a better solution - 
we are open to complete revamps.

[//]: # (a list of all links used in this document)

[shield]: https://img.shields.io/pub/v/catex.svg
[pub]: https://pub.dev/packages/catex
[logo]: https://i.imgur.com/6DvWz3S.png
[example]: https://github.com/simpleclub/CaTeX/tree/master/example
[categories]: https://github.com/simpleclub/CaTeX/blob/master/lib/src/lookup/characters.dart
[license]: https://github.com/simpleclub/CaTeX/blob/master/LICENSE
[contributing]: https://github.com/simpleclub/CaTeX/blob/master/CONTRIBUTING.md
[TeXbook]: http://www.ctex.org/documents/shredder/src/texbook.pdf
[TeX by Topic]: http://texdoc.net/texmf-dist/doc/plain/texbytopic/TeXbyTopic.pdf
[KaTeX GitHub]: https://github.com/KaTeX/KaTeX
[katex-fonts]: https://github.com/KaTeX/katex-fonts/tree/feee984b451fea029d921ea0d41b917f56c8b7f6
[fonts license]: https://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL
[KaTeX license]: https://github.com/KaTeX/KaTeX/blob/b14197d9c9052d937dc789e1ac492bcdcdde5599/LICENSE
[creativecreatorormaybenot]: https://github.com/creativecreatorormaybenot
[simpleclub]: https://github.com/simpleclub
[function_frequency]: https://github.com/simpleclub/CaTeX/blob/master/function_prioritization.csv
