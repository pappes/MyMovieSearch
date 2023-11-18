import 'package:logger/logger.dart' show Logger;

final logger = Logger();
const defaultToOffline = false;

/// Perform alternate logic if network connections are being avoided.
///
/// [OnlineOfflineSelector] allows for dynamic change of behaviour
/// if the developer wants to test in offline mode.
class OnlineOfflineSelector {
  static var _offline = false;

  /// Initialise the selector.
  static void init(dynamic offline) {
    if (offline == null) {
      _offline = defaultToOffline;
    } else {
      _offline = offline.toString().toLowerCase() == "true";
    }
    logger.d(
      'OnlineOfflineSelector initialised to: '
      '${_offline ? 'offline' : 'online'}',
    );
  }

  /// Returns appropriate <generic> for current mode (online or offline)
  T select<T>(T onlineDataSource, T offlineDataSource) =>
      _offline ? offlineDataSource : onlineDataSource;
}
