// Mocks generated by Mockito 5.4.2 from annotations
// in my_movie_search/test/mmsnav_unit_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:flutter/material.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:my_movie_search/utilities/navigation/web_nav.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [MMSFlutterCanvas].
///
/// See the documentation for Mockito's code generation for more information.
class MockMMSFlutterCanvas extends _i1.Mock implements _i2.MMSFlutterCanvas {
  MockMMSFlutterCanvas() {
    _i1.throwOnMissingStub(this);
  }

  @override
  set context(_i3.BuildContext? _context) => super.noSuchMethod(
        Invocation.setter(
          #context,
          _context,
        ),
        returnValueForMissingStub: null,
      );

  @override
  void viewWebPage(String? url) => super.noSuchMethod(
        Invocation.method(
          #viewWebPage,
          [url],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i4.Future<Object?> viewFlutterPage(_i2.RouteInfo? page) =>
      (super.noSuchMethod(
        Invocation.method(
          #viewFlutterPage,
          [page],
        ),
        returnValue: _i4.Future<Object?>.value(),
      ) as _i4.Future<Object?>);
}
