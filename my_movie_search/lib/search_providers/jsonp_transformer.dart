import 'dart:async';
import 'dart:convert';

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
class JsonPDecoder extends Converter<String, String> {
  final Object Function(Object key, Object value) _reviver;

  /// Constructs a new JsonPEncoder.
  ///
  /// The [reviver] may be `null`.
  const JsonPDecoder([Object reviver(Object key, Object value)])
      : _reviver = reviver;

  String stripJsonP(String src) {
    final startIndex = src.indexOf("{");
    final endIndex = src.lastIndexOf("}");
    return src.substring(startIndex, endIndex + 1);
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
  String convert(String input) => stripJsonP(input);

  /// Starts a conversion from a chunked JSON string to its corresponding object.
  ///
  /// The output [sink] receives exactly one decoded element through `add`.
  external StringConversionSink startChunkedConversion(Sink<Object> sink);

  // Override the base class's bind, to provide a better type.
  Stream<String> bind(Stream<String> stream) => super.bind(stream);
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
