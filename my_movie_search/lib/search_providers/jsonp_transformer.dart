import 'dart:async';
import 'dart:convert';

class JsonPState {
  JsonPState() {
    buffering = false;
    buffer = "";
  }
  var buffering;
  var buffer;
}

/// This class parses JSONP string streams and builds the json string stream.
///
/// When used as a [StreamTransformer], the input stream may emit
/// multiple strings. Where necesary streamed input will be buffered.
class JsonPDecoder extends Converter<String, String> {
  final _state;

  /// Constructs a new JsonPEncoder.
  ///
  /// The [reviver] may be `null`.
  JsonPDecoder() : _state = JsonPState();

  String stripPrefix(String input) {
    if (!_state.buffering) {
      final firstRound = input.indexOf("(");
      final firstCurly = input.indexOf("{");
      final firstSquare = input.indexOf("[");

      // Monitor for start of jsonp inner contents or start of json
      if (firstRound > -1 || firstCurly > -1 || firstSquare > -1) {
        _state.buffering = true;
      }
      if ((firstRound == -1) ||
          (firstCurly > -1 && firstCurly < firstRound) ||
          (firstSquare > -1 && firstSquare < firstRound)) {
        //json encoded text starts before JSONP wrapper so no conversion required
        return input;
      }
      // Found valid JSONP need to trim start
      return input.substring(firstRound + 1, input.length);
    }
    return input;
  }

  String bufferSuffix(String input) {
    if (_state.buffering) {
      final lastRound = input.indexOf(")");
      final lastCurly = input.indexOf("}");
      final lastSquare = input.indexOf("]");
      var output = "";

      // Release buffer if more json has been received
      if (lastRound > -1 || lastCurly > -1 || lastSquare > -1) {
        output = _state.buffer;
        _state.buffer = "";
      }
      if ((lastRound == -1) ||
          (lastCurly > -1 && lastCurly > lastRound) ||
          (lastSquare > -1 && lastSquare > lastRound)) {
        //json encoded text continues after lst round braket no buffering required
        return output + input;
      }
      // Found valid close braket, need to buffer
      _state.buffer = input.substring(lastRound, input.length);
      return output + input.substring(0, lastRound);
    }
    return input;
  }

  /// Converts the given JSONP-string [input] to its corresponding json.
  ///
  String convert(String input) {
    var output = input;
    if (!_state.buffering) output = stripPrefix(output);
    if (_state.buffering) output = stripPrefix(output);
    return output;
  }

  /// Starts a conversion from a chunked JSON string to its corresponding object.
  ///
  /// The output [sink] receives exactly one decoded element through `add`.
  //external StringConversionSink startChunkedConversion(Sink<Object> sink);
  StringConversionSink startChunkedConversion(Sink<Object> sink) {
    StringConversionSink stringSink;
    if (sink is StringConversionSink) {
      stringSink = sink;
    } else {
      stringSink = StringConversionSink.from(sink);
    }
    return stringSink;
  }
}

