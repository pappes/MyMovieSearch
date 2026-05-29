import 'dart:async';

import 'package:my_movie_search/utilities/app_logger.dart';
import 'package:my_movie_search/utilities/extensions/string_extensions.dart';

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
          AppLogger.instance.info('$prefix ${text.truncate(limit)}  ...');
        } else {
          AppLogger.instance.info('$prefix $value');
        }
        yield value;
      }
      AppLogger.instance.info('$prefix done');
    } catch (error, stackTrace) {
      AppLogger.instance.info('$prefix ERR: $error');
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
      final datatype = (awaited == null)
          ? 'null'
          : awaited.runtimeType.toString();
      AppLogger.instance.warning('$prefix Unexpected data type: $datatype');
      return Stream<T>.empty();
    } catch (error) {
      AppLogger.instance.warning('$prefix EXCEPTION: $error');
      rethrow;
    }
  }
}
