library pappes.utilites;

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

/// Isolate web requests from cross origin vunerabilities.
///
/// Tunnels browser requests through an intermediate server to strip headers.
class WebRedirect {
  //TODO make origin URL optional
  static final originURL = 'https://www.imdb.com';
  static final tunnelBaseURL = DotEnv.env['TUNNEL_ADDRESS'];

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
    if (tunnelRequests()) {
      url = 'destination=${Uri.encodeQueryComponent(url)}';
      url = '$tunnelBaseURL?origin=$originURL&referer=$originURL/&$url';
    }
    return Uri.parse(url);
  }
}
