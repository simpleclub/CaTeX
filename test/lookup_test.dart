import 'dart:ui';

import 'package:catex/src/lookup/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parseColor', () {
    // HTML color keyword
    test('blue', () {
      expect(
        parseColor('blue'),
        equals(const Color(0xff0000ff)),
      );
    });

    // Hexadecimal
    test('faebd7', () {
      expect(
        parseColor('faebd7'),
        equals(const Color(0xfffaebd7)),
      );
    });

    // Hexadecimal with leading hash
    test('#8a2be2', () {
      expect(
        parseColor('#8a2be2'),
        equals(parseColor('blueviolet')),
      );
    });

    // String with spaces
    test('  #cd5c5c ', () {
      expect(
        parseColor('  #cd5c5c '),
        equals(parseColor('indianred')),
      );
    });

    // Flutter Material color
    test('deepPurple', () {
      expect(
        parseColor('deepPurple'),
        // Cannot use Colors.deepPurple on its own because
        // that is a MaterialColor and the parse function returns regular
        // Color objects only.
        equals(Color(Colors.deepPurple.value)),
      );
    });
  });
}
