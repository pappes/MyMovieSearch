import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:html/parser.dart' as html;

const String ytsDefaultUrl = 'https://yts.lt';
const String emptySearchResult =
    '{"status":"false","message":"No results found."}';

class YtsHelper {
  YtsHelper() {
    unawaited(init());
  }

  /// Base URL for YTS.
  static String? _ytsBaseUrl;

  /// Returns the base URL for YTS, fetching it dynamically if needed.
  String get ytsBaseUrl => _ytsBaseUrl ?? ytsDefaultUrl;

  Future<void> init() async {
    if (_ytsBaseUrl != null) {
      return;
    }
    final url = await _findLatestYifyURL();
    if (url.isNotEmpty) {
      _ytsBaseUrl = url;
    }
  }

  Future<String> _findLatestYifyURL() async {
    const url = 'https://yifystatus.com';

    final client =
        HttpClient()
          // Allow HttpClient to handle compressed data from web servers.
          ..autoUncompress = true;
    final request = await client.getUrl(Uri.parse(url));
    final response = await request.close();
    final webPage = await response.transform(utf8.decoder).join();

    if (webPage.contains('Current official domain:')) {
      unawaited(_findWorkingYifyURL(webPage));

      final afterDomain = webPage.split('Current official domain:')[1];
      // The regex looks for an HTML anchor tag's href attribute.
      // href="   - Matches the literal characters 'href="'
      // ([^"]+)  - This is a capturing group.
      //   [^"]   - Matches any character that is NOT a double quote.
      //   +      - Matches the preceding token (any char but ")
      //            one or more times.
      // "        - Matches the literal closing double quote.
      // In essence, it captures the URL from the first link after the text
      // "Current official domain:".
      final linkMatch = RegExp('href="([^"]+)"').firstMatch(afterDomain);
      //print('official: ${linkMatch?.group(1)}');
      return linkMatch?.group(1) ?? '';
    }
    return '';
  }

  Future<void> _findWorkingYifyURL(String webPage) async {
    final dom = html.parse(webPage);
    // Select all anchor elements that have an href attribute.
    final links = dom.querySelectorAll('a[href]');
    for (final link in links) {
      final href = link.attributes['href'];
      if (href != null && href.startsWith('http') && !href.contains('.onion')) {
        unawaited(testYtsUrl(href));
      }
    }
  }

  Future<void> testYtsUrl(String href) async {
    //print ('testing: $href    ');
    final client =
        HttpClient()
          // Allow HttpClient to handle compressed data from web servers.
          ..autoUncompress = true;
    final request = await client.getUrl(
      Uri.parse('$href/ajax/search?query=therearenoresultszzzz/'),
    );
    final response = await request.close();
    final page = await response.transform(utf8.decoder).join();
    if (page.contains(emptySearchResult)) {
      //print ('working: $href    ');
      _ytsBaseUrl = href;
    }
  }
}
