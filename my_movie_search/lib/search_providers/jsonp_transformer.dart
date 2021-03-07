import 'dart:async';
import 'dart:convert';

class JsonPState {
  JsonPState() {
    activated = false;
    buffering = false;
    buffer = "";
  }
  var activated; // true if stream has encounted [, { or (
  var buffering; // true if stream stripped a JSONP prefix.
  var buffer; // Stream content that has not been released.

  String toString() {
    return "activated=$activated buffering=$buffering buffer=$buffer";
  }
}

class JsonPConversionSink extends Sink<String> {
  final _sink;
  final _jsonPDecoder;

  JsonPConversionSink(this._sink, this._jsonPDecoder);
  add(x) => _sink.add(_jsonPDecoder.convert(x));
  close() => _sink.close();
}

/// This class parses JSONP string streams and builds the json string stream.
///
/// When used as a [StreamTransformer], the input stream may emit
/// multiple strings. Where necesary streamed input will be buffered.
class JsonPDecoder extends Converter<String, String> {
  final _state;

  /// Constructs a new JsonPEncoder.
  JsonPDecoder() : _state = JsonPState();

  /// Converts the given JSONP-string [input] to its corresponding json.
  String convert(String input) {
    var output = "";
    if (_state.activated)
      output = input;
    else
      output = stripPrefix(input);
    if (_state.buffering) output = bufferSuffix(output);
    return output;
  }

  // Internal function to Strip FunctionName( from the start of the string stream.
  // Strips nothing if [ or { is encountered before (
  String stripPrefix(String input) {
    if (_state.activated) {
      // Prefix has already been stripped (or did not need to be stripped.)
      return input;
    }

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
      var output = "";

      if (_state.buffer.length > 0) {
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
  String toString() {
    return _state.toString();
  }

  /// Starts a conversion from a chunked JSONP string to its corresponding JSON string.
  ///
  /// The output [sink] receives one string element per input element through `add`.
  Sink<String> startChunkedConversion(Sink<Object> sink) {
    return JsonPConversionSink(sink, this);
  }
}
