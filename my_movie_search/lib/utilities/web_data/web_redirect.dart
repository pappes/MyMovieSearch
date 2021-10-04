// ignore_for_file: avoid_classes_with_only_static_members
library pappes.utilites;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotnv;

/// Isolate web requests from cross origin vunerabilities.
///
/// Tunnels browser requests through an intermediate server to strip headers.
class WebRedirect {
  //TODO make origin URL optional
  static const originURL = 'https://www.imdb.com';
  static final tunnelBaseURL = dotnv.env['TUNNEL_ADDRESS'];

  /// Determine if we need to invoke CORS security circumventions
  ///
  /// If running in a web browser flutter uses XHR to process web requests.
  static bool tunnelRequests() {
    if (kIsWeb) {
      // tunnel requests if we are running in a browser (using Javascript)
      return true;
    }
    // No need to tunnel for native Android app
    return false;
  }

  // Redirect call via CORSTunnel if running in a browser.
  static Uri constructURI(String url) {
    var newUrl = url;
    if (tunnelRequests()) {
      newUrl = 'destination=${Uri.encodeQueryComponent(newUrl)}';
      newUrl = '$tunnelBaseURL?origin=$originURL&referer=$originURL/&$newUrl';
    }
    return Uri.parse(newUrl);
  }
}
