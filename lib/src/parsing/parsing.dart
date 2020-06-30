import 'package:catex/src/lookup/characters.dart';
import 'package:catex/src/lookup/context.dart';
import 'package:catex/src/lookup/exception.dart';
import 'package:catex/src/lookup/functions.dart';
import 'package:catex/src/lookup/macros.dart';
import 'package:catex/src/lookup/modes.dart';
import 'package:catex/src/parsing/character.dart';
import 'package:catex/src/parsing/empty.dart';
import 'package:catex/src/parsing/group.dart';
import 'package:catex/src/parsing/symbols.dart';
import 'package:catex/src/rendering/rendering.dart';
import 'package:catex/src/widgets.dart';
import 'package:flutter/foundation.dart';

/// TeX parser for CaTeX.
///
/// This is currently only a proof of concept and not a proper parser.
/// creativecreatorormaybenot came up with it (based on/inspired
/// by TeX by Topic), so blame me if something does not work here - it
/// was a rush, i.e. half a day (:
class Parser {
  /// Constructs a [Parser] from an [input] string and a starting [mode].
  ///
  /// Basically, this sets up the [ParsingContext].
  factory Parser(
    String input, {
    CaTeXMode mode = CaTeXMode.math,
  }) {
    return Parser._(ParsingContext(input, mode));
  }

  Parser._(ParsingContext context)
      : assert(context != null),
        assert(context.input != null),
        assert(context.mode != null),
        _context = context;

  final ParsingContext _context;

  /// [ParsingContext] the parser starts with.
  ParsingContext get rootContext => _context;

  /// [ParsingNode] that is the result of parsing the [rootContext].
  ParsingNode get rootNode => _rootNode;

  ParsingNode _rootNode;
  String _input;
  int _index;
  _State _state;
  _Token _token;
  String _tokenInput;

  // todo: build proper solution
  /// Stores the latest parsed function in order to determine the [CaTeXMode]
  /// for a group.
  ParsingContext _lastFunctionToken;

  /// Parses the [rootContext] and populates the [rootNode].
  ///
  /// It is safe to call this multiple times.
  ParsingNode parse() {
    assert(_state == null);
    assert(_input == null);
    assert(_index == null);
    assert(_token == null);
    assert(_tokenInput == null);
    _init();

    // Catch exceptions while parsing and throw them after disposing
    // in order to make sure that the parser is properly disposed.
    CaTeXException exception;
    try {
      _rootNode = _parse();
    } on CaTeXException catch (e) {
      exception = e;
    }
    _dispose();

    if (exception != null) throw exception;
    return _rootNode;
  }

  /// Sets up internal state.
  void _init() {
    _state = _State.N;
    _rootNode = null;
    _input = _context.input;
    _index = 0;
    _tokenInput = '';
  }

  /// Resets internal state.
  void _dispose() {
    _state = null;
    _input = null;
    _index = null;
    _token = null;
    _tokenInput = null;

    // todo: do not use workaround solution
    _lastFunctionToken = null;
  }

