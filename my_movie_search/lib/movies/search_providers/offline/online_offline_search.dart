library pappes.utilites;

import 'package:logger/logger.dart';

var logger = Logger();

/// This class allow for dynamic change of behaviour
/// if the developer wants to test in offline mode.
class OnlineOffline<T> {
  static var offline = true;

  /// Returns appropriate <generic> for current mode (online or offline)
  T selectBetween(T onlineDataSource, T offlineDataSource) {
    logger.i(
        "selectBetween returning ${offline ? 'offlineDataSource' : 'onlineDataSource'}");
    return offline ? offlineDataSource : onlineDataSource;
  }
}
