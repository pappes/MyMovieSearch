import 'dart:async';
import 'dart:isolate';

/// Implement 'isolate' functionality so that 'compute' requests
/// processed in a seperate thread can remember data
/// and return computation results.
///
/// Sample usage maintianing state in other thread:
///   final threader = SlowThread();
///   final val = await threader.runAsync(myFunction, input1);
///   final val = await threader.runAsync(myFunction, input2);
///
/// Sample usage(stateless):
///   final val = await SlowThread().runAsync(myFunction, input);
///
/// Sample usage using factory constructor:
///   final val = await SlowThread('VerySlow').runAsync(myFunction, input1);
///   final val = await SlowThread('VerySlow').runAsync(myFunction, input2);
class SlowThread {
  late SendPort _mainThreadOutboundPort;

  bool ready = false;
  late Future<bool> initialised;
  final _completer = Completer<bool>();

  static final Map<String, SlowThread> _namedThreads = {};

  SlowThread() {
    initialised = _completer.future;
    _init();
  }

  /// Convenience constructor to keep track of threads.
  factory SlowThread.namedThread(String name) {
    if (_namedThreads.containsKey(name)) return _namedThreads[name]!;
    final thread = SlowThread();
    _namedThreads[name] = thread;
    return thread;
  }

  /// Requests execution of [function] with value [parameter]
  ///
  /// Function must take exactly one parameter.
  /// Function can be async or synchronous.
  /// Function must not be a closure, unnamed function or non-static member function.
  /// Function must be a static class member or global function to avoid the runtime exception
  ///     Invalid argument(s): Illegal argument in isolate message :
  ///     (object is a closure - Function '<function_name>')
  ///
  /// Function should not call any libraries that attempt to write to common objects
  ///     e.g. external files, etc because the libraries may not be thread safe
  ///     console appears to be thread safe.
  Future run<T>(Function(T) function, T parameter) async {
    final receivePort = ReceivePort();
    final message = {'fn': function, 'param': parameter};
    if (!ready) await initialised;

    _mainThreadOutboundPort.send([message, receivePort.sendPort]);

    return receivePort.first;
  }

  /// Spawn another thread and capture port to send future requests to.
  Future _init() async {
    final receivePort = ReceivePort();

    // Spawn another thread and wait to recieve a port for the main thread to talk on.
    await Isolate.spawn(_runOnOtherThread, receivePort.sendPort);
    _mainThreadOutboundPort = await receivePort.first as SendPort;
    ready = true;
    _completer.complete(ready);
  }

  /// Function to process any incomming requests.
  static Future<void> _runOnOtherThread(SendPort initialOutboundPort) async {
    final inboundPort = ReceivePort();

    // Notify caller which port they can use to send compute requests on.
    initialOutboundPort.send(inboundPort.sendPort);

    // Execute requests as they are received.
    await for (final request in inboundPort) {
      final incommingMessage = request[0] as Map;
      final msgOutboundPort = request[1] as SendPort;
      final fn = incommingMessage['fn'] as Function;
      final parameter = incommingMessage['param'];
      final result = await fn(parameter);
      msgOutboundPort.send(result);
    }
  }
}
