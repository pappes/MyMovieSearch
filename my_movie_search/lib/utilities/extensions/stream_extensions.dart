import 'dart:async';

extension StreamHelper<T> on Stream<T> {
  /// Consumes values from [input] prints them out then puts them on a new stream.
  ///
  /// For debugging purposes only.
  Stream<T> printStream([String prefix = '']) async* {
    await for (final value in this) {
      print('$prefix$value');
      yield value;
    }
  }

  Future<Stream<T>> printStreamFuture([String prefix = '']) async {
    return printStream(prefix);
  }
}
