import 'dart:convert' show Converter;

class JsonPState {
  JsonPState();
  bool activated = false; // true if stream has encounted [, { or (
  bool buffering = false; // true if stream stripped a JSONP prefix.
  String buffer = ''; // Stream content that has not been released.

  @override
  String toString() =>
      "activated=$activated buffering=$buffering buffer=$buffer";
}

class JsonPConversionSink implements Sink<String> {
  final Sink<Object> _sink;
  final JsonPDecoder _jsonPDecoder;

  JsonPConversionSink(this._sink, this._jsonPDecoder);
  @override
  void add(String x) => _sink.add(_jsonPDecoder.convert(x));
  @override
  void close() => _sink.close();
}

/// Parses JSONP string streams and builds the json string stream.
///
/// When used as a [StreamTransformer], the input stream may emit
/// multiple strings. Where necesary streamed input will be buffered.
/// If the JS function name is not supplied it is inferred from syntax.
///
/// ```dart
/// // Strip JSONP if required
/// final Stream<String> jsonStream;
/// if (transformJsonP) {
///   jsonStream = httpClientStream.transform(JsonPDecoder());
/// } else {
///   jsonStream = httpClientStream;
/// }
/// ```
class JsonPDecoder extends Converter<String, String> {
  final _state = JsonPState();

  final String? _jsFunction;

  /// Constructs a new JsonPEncoder.
  JsonPDecoder([this._jsFunction]);

  /// Converts the given JSONP-string [input] to its corresponding json.
  @override
  String convert(String input) {
    var output = '';
    if (_state.activated) {
      output = input;
    } else {
      output = stripPrefix(stripCriteria(input));
    }
    if (_state.buffering) output = bufferSuffix(output);
    return output;
  }

  // Internal function to strip [_criteria] from the start of the string stream.
  String stripCriteria(String input) {
    if (null != _jsFunction) {
      return input.replaceFirst(_jsFunction!, '');
    }
    return input;
  }

  // Internal function to strip FunctionName( from the start of the string stream.
  // Strips nothing if [ or { is encountered before (
  String stripPrefix(String input) {
    final firstRound = input.indexOf("(");
    final firstCurly = input.indexOf("{");
    final firstSquare = input.indexOf("[");
    if (firstRound == -1 && firstCurly == -1 && firstSquare == -1) {
      // JSON has not started, JSONP has not finished
      return "";
    }

    // Monitor for start of JSONP inner contents or start of JSON.
    // i.e. skip any leading blank lines.
    if (firstRound > -1 || firstCurly > -1 || firstSquare > -1) {
      // Ready to strip prefix (if required)
      _state.activated = true;
    }
    if ((firstRound == -1) ||
        (firstCurly > -1 && firstCurly < firstRound) ||
        (firstSquare > -1 && firstSquare < firstRound)) {
      // JSON encoded text starts before JSONP wrapper so no conversion required.
      return input;
    }
    // Found valid JSONP need to trim start.
    _state.buffering = true;
    return input.substring(firstRound + 1, input.length);
  }

  // Internal function to Strip ) from the end of the string stream.
  // Strips nothing if no valid JSONP prefix has been encountered.
  // Buffers stripped text to allow it to be emitted if further text is streamed.
  String bufferSuffix(String input) {
    if (_state.buffering) {
      final lastRound = input.lastIndexOf(")");
      final lastCurly = input.lastIndexOf("}");
      final lastSquare = input.lastIndexOf("]");
      final firstRound = input.indexOf("(");
      final firstCurly = input.indexOf("{");
      final firstSquare = input.indexOf("[");
      String output = "";

      if (_state.buffer.isNotEmpty) {
        if (firstRound > -1 ||
            firstCurly > -1 ||
            firstSquare > -1 ||
            lastRound > -1 ||
            lastCurly > -1 ||
            lastSquare > -1) {
          // Release buffer if more json has been received.
          output = _state.buffer;
          _state.buffer = "";
        } else {
          _state.buffer += input;
          return "";
        }
      }
      if ((lastRound == -1) ||
          (firstRound > -1 && firstRound > lastRound) ||
          (firstCurly > -1 && firstCurly > lastRound) ||
          (firstSquare > -1 && firstSquare > lastRound) ||
          (lastCurly > -1 && lastCurly > lastRound) ||
          (lastSquare > -1 && lastSquare > lastRound)) {
        // JSON encoded text continues after last round bracket no buffering required.
        return output + input;
      }
      // Found valid close bracket, need to buffer.
      _state.buffer = input.substring(lastRound, input.length);
      return output + input.substring(0, lastRound);
    }
    return input;
  }

  // Helper function to see inside the decoder state.
  @override
  String toString() => _state.toString();

  /// Starts a conversion from a chunked JSONP string to its corresponding JSON string.
  ///
  /// The output [sink] receives one string element per input element through `add`.
  @override
  Sink<String> startChunkedConversion(Sink<Object> sink) =>
      JsonPConversionSink(sink, this);
}
