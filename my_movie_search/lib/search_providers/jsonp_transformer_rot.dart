import 'dart:convert';

//code adapted from https://dart.dev/articles/archive/converters-and-codecs
//Let’s start with the simple synchronous converter, whose encryption routine simply rotates bytes by the given key:

class JsonPState {
  JsonPState() {
    buffering = false;
    buffer = "";
  }
  var buffering;
  var buffer;
}

/// A simple extension of Rot13 to bytes and a key.
class JsonPConverter extends Converter<String, String> {
  final _key;
  const JsonPConverter(this._key);

  String convert(String data, {int key, JsonPState conversionState}) {
    // TODO: default key to ( if none supplied
    if (key == null) key = this._key;
    var ready = data;

    if (conversionState != null) {
      if (conversionState.buffering) {
        conversionState.buffer += data;
        return "";
      }
      return ready;
    }
  }
}
//The corresponding Codec class is also simple:

class JsonPCodec extends Codec<String, String> {
  final _key;
  var _state;
  JsonPCodec(this._key) {
    _state = JsonPState();
  }

  String encode(String data, {int key}) {
    if (key == null) key = this._key;
    return new JsonPConverter(key).convert(data, conversionState: _state);
  }

  String decode(String data, {int key}) {
    if (key == null) key = this._key;
    return new JsonPConverter(key).convert(data, conversionState: _state);
  }

  JsonPConverter get encoder => new JsonPConverter(_key);
  JsonPConverter get decoder => new JsonPConverter(_key);

  JsonPSink startChunkedConversion(sink) {
    return new JsonPSink(_key, sink);
  }
}
//We can (and should) avoid some of the new allocations, but for simplicity we allocate a new instance of RotConverter every time one is needed.

/* //This is how we use the Rot codec:

const Rot ROT128 = const Rot(128);
const Rot ROT1 = const Rot(1);
main() {

  print(const RotConverter(128).convert([0, 128, 255, 1]));   // [128, 0, 127, 129]
  print(const RotConverter(128).convert([128, 0, 127, 129])); // [0, 128, 255, 1]
  print(const RotConverter(-128).convert([128, 0, 127, 129]));// [0, 128, 255, 1]

  print(ROT1.decode(ROT1.encode([0, 128, 255, 1])));          // [0, 128, 255, 1]
  print(ROT128.decode(ROT128.encode([0, 128, 255, 1])));      // [0, 128, 255, 1]
}
*/
//We are on the right track. The codec works, but it is still missing the chunked encoding part. Because each byte is encoded separately we can fall back to the synchronous conversion method:

class JsonPSink extends ChunkedConversionSink<String> {
  final _converter;
  final ChunkedConversionSink<String> _outSink;
  JsonPSink(key, this._outSink) : _converter = new JsonPConverter(key);

  void add(String data) {
    _outSink.add(_converter.convert(data));
  }

  void close() {
    _outSink.close();
  }
}
/* //Now, we can use the converter with chunked conversions or even for stream transformations:

// Requires to import dart:io.
main(args) {
  String inFile = args[0];
  String outFile = args[1];
  int key = int.parse(args[2]);
  new File(inFile)
    .openRead()
    .transform(new RotConverter(key))
    .pipe(new File(outFile).openWrite());
}
*/
