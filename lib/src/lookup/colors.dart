import 'dart:ui';

import 'package:flutter/material.dart';

/// Colors supported by CaTeX color functions, e.g. `\textcolor` & `\colorbox`.
///
/// These colors are only for the proof of concept and
/// definitely not what other TeX implementations support.
/// They are taken from the Material [Colors] class.
const supportedColors = <String, Color>{
  'red': Color(0xfff44336),
  'pink': Color(0xffe91e63),
  'purple': Color(0xff9c27b0),
  'deepPurple': Color(0xff673ab7),
  'indigo': Color(0xff3f51b5),
  'blue': Color(0xff2196f3),
  'lightBlue': Color(0xff03a9f4),
  'cyan': Color(0xff00bcd4),
  'teal': Color(0xff009688),
  'green': Color(0xff4caf50),
  'lightGreen': Color(0xff8bc34a),
  'lime': Color(0xffcddc39),
  'yellow': Color(0xffffeb3b),
  'amber': Color(0xffffc107),
  'orange': Color(0xffff9800),
  'deepOrange': Color(0xffff5722),
  'brown': Color(0xff795548),
  'grey': Color(0xff9e9e9e),
  'blueGrey': Color(0xff607d8b),
  'black': Color(0xff000000),
  'white': Color(0xffffffff),
};
