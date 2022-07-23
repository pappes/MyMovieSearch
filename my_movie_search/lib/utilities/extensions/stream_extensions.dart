import 'dart:async';

extension StreamHelper<T> on Stream<T> {
  /// Consumes values from a stream and prints them out then puts them on a new stream.
  ///
  /// For debugging purposes only.
  Stream<T> printStream([String prefix = '']) async* {
    try {
      await for (final value in this) {
        print('$prefix $value');
        yield value;
      }
    } catch (error, stackTrace) {
      print('$prefix ERR: ${error.toString()}');
      yield* Stream.error(error, stackTrace);
    }
  }
}

extension FutureStreamHelper<T> on Future<T?> {
  /// Consumes values from a future stream and prints them out
  /// then puts them on a new future stream.
  ///
  /// For debugging purposes only.
  Future<T?> printStreamFuture([String prefix = '']) async {
    try {
      final T? awaited = await this;
      if (awaited is Stream) {
        final newStream = awaited.printStream(prefix);
        return newStream as T;
      }
      String datatype =
          (awaited == null) ? 'null' : awaited.runtimeType.toString();
      print('$prefix Unexpected data type: $datatype');
      return null;
    } catch (error, stackTrace) {
      print('$prefix EXCEPTION: ${error.toString()}');
      rethrow;
    }
  }
}