  /// Handles parsing recursively.
  ///
  /// The stack will probably allow a bit more than 20k calls before
  /// overflowing. This should be enough to render input strings of
  /// like 5k length at least, even with the current inefficient strategy.
  /// When new lines would be implemented, the new line should probably break
  /// the recursions new lines are handled completely independently anyways.
  ParsingNode _parse() {
    switch (_state) {
      case _State.N:
        _state = _charIs(CharacterCategory.space) ? _State.S : _State.M;
        return _parse();
      case _State.S:
        assert(_tokenInput.isEmpty);

        if (_charIs(CharacterCategory.space)) {
          _input = _input.substring(1);
          _index++;

          // Workaround solution for inserting a single space (no matter how
          // many there actually are) in text mode.
          if (_context.mode == CaTeXMode.text &&
              (_rootNode == null ||
                  !(_group.children.last is CharacterNode &&
                      _group.children.last.context.input == ' '))) {
            _addNode(CharacterNode(_context.copyWith(input: ' ')));
          }
        } else {
          _state = _State.M;
        }
        return _parse();
      default:
        switch (_token) {
          case _Token.character:
            if (_charIs(CharacterCategory.space)) {
              _skipSpaces();
              return _parse();
            }

            if (_charIs(CharacterCategory.subscript) ||
                _charIs(CharacterCategory.superscript)) {
              // These are also implemented as functions, however,
              // they need special consideration
              // here because they do not start with an escape character.
              _consumeChar();
              // _lookupFunction here is fine because I know for a fact
              // that these functions exist as I put them there (:
              _addNode(_parseFunctionNode(_consumeToken()));
              _skipSpaces();
              return _parse();
            }

            if (_charIs(CharacterCategory.endOfGroup)) {
              // End of group should never appear here for a valid input.
              // It is either handled in _extractGroup or in a
              // different token mode.
              throw ParsingException(
                  reason: 'Found unescaped end of group character without '
                      'an open group at position $_index',
                  input: _context.input);
            }
            if (_charIs(CharacterCategory.beginningOfGroup)) {
              // Add what comes after the beginning of group character
              // until the matching end of group character.
              // The beginning of group character is thrown
              // away in _extractGroup.
              _addNode(_extractGroup());
            } else {
              // Any other single character.
              _consumeChar();

              // Some other characters are also special symbols. However,
              // this is currently handled in RenderCharacter as there are
              // some problems with it.
              final token = _consumeToken();

              // Any other characters can just be rendered as they are.
              _addNode(CharacterNode(token));
            }
            _skipSpaces();
            return _parse();
          case _Token.controlWord:
            if (_charIs(CharacterCategory.letter)) {
              _consumeChar();
              return _parse();
            }
            final token = _consumeToken(), macro = macros[token.input];

            if (macro == null) {
              final function = _parseFunctionNode(token);
              _addNode(function ?? SymbolNode(token));
            } else {
              // Replace the token with the macro.
              _addNode(Parser._(token.copyWith(input: macro)).parse());
            }

            _skipSpaces();
            return _parse();
          case _Token.controlSymbol:
            if (_input.isEmpty) {
              throw ParsingException(
                  reason: 'Expected at least one character after escape '
                      'character at position $_index',
                  input: _context.input);
            }
            if (_charIs(CharacterCategory.letter)) {
              // Letters after an escape character are handled
              // as a control word.
              _token = _Token.controlWord;
            } else {
              // A control symbol only takes the next character after the
              // escape sequence (and that cannot be a letter).
              _consumeChar();
              _addNode(SymbolNode(_consumeToken()));
              _skipSpaces();
            }
            return _parse();
          default:
            if (_charIs(CharacterCategory.escapeCharacter)) {
              _consumeChar();
              _token = _Token.controlSymbol;
              return _parse();
            }
            if (_input.isNotEmpty) {
              _token = _Token.character;
              return _parse();
            }
        }
    }

    if (_rootNode == null) {
      // This can only be the case when the whole input was empty.
      // Consisting only of spaces is also considered as empty (:
      return EmptyNode(_context);
    }
    // We have a GroupNode here because of the way
    // _addNode is set up to always construct a GroupNode.
    final children = _group.children;

    // This is a noop if there are no functions.
    _assembleFunctions(children);

    if (children.length == 1) {
      // No need to wrap a single child in a group.
      return _group.children[0];
    }

    _unpackGroups(children);

    // Return a group with multiple children.
    return _rootNode;
  }

  /// Checks if the current character matches the given [category].
  ///
  /// The current character is the character at position 0 of [_input].
  bool _charIs(CharacterCategory category) {
    if (_input.isEmpty) return false;
    return category.matches(_input.substring(0, 1));
  }

  /// Adds the current char to the current [_tokenInput].
  void _consumeChar() {
    assert(_input.isNotEmpty);
    _tokenInput += _input.substring(0, 1);
    _input = _input.substring(1);
    _index++;
  }

  ParsingContext _consumeToken() {
    // After any token is consumed, the stored function should be thrown away
    // because it might not affect the group anymore. This works as a workaround
    // because all currently supported text functions accept exactly one group
    // and when parsing that group, the text mode will be extracted from the
    // latest function before consuming any token.
    // todo: do not use workaround solution
    _lastFunctionToken = null;

    final token = _tokenInput;
    _tokenInput = '';
    return _context.copyWith(input: token);
  }

  GroupNode get _group {
    assert(_rootNode is GroupNode);
    return _rootNode as GroupNode;
  }

  void _addNode(ParsingNode node) {
    _rootNode ??= GroupNode(_context);
    _group.children.add(node);
  }

  void _skipSpaces() {
    assert(_tokenInput.isEmpty);
    _token = null;
    _state = _State.S;
  }

  ParsingNode _parseFunctionNode(ParsingContext token) {
    // todo: do not use workaround solution
    _lastFunctionToken = token;

    return lookupFunction(token);
  }

