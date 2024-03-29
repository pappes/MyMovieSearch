import 'dart:async';
import 'dart:isolate';

/// Move processing off the main thread into separate long lived threads.
///
/// Implement 'isolate' functionality so that 'compute' requests
/// processed in a seperate thread can remember data
/// and return computation results.
///
/// Sample usage maintianing state in other thread:
/// ```dart
/// final threader = ThreadRunner();
/// final val = await threader.runAsync(myFunction, input1);
/// final val = await threader.runAsync(myFunction, input2);
/// ```
///
/// Sample usage(stateless):
/// ```dart
/// final val = await ThreadRunner().runAsync(myFunction, input);
/// ```
///
/// Sample usage using a named thread:
/// ```dart
/// final val = await
///          ThreadRunner(ThreadRunner.slow).runAsync(myFunction, input1);
/// final val = await
///          ThreadRunner(ThreadRunner.verySlow).runAsync(myFunction, input2);
/// ```
class ThreadRunner {
  ThreadRunner() {
    initialised = _completer.future;
    unawaited(_init(latestThreadName ?? 'Unnamed Thread'));
  }

  /// Convenience constructor to keep track of threads.
  factory ThreadRunner.namedThread(String name) {
    if (_namedThreads.containsKey(name)) return _namedThreads[name]!;
    latestThreadName = name;
    final thread = ThreadRunner();
    latestThreadName = null;
    _namedThreads[name] = thread;
    return thread;
  }

  late SendPort _mainThreadOutboundPort;
  static const String fast = 'Fast Thread';
  static const String slow = 'Slow Thread';
  static const String verySlow = 'Very Slow Thread';
  static String? latestThreadName;
  static String? currentThreadName = 'Default Thread';

  bool ready = false;
  late Future<bool> initialised;
  final _completer = Completer<bool>();

  static final Map<String, ThreadRunner> _namedThreads = {};

  /// Requests execution of [function] with value [parameter]
  ///
  /// Function must take exactly one parameter.
  /// Function can be async or synchronous.
  ///
  /// ```dart
  /// // explicit parameter typecast
  /// final res1 = ThreadRunner().run<int>(myFunction, 0);
  /// // implicit parameter type
  /// final res2 = ThreadRunner().run(myFunction, 0);
  /// ````
  ///
  /// DART V2.14 and prior had the following restrictions:
  /// Function must not be a closure,
  /// unnamed function or non-static member function.
  /// Function must be a static class member or
  /// global function to avoid the runtime exception
  ///     Invalid argument(s): Illegal argument in isolate message :
  ///     (object is a closure - Function '<function_name>')
  ///
  /// Function should not call any libraries
  /// that attempt to write to common objects
  ///     e.g. external files, etc because the libraries may not be thread safe
  ///     console appears to be thread safe.
  Future<dynamic> run<T>(dynamic Function(T) function, T parameter) async {
    final receivePort = ReceivePort();
    final message = {'fn': function, 'param': parameter};
    if (!ready) await initialised;

    _mainThreadOutboundPort.send([message, receivePort.sendPort]);

    return receivePort.first;
  }

  /// Spawn another thread and capture port to send future requests to.
  Future<void> _init(String threadName) async {
    final receivePort = ReceivePort();

    // Spawn another thread and wait to receive a port
    // for the main thread to talk on.
    await Isolate.spawn(_runOnOtherThread, {
      'port': receivePort.sendPort,
      'threadName': threadName,
    });
    _mainThreadOutboundPort = await receivePort.first as SendPort;
    ready = true;
    _completer.complete(ready);
  }

  /// Function to process any incoming requests.
  static Future<void> _runOnOtherThread(Map<String, dynamic> params) async {
    final initialOutboundPort = params['port'] as SendPort;

    currentThreadName = params['threadName'] as String;
    final inboundPort = ReceivePort();

    // Notify caller which port they can use to send compute requests on.
    initialOutboundPort.send(inboundPort.sendPort);

    // Execute requests as they are received.
    await for (final request in inboundPort) {
      // ignore: avoid_dynamic_calls
      final incomingMessage = request[0] as Map;
      // ignore: avoid_dynamic_calls
      final msgOutboundPort = request[1] as SendPort;
      final fn = incomingMessage['fn'] as Function;
      final parameter = incomingMessage['param'];
      // ignore: avoid_dynamic_calls
      final result = await fn(parameter);
      msgOutboundPort.send(result);
    }
  }
}
