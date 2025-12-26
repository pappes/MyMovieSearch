import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';

extension StreamHelper<T> on Stream<T> {
  /// Consumes values from a stream
  /// and prints them out then puts them on a new stream.
  ///
  /// For debugging purposes only.
  Stream<T> printStream([String prefix = '', int limit = 1000]) async* {
    try {
      await for (final value in this) {
        final text = value.toString();
        if (text.length > limit) {
          logger.i('$prefix ${text.characters.take(limit)}  ...');
        } else {
          logger.i('$prefix $value');
        }
        yield value;
      }
      logger.i('$prefix done');
    } catch (error, stackTrace) {
      logger.i('$prefix ERR: $error');
      yield* Stream<T>.error(error, stackTrace);
    }
  }
}

extension FutureStreamHelper<T> on Future<Stream<T>?> {
  /// Consumes values from a future stream and prints them out
  /// then puts them on a new future stream.
  ///
  /// For debugging purposes only.
  Future<Stream<T>> printStreamFuture([String prefix = '']) async {
    try {
      final Stream<T>? awaited = await this;
      if (awaited is Stream && awaited != null) {
        final newStream = awaited.printStream(prefix);
        return newStream;
      }
      final datatype =
          (awaited == null) ? 'null' : awaited.runtimeType.toString();
      logger.w('$prefix Unexpected data type: $datatype');
      return Stream<T>.empty();
    } catch (error) {
      logger.w('$prefix EXCEPTION: $error');
      rethrow;
    }
  }
}