  /// Finds and extracts group to pass it to a new parser.
  ///
  /// This will not always return a [GroupNode] because of the way [_addNode]
  /// is set up. If the group contains only a single token, a
  /// [LeafNode] will be returned.
  ///
  /// It is not as easy as finding the next closing character because
  /// groups can be nested.
  ParsingNode _extractGroup() {
    // todo: do not use workaround solution
    final mode = textModeSwitchingFunctions
            .contains(supportedFunctionNames[_lastFunctionToken?.input])
        ? CaTeXMode.text
        : null;

    // Save the beginning index for error handling.
    final beginning = _index;

    // Remove the beginning of group token.
    _consumeChar();
    // Throw the character away.
    _consumeToken();

    // One group is already open because the first beginning of group
    // character was consumed before this method was called.
    var openGroups = 1;

    while (_input.isNotEmpty) {
      if (_charIs(CharacterCategory.escapeCharacter)) {
        // Consume the next two characters at once, which is equivalent
        // to escaping the next character as it might be an end of group char.
        _consumeChar();
        _consumeChar();
        continue;
      }

      if (_charIs(CharacterCategory.beginningOfGroup)) {
        _consumeChar();
        openGroups++;
        continue;
      }

      if (_charIs(CharacterCategory.endOfGroup)) {
        openGroups--;
        if (openGroups > 0) {
          _consumeChar();
          continue;
        }
        break;
      }
      // Any other character does not need require special handling.
      _consumeChar();
    }

    if (openGroups > 0) {
      throw ParsingException(
          reason:
              'Expected } after the group was opened at position $beginning',
          input: _context.input);
    }

    final groupParser = Parser._(
      _consumeToken().copyWith(mode: mode),
    );

    // Throw away the end of group character.
    _consumeChar();
    _consumeToken();

    return groupParser.parse();
  }

  /// Moves nodes that would belong to the root node of this parser
  /// to functions according to the number of arguments they require.
  void _assembleFunctions(List<ParsingNode> nodes) {
    // Need to copy the list (List.of) in order to prevent
    // concurrent modification.
    final functions = List.of(nodes
        // Reverse the order before the nodes are sorted in order to assemble
        // the arguments of functions before they are assembled
        // (when a function has a function as an argument;
        // both have the same greediness).
        .reversed
        .whereType<FunctionNode>()
        // It is possible that a function node has already been assembled.
        // For example, if we have `\frac{\frac{1}{2}}{3}`, the second frac will be
        // turned into a [FracNode] in the root node instead of a
        // [GroupNode] because it is the only node in that group after that
        // group has been parsed. Because of this, we need a way to check
        // if the second frac has already been assembled in its subgroup.
        // A way to do this is checking the children;
        // if there are none, the function node has not yet been assembled
        .where((node) => node._children.isEmpty));
    if (functions.isEmpty) return;

    // The function nodes with the highest greediness should be assembled first.
    functions.sort(
        (a, b) => b.properties.greediness.compareTo(a.properties.greediness));

    for (final function in functions) {
      final index = nodes.indexOf(function),
          arguments = function.properties.arguments;

      if (index + arguments >= nodes.length) {
        throw ParsingException(
            reason: 'Missing arguments for ${function.context.input}; '
                'expected $arguments but got ${nodes.length - index - 1}',
            input: _context.input);
      }

      assert(() {
        if (arguments == 1) return function is SingleChildNode;
        return function is MultiChildNode;
      }(),
          "$FunctionNode'"
          's are required to subclass $SingleChildNode when they '
          'have 1 argument and $MultiChildNode otherwise.');

      final start = index + 1, end = start + arguments;
      // Move the necessary nodes to the function.
      if (arguments == 1) {
        (function as SingleChildNode).child = nodes[start];
      } else {
        (function as MultiChildNode).children.addAll(nodes.sublist(start, end));
      }
      nodes.removeRange(start, end);
    }
  }

  /// Unpacks any groups in the list of [children].
  ///
  /// This prevents any groups as children of a group, which is necessary to
  /// compute spacing during rendering correctly, i.e. `=: 5` should render
  /// the same way `{=}{:5}` does. If groups were not unpacked,
  /// spacing would be messed up in the second example.
  void _unpackGroups(List<ParsingNode> children) {
    children.replaceRange(
      0,
      children.length,
      children.fold<List<ParsingNode>>(<ParsingNode>[],
          (previousValue, element) {
        if (element is GroupNode) {
          previousValue.addAll(element.children);
        } else {
          previousValue.add(element);
        }
        return previousValue;
      }),
    );
  }
}

/// Tokens used by the input processor according to *TeX by Topic* chapter 2.5.
enum _Token {
  character,

  /// Control sequences in the format of `\letters`.
  ///
  /// See also:
  ///  * [CharacterCategory.letter]
  controlWord,

  /// Control sequences in the format of `\ `, i.e. an
  /// escape character followed by a single character that is
  /// **not** a letter (see [CharacterCategory.letter]).
  ///
  /// Control spaces (`\ `) are not handled differently here.
  controlSymbol,
  // ignore: unused_field
  parameter, // todo: [parameter] is unsupported.
}

/// States of the input processor as described by *TeX by Topic* chapter 2.5.
///
/// They are in order: new line, skipping spaces, and middle of line.
enum _State {
  N,
  S,
  M,
}

/// Context that contains information that is only needed
/// to be passed down the tree while parsing.
class ParsingContext {
  /// Constructs a [ParsingContext] from an [input] string a parsing [mode].
  const ParsingContext(this.input, this.mode)
      : assert(input != null),
        assert(mode != null);

