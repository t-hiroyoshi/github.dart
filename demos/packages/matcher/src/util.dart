// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library matcher.util;

import 'core_matchers.dart';
import 'interfaces.dart';

/// A [Map] between whitespace characters and their escape sequences.
const _escapeMap = const {
  '\n': r'\n',
  '\r': r'\r',
  '\f': r'\f',
  '\b': r'\b',
  '\t': r'\t',
  '\v': r'\v',
};

/// A [RegExp] that matches whitespace characters that should be escaped.
final _escapeRegExp =
    new RegExp("[${_escapeMap.keys.map(_getHexLiteral).join()}]");

/// Useful utility for nesting match states.
void addStateInfo(Map matchState, Map values) {
  var innerState = new Map.from(matchState);
  matchState.clear();
  matchState['state'] = innerState;
  matchState.addAll(values);
}

/// Takes an argument and returns an equivalent [Matcher].
///
/// If the argument is already a matcher this does nothing,
/// else if the argument is a function, it generates a predicate
/// function matcher, else it generates an equals matcher.
Matcher wrapMatcher(x) {
  if (x is Matcher) {
    return x;
  } else if (x is Function) {
    return predicate(x);
  } else {
    return equals(x);
  }
}

/// Returns [str] with all whitespace characters represented as their escape
/// sequences.
///
/// Backslash characters are escaped as `\\`
String escape(String str) {
  str = str.replaceAll('\\', r'\\');
  return str.replaceAllMapped(_escapeRegExp, (match) {
    return _escapeMap[match[0]];
  });
}

/// Given single-character string, return the hex-escaped equivalent.
String _getHexLiteral(String input) {
  int rune = input.runes.single;
  return r'\x' + rune.toRadixString(16).padLeft(2, '0');
}