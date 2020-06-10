import 'package:catex/src/lookup/exception.dart';
import 'package:catex/src/parsing/character.dart';
import 'package:catex/src/parsing/functions/font.dart';
import 'package:catex/src/parsing/functions/frac.dart';
import 'package:catex/src/parsing/functions/sub_sup.dart';
import 'package:catex/src/parsing/group.dart';
import 'package:catex/src/parsing/parsing.dart';
import 'package:catex/src/parsing/symbols.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(r'\epsilon\frac 1 3', () {
    final rootNode = Parser(r'\epsilon\frac 1 3').parse();
    test('creates group as root node', () {
      expect(rootNode, isA<GroupNode>());
    });

    test('recognizes two tokens in the root group', () {
      expect((rootNode as GroupNode).children, hasLength(2));
    });

    test('recognizes symbol', () {
      expect((rootNode as GroupNode).children[0], isA<SymbolNode>());
    });

    test('correctly passes token to symbol', () {
      expect(((rootNode as GroupNode).children[0] as SymbolNode).context.input,
          equals(r'\epsilon'));
    });

    test('recognizes function', () {
      expect((rootNode as GroupNode).children[1], isA<FunctionNode>());
    });

    test('correctly passes token to function', () {
      expect(
          ((rootNode as GroupNode).children[1] as FunctionNode).context.input,
          equals(r'\frac'));
    });

    test('correctly passes two nodes to frac', () {
      expect(((rootNode as GroupNode).children[1] as MultiChildNode).children,
          hasLength(2));
    });

    test('passes two character nodes with the correct input to frac', () {
      final function = (rootNode as GroupNode).children[1] as MultiChildNode;
      expect(function.children[0], isA<CharacterNode>());
      expect(function.children[1], isA<CharacterNode>());
      expect(function.children[0].context.input, equals('1'));
      expect(function.children[1].context.input, equals('3'));
    });
  });

  group(r'\frac{}', () {
    final parser = Parser(r'\frac{}');

    test('fails because of invalid input', () {
      expect(parser.parse, throwsA(isA<ParsingException>()));
    });

    test('recognizes that ' r'\frac' ' requires 2 arguments but got 1', () {
      try {
        parser.parse();
      } on ParsingException catch (e) {
        expect(e.message, contains('expected 2 but got 1'));
      }
    });
  });

  group(r'\epsilon = \frac 2 {3 + 2}', () {
    final rootNode = Parser(r'\epsilon = \frac 2 {3 + 2}').parse() as GroupNode;

    test('3 children in the root node', () {
      expect(rootNode.children, hasLength(3));
    });

    test('parses symbol, single character, and function into the root group',
        () {
      expect(rootNode.children[0], isA<SymbolNode>());
      expect(rootNode.children[1], isA<CharacterNode>());
      expect(rootNode.children[2], isA<FunctionNode>());
    });

    test('passes two arguments to ' r'\frac', () {
      expect((rootNode.children[2] as MultiChildNode).children, hasLength(2));
    });

    test(r'\frac a character and a group argument', () {
      final children = (rootNode.children[2] as MultiChildNode).children;
      expect(children[0], isA<CharacterNode>());
      expect(children[1], isA<GroupNode>());
    });
  });

  group(r'\sf{\bf{\textcolor{red}s}}', () {
    FontNode rootNode;

    test('succeeds with a single node (function) as the root node', () {
      expect(() => rootNode = Parser(r'\sf{\bf{\textcolor{red}s}}').parse(),
          returnsNormally);
    });

    test('child is another font node', () {
      expect(rootNode.child, isA<FontNode>());
    });
  });

  group(r'\sf{\bf{word}}', () {
    FontNode rootNode;

    test('succeeds with single function root node', () {
      expect(
          () => rootNode = Parser(r'\sf{\bf{word}}').parse(), returnsNormally);
    });

    test('child is another font node', () {
      expect(rootNode.child, isA<FontNode>());
    });
  });

  group(r'\varepsilon = \frac{\frac{2}{1}}{3}', () {
    GroupNode rootNode;

    test('succeeds with group root node', () {
      expect(
          () =>
              rootNode = Parser(r'\varepsilon = \frac{\frac{2}{1}}{3}').parse(),
          returnsNormally);
    });

    List<ParsingNode> children;

    test('three nodes in the root', () {
      expect(rootNode.children, hasLength(3));
      expect(() => children = rootNode.children, returnsNormally);
    });

    test('one ' r'\varepsilon' ' and two ' r'\frac', () {
      expect(children[0], isA<SymbolNode>());
      expect(children[1], isA<CharacterNode>());
      expect(children[2], isA<FracNode>());
    });

    test(
        '2 and 1 on second '
        r'\frac'
        ' and '
        r'\frac'
        ' and 3 on the second one', () {
      final first = children[2] as FracNode;
      FracNode second;
      expect(() => second = first.children[0], returnsNormally);
      expect(first.children[1].context.input, equals('3'));
      expect(second.children[0].context.input, equals('2'));
      expect(second.children[1].context.input, equals('1'));
    });
  });

  group(r'7^\frac{4}{2}', () {
    GroupNode rootNode;

    test('configures root node successfully', () {
      expect(
          () => rootNode = Parser(r'7^\frac{4}{2}').parse(), returnsNormally);
    });

    test('detects character and sup function node', () {
      expect(rootNode.children[0], isA<CharacterNode>());
      expect(rootNode.children[1], isA<SubSupNode>());
    });
  });
}