  /// The input in the part of the tree that the context describes.
  final String input;

  /// The mode in the part of the tree that the context represents.
  final CaTeXMode mode;

  /// Returns a new [ParsingContext] with overridden properties.
  ParsingContext copyWith({
    String input,
    CaTeXMode mode,
  }) =>
      ParsingContext(input ?? this.input, mode ?? this.mode);

  @override
  bool operator ==(dynamic other) {
    if (identical(other, this)) return true;

    if (other is ParsingContext) {
      return other.input == input && other.mode == mode;
    }
    return false;
  }

  @override
  int get hashCode => input.hashCode ^ mode.hashCode;
}

/// Node for every node in the tree that is created during parsing, controlling
/// the configuration of the node in the resulting rendering tree.
abstract class ParsingNode<R extends RenderNode> {
  /// Constructs a [ParsingNode] given a [context].
  const ParsingNode(this.context) : assert(context != null);

  /// The context for the part of the tree that the node represents.
  ///
  /// This context can be altered for children.
  final ParsingContext context;

  /// Creates a widget from the parsing node.
  ///
  /// Note: override [configureWidget] in subclasses and not this method.
  NodeWidget createWidget(CaTeXContext context) {
    // Adjusts the input based on the parsing context.
    final result = configureWidget(context.copyWith(input: this.context.input));
    assert(result != null,
        'Override configureWidget and return a widget for a node.');
    return result;
  }

  /// Creates the render object and configures the [context] for this node.
  ///
  /// This needs to be overridden by subclasses.
  ///
  /// The context is passed on to the [RenderNode] subclass and can be
  /// configured using [CaTeXContext.copyWith] if necessary.
  R createRenderNode(CaTeXContext context);

  /// Creates a [NodeWidget] for this node and
  /// configures the [context] for child nodes.
  ///
  /// This needs to be overridden by subclasses.
  /// Begin with calling `super.configureRenderRender(context)`.
  ///
  /// If the subclass has children, it should configure the widgets of
  /// its children in this method and then pass it to the widget it creates.
  /// The context can be modified using [CaTeXContext.copyWith] for children.
  @mustCallSuper
  @protected
  NodeWidget<R> configureWidget(CaTeXContext context) {
    assert(
        context.input == this.context.input,
        'Do not override createWidget and do not call configureWidget. '
        'This ensures that the input is passed down the tree correctly. '
        'The parsing input was ${this.context.input} but the context did '
        'not match this input and provided ${context.input} instead.');
    return null;
  }
}

/// Abstract node for nodes that configure any children.
///
/// Do not subclass this node. Instead, subclass [MultiChildNode]
/// or [SingleChildNode] depending on the number of children.
abstract class ChildrenNode<R extends RenderNode> extends ParsingNode<R> {
  /// Constructs a [ChildrenNode] given a [context].
  ChildrenNode(ParsingContext context)
      : _children = [],
        super(context);

  /// List of child nodes.
  ///
  /// This is initialized as an empty list when constructing a [ChildrenNode].
  /// The parser will populate the list.
  /// It might be a suboptimal solution in terms of immutability, however,
  /// I found it to work quite well, especially because the nodes are
  /// controlled only within the package.
  final List<ParsingNode> _children;
}

/// Super class for nodes that configure multiple children.
///
/// If a node only has a single child, subclass [SingleChildNode] instead.
abstract class MultiChildNode<R extends RenderNode> extends ChildrenNode<R> {
  /// Constructs a [MultiChildNode] given a [context].
  MultiChildNode(ParsingContext context) : super(context);

  /// Returns the full list of children that a [ChildrenNode] stores.
  List<ParsingNode> get children => _children;
}

/// Super class for nodes that configure a single child.
///
/// If a node has multiple children, subclass [MultiChildNode] instead.
abstract class SingleChildNode<R extends RenderNode> extends ChildrenNode<R> {
  /// Constructs a [SingleChildNode] given a [context].
  SingleChildNode(ParsingContext context) : super(context);

  /// Returns the single child accessible to a [SingleChildNode].
  ParsingNode get child => _children[0];

  set child(ParsingNode node) {
    assert(_children.isEmpty, 'A child must only be assigned once.');
    _children.add(node);
  }
}

/// A special kind of [ChildrenNode] that specifies [FunctionProperties].
///
/// Every function node needs this mixin in order for the parsing to work.
mixin FunctionNode<R extends RenderNode> on ChildrenNode<R> {
  FunctionProperties get properties;
}

/// Node that renders only itself.
///
/// An example for this are symbols.
abstract class LeafNode<R extends RenderNode> extends ParsingNode<R> {
  /// Constructs a [LeafNode] given a [context].
  LeafNode(ParsingContext context) : super(context);
}