/*

const JsonPCodec jsonp = JsonPCodec();

/// A [JsonPCodec] encodes JSON objects to strings and decodes strings to
/// JSON objects.
///
/// Examples:
///
///     var encoded = json.encode([1, 2, { "a": null }]);
///     var decoded = json.decode('["foo", { "bar": 499 }]');
class JsonPCodec extends Codec<String, String> {
  final Object Function(Object key, Object value) _reviver;
  final Object Function(dynamic) _toEncodable;

  /// Creates a `JsonPCodec` with the given reviver and encoding function.
  ///
  /// The [reviver] function is called during decoding. It is invoked once for
  /// each object or list property that has been parsed.
  /// The `key` argument is either the integer list index for a list property,
  /// the string map key for object properties, or `null` for the final result.
  ///
  /// If [reviver] is omitted, it defaults to returning the value argument.
  ///
  /// The [toEncodable] function is used during encoding. It is invoked for
  /// values that are not directly encodable to a string (a value that is not a
  /// number, boolean, string, null, list or a map with string keys). The
  /// function must return an object that is directly encodable. The elements of
  /// a returned list and values of a returned map do not need to be directly
  /// encodable, and if they aren't, `toEncodable` will be used on them as well.
  /// Please notice that it is possible to cause an infinite recursive regress
  /// in this way, by effectively creating an infinite data structure through
  /// repeated call to `toEncodable`.
  ///
  /// If [toEncodable] is omitted, it defaults to a function that returns the
  /// result of calling `.toJson()` on the unencodable object.
  const JsonPCodec(
      {Object reviver(Object key, Object value),
      Object toEncodable(dynamic object)})
      : _reviver = reviver,
        _toEncodable = toEncodable;

  /// Creates a `JsonPCodec` with the given reviver.
  ///
  /// The [reviver] function is called once for each object or list property
  /// that has been parsed during decoding. The `key` argument is either the
  /// integer list index for a list property, the string map key for object
  /// properties, or `null` for the final result.
  JsonPCodec.withReviver(dynamic reviver(Object key, Object value))
      : this(reviver: reviver);

  /// Parses the string and returns the resulting Json object.
  ///
  /// The optional [reviver] function is called once for each object or list
  /// property that has been parsed during decoding. The `key` argument is either
  /// the integer list index for a list property, the string map key for object
  /// properties, or `null` for the final result.
  ///
  /// The default [reviver] (when not provided) is the identity function.
  String decode(String source, {Object reviver(Object key, Object value)}) {
    reviver ??= _reviver;
    if (reviver == null) return decoder.convert(source);
    return JsonPDecoder(reviver).convert(source);
  }

  /// Converts [value] to a JSON string.
  ///
  /// If value contains objects that are not directly encodable to a JSON
  /// string (a value that is not a number, boolean, string, null, list or a map
  /// with string keys), the [toEncodable] function is used to convert it to an
  /// object that must be directly encodable.
  ///
  /// If [toEncodable] is omitted, it defaults to a function that returns the
  /// result of calling `.toJson()` on the unencodable object.
  String encode(Object value, {Object toEncodable(dynamic object)}) {
    toEncodable ??= _toEncodable;
    if (toEncodable == null) return encoder.convert(value);
    return JsonEncoder(toEncodable).convert(value);
  }

  JsonPEncoder get encoder {
    if (_toEncodable == null) return const JsonPEncoder();
    return JsonPEncoder(_reviver);
//    return JsonPEncoder(_toEncodable);
  }

  JsonPDecoder get decoder {
    if (_reviver == null) return const JsonPDecoder();
    return JsonPDecoder(_reviver);
  }
}




/// This class parses JSON strings and builds the corresponding objects.
///
/// A JSON input must be the JSON encoding of a single JSON value,
/// which can be a list or map containing other values.
///
/// When used as a [StreamTransformer], the input stream may emit
/// multiple strings. The concatenation of all of these strings must
/// be a valid JSON encoding of a single JSON value.
class JsonPEncoder extends Converter<String, String> {
  final Object Function(Object key, Object value) _reviver;

  /// Constructs a new JsonPEncoder.
  ///
  /// The [reviver] may be `null`.
  const JsonPEncoder([Object reviver(Object key, Object value)])
      : _reviver = reviver;

  String addJsonP(String src) {
    return src;
  }

  /// Converts the given JSON-string [input] to its corresponding object.
  ///
  /// Parsed JSON values are of the types [num], [String], [bool], [Null],
  /// [List]s of parsed JSON values or [Map]s from [String] to parsed JSON
  /// values.
  ///
  /// If `this` was initialized with a reviver, then the parsing operation
  /// invokes the reviver on every object or list property that has been parsed.
  /// The arguments are the property name ([String]) or list index ([int]), and
  /// the value is the parsed value. The return value of the reviver is used as
  /// the value of that property instead the parsed value.
  ///
  /// Throws [FormatException] if the input is not valid JSON text.
  String convert(String input) => addJsonP(input);

  /// Starts a conversion from a chunked JSON string to its corresponding object.
  ///
  /// The output [sink] receives exactly one decoded element through `add`.
  external StringConversionSink startChunkedConversion(Sink<Object> sink);

  // Override the base class's bind, to provide a better type.
  Stream<String> bind(Stream<String> stream) => super.bind(stream);
}
*/
