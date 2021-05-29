library pappes.utilites;

import 'package:logger/logger.dart';

var logger = Logger();

/// This class allow for dynamic change of behaviour
/// if the developer wants to test in offline mode.
class OnlineOfflineSelector<T> {
  static var _offline = false;

  /// Initialise the selector.
  static init(offline) {
    if (offline == null)
      _offline = true;
    else
      _offline = offline.toString().toLowerCase() == "true";
    logger.d('OnlineOfflineSelector initialised to: '
        '${_offline ? 'offline' : 'online'}');
  }

  /// Returns appropriate <generic> for current mode (online or offline)
  T select(T onlineDataSource, T offlineDataSource) {
    logger.v('OnlineOfflineSelector.select returning '
        '${_offline ? 'offlineDataSource' : 'onlineDataSource'}');
    return _offline ? offlineDataSource : onlineDataSource;
  }
}
