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
      print('$prefix done');
    } catch (error, stackTrace) {
      print('$prefix ERR: ${error.toString()}');
      yield* Stream.error(error, stackTrace);
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
      print('$prefix Unexpected data type: $datatype');
      return Stream<T>.empty();
    } catch (error) {
      print('$prefix EXCEPTION: ${error.toString()}');
      rethrow;
    }
  }
}
