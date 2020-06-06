![logo][]

# CaTeX

A package that allows to draw TeX equations inline as a widget using only Flutter.

The implementation is mainly based on [*The TeXbook* by Donald E. Knuth][TeXbook], [*TeX by Topic* by Victor Eijkhout][TeX by Topic], and the [KaTeX project][KaTeX GitHub].

## Supported inputs

This version is only a proof of concept. For a few supported equations, see the [`example`][example] app.

To get a feel of even what set of *characters* is only supported, see the [`Category` enum in `characters.dart`][categories].

## Usage

In order to manually input TeX equations to CaTeX you should use raw Dart strings (`r'<input>'` or `'''<input>'''`):

```dart
Widget build(BuildContext context) => CaTeX(r'\epsilon = \frac 2 {3 + 2}');
```

If you fetch the strings from a database, you can just pass them to `CaTeX`:

```dart
CaTeX(equation);
```

### Fonts & licenses

The included fonts are taken from [the `katex-fonts` repository][katex-fonts] and licensed under the [**SIL Open Font License**][fonts license].  
Additionally, some code, e.g. what is used for translating symbols is from KaTeX.  You can find the [license for the main KaTeX repo here][KaTeX license].

The CaTeX project itself was built for [simpleclub][], initially by [creativecreatorormaybenot][], (see the [`LICENSE` file][license]).

## Implementation

CaTeX basically uses two trees from input to displaying all nodes:

1. **Parsing** tree, which consists of nodes storing only information about separation, i.e. the current *mode* (math or text) and the *input* for a given node.  
   Each node in this tree will have the necessary information to create a render object from itself for the rendering tree.
1. **Rendering** tree, which makes use of Flutter's render objects and takes care of *sizing* and *rendering* (using a canvas).

## Expanding supported functionality

This package is far from complete in terms of supporting all TeX functionality.  
If you want support for more functions, symbols, macros, etc., we appreciate your contribution!  
Please refer to the [contribution guide][contributing] to understand how you can easily add functions and more.

To help prioritisation of function development we did some research how often functions appear in our own content. 
This should give a rough feeling for what is most commonly used. A CSV file with the list of used functions and the frequency the appear can be found [here][function_frequency].

> Please note that this list may be incomplete or contain typos in the function names.

If you find something that is fundamentally flawed, please propose a better solution - we are open to complete revamps.

[//]: # (todo replace relative paths once published)

[logo]: https://i.imgur.com/6DvWz3S.png
[example]: ./example/README.md
[categories]: ./lib/src/lookup/characters.dart
[license]: ./LICENSE
[contributing]: ./CONTRIBUTING.md
[TeXbook]: http://www.ctex.org/documents/shredder/src/texbook.pdf
[TeX by Topic]: http://texdoc.net/texmf-dist/doc/plain/texbytopic/TeXbyTopic.pdf
[KaTeX GitHub]: https://github.com/KaTeX/KaTeX
[katex-fonts]: https://github.com/KaTeX/katex-fonts/tree/feee984b451fea029d921ea0d41b917f56c8b7f6
[fonts license]: https://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL
[KaTeX license]: https://github.com/KaTeX/KaTeX/blob/b14197d9c9052d937dc789e1ac492bcdcdde5599/LICENSE
[creativecreatorormaybenot]: https://github.com/creativecreatorormaybenot
[simpleclub]: https://github.com/simpleclub
[function_frequency]: https://github.com/simpleclub/CaTeX/blob/master/function_prioritization.csv
