# [![CaTeX logo][logo]][demo]

[![CaTeX on Pub][Pub shield]][Pub]
[![CaTeX Flutter web demo][demo shield]][demo]

CaTeX is a Flutter package that outputs **TeX** equations (like LaTeX, KaTeX, MathJax, etc.) inline 
using a widget and *Flutter only* - no plugins, no web views.

# On-Hold

Note that this package is currently **on-hold**.  
This is because we are currently primarily engaged with other efforts. Therefore, we cannot ensure
active maintenance of the package.

However, there is an alternative that we encourage you to check out in the meantime :)  
We worked together with **[`flutter_math`](https://pub.dev/packages/flutter_math)** to make that 
package have all the necessary functionality and you should be able to use it in place of CaTeX
for the while being.

## About CaTeX

Being Dart only, CaTeX renders TeX ***faster*** than any other Flutter plugin and is way more
flexible. You can view a [***demo** running on the web*][demo].

CaTeX is an open source project with the aim of providing a way to render TeX
fast in Flutter. This was needed for the [simpleclub app][simpleclub], hence, the association.
It is also maintained by [simpleclub][] (see the [`LICENSE`][license] file), 
initially created individually by [creativecreatorormaybenot][].  

### Note

CaTeX is pre-v0.1 release and lacks support for some major TeX functionality. You can help
and contribute; see the [contributing guide][contributing].

> To benefit from the library *right now*, we fall back to an alternative when a specific formula 
> is not supported. CaTeX automatically throws appropriate exceptions for handling this.

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

### Unsupported input

If your input is currently not yet supported by CaTeX, you will see proper exceptions thrown
for this. See the ["Exception handling" section][exceptions] for more on this.

Please create a GitHub issue when you encounter such a case and it is either a bug or a missing
feature. You can [find issue templates when creating a new issue][issues]. 

### Controlling the font size

You will notice that the `CaTeX` widget does not have any parameters for styling (for the sake of
simplicity). Instead, it uses inherited widgets to grab necessary properties.

The **base font size** of the rendered output is controlled via 
[Flutter's `DefaultTextStyle` widget][DefaultTextStyle], i.e. the 
[`TextStyle.fontSize` property][TextStyle.fontSize].

```dart
Widget build(BuildContext context) {
  return DefaultTextStyle.merge(
    style: TextStyle(
      fontSize: 42,
    ),
    child: CaTeX(r'\CaTeX'),
  );
}
```

## Implementation

The implementation is mainly based on [*The TeXbook* by Donald E. Knuth][TeXbook], 
[*TeX by Topic* by Victor Eijkhout][TeX by Topic], and the [KaTeX][KaTeX] JavaScript project.  

Remember that CaTeX uses Flutter *only*! Consequently, all parsing and rendering is done in Dart.

The package basically uses two trees from input to displaying all nodes:

1. **Parsing** tree, which consists of nodes storing only information about separation, i.e. 
   the current *mode* (math or text) and the *input* for a given node.  
   Each node in this tree will have the necessary information to create 
   a render object from itself for the rendering tree.
1. **Rendering** tree, which makes use of Flutter's render objects and takes care 
   of *sizing* and *rendering* (using a canvas).

### Fonts & licenses

The included fonts are taken from [the `katex-fonts` repository][katex-fonts] and licensed under 
the [**SIL Open Font License**][fonts license].  
Additionally, some code, e.g. what is used for translating symbols is from KaTeX.  
You can find the [license for the main KaTeX repo here][KaTeX license].

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
displayed, [consider overriding `ErrorWidget.builder`][Flutter testing].
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
Please refer to the [contributing guide][contributing] to understand how you can easily add 
functions and more.

To aid our own prioritization for this project, we conducted some research examining how often 
particular TeX commands appear in some of [simpleclub][]'s content. 
This should give a rough feeling for what is most commonly used. A [CSV file with the list of 
used functions and the frequency of appearance][function_frequency] is maintained in the repo.

## Mission

There are already a couple of TeX Flutter plugins out there. So why create another?

Most of those libraries use already existing implementations in other languages, mostly using
web views and JavaScript.   
This is a valid approach; it is straightforward to implement. You only have to write a wrapper.

However, we believe that utilizing web views is an overhead that makes the applications less 
portable and performant.   
At simpleclub, we recently decided to move from a Flutter-native hybrid to going all-in with 
Flutter.
Now, we need a well-written Flutter TeX library that works on every platform and can display lots 
of formulas. So we decided to start this open source effort of bringing Dart-native TeX support to 
Flutter.

A custom TeX parser could potentially also allow us to provide accessibility and screen reader 
support out of the box.  
Here we could build on [the work of T.V. Raman][AsTeR], 
who developed *Audio System For Technical Readings (AsTeR)* for his PhD.

As this involves a lot of work, we would be happy to work together with the open source for
bringing this vision to life together - so everyone can benefit from a pure-Flutter TeX library.

See our [contributing guide][contributing] for more information.


[logo]: https://i.imgur.com/67VUyFm.png
[creativecreatorormaybenot]: https://github.com/creativecreatorormaybenot
[simpleclub]: https://github.com/simpleclub
[demo]: https://simpleclub.github.io/CaTeX
[demo shield]: https://img.shields.io/badge/CaTeX-demo-FFC107
[Pub shield]: https://img.shields.io/pub/v/catex.svg
[Pub]: https://pub.dev/packages/catex
[TeXbook]: https://github.com/lewischeng-ms/plain-tex/raw/master/The%20TEXbook.PDF
[TeX by Topic]: https://texdoc.net/texmf-dist/doc/plain/texbytopic/TeXbyTopic.pdf
[KaTeX]: https://github.com/KaTeX/KaTeX
[example]: https://github.com/simpleclub/CaTeX/tree/master/example
[Flutter testing]: https://flutter.dev/docs/testing/errors
[contributing]: https://github.com/simpleclub/CaTeX/blob/master/CONTRIBUTING.md
[DefaultTextStyle]: https://api.flutter.dev/flutter/widgets/DefaultTextStyle-class.html
[TextStyle.fontSize]: https://api.flutter.dev/flutter/painting/TextStyle/fontSize.html
[exceptions]: https://github.com/simpleclub/CaTeX#exception-handling
[issues]: https://github.com/simpleclub/CaTeX/issues/new/choose
[license]: https://github.com/simpleclub/CaTeX/blob/master/LICENSE
[katex-fonts]: https://github.com/KaTeX/katex-fonts/tree/feee984b451fea029d921ea0d41b917f56c8b7f6
[fonts license]: https://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL
[KaTeX license]: https://github.com/KaTeX/KaTeX/blob/b14197d9c9052d937dc789e1ac492bcdcdde5599/LICENSE
[function_frequency]: https://github.com/simpleclub/CaTeX/blob/master/function_prioritization.csv
[AsTeR]: https://tinyurl.com/catex-aster
