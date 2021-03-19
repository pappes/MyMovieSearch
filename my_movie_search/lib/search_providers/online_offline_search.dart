library pappes.utilites;

import 'package:logger/logger.dart';

var logger = Logger();

/// This class allow for dynamic change of behaviour
/// if the developer wants to test in offline mode.
class OnlineOffline {
  static bool offline = true;

  /// Returns appropriate Function for current mode (online or offline)
  static Function dataSourceFn(
      Function onlineDataSource, Function offlineDataSource) {
    logger.i(
        "dataSourceFn returning ${offline ? 'offlineDataSource' : 'onlineDataSource'}");
    return offline ? offlineDataSource : onlineDataSource;
  }

  /// Returns appropriate object for current mode (online or offline)
  static Object dataSourceObj(
      Object onlineDataSource, Object offlineDataSource) {
    return offline ? offlineDataSource : onlineDataSource;
  }
}
