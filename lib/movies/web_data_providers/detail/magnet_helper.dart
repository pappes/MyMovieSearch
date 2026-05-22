// Helper to manage magnet links.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members

import 'dart:convert';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:my_movie_search/utilities/settings.dart';

const magnetFragment1 = 'magnet:?xt=urn:btih:';
// const magnetFragment2 = '&dn=';
const magnetTracker = '&tr=';
const magnetExtraSourcesUrl =
    'https://raw.githubusercontent.com/ngosang/trackerslist/refs/heads/master/trackers_all.txt';
final magnetSources = <String>{
  'https://tracker.opentrackr.org:1337/announce',
  'https://tracker.torrent.eu.org:451/announce',
  'https://tracker.dler.org:6969/announce',
  'https://open.stealth.si:80/announce',
  'https://tracker.moeblog.cn:443/announce',
  'https://tracker.zhuqiy.com:443/announce',
};

class MagnetHelper {
  static bool testMode = false;
  @awaitNotRequired
  static Future<void> init() async {
    if (testMode) {
      return;
    }
    // read extra magnet sources from web
    // https://raw.githubusercontent.com/ngosang/trackerslist/refs/heads/master/trackers_all.txt

    final request = await HttpClient().getUrl(Uri.parse(magnetExtraSourcesUrl));
    final response = await request.close();
    final sources = await response.transform(utf8.decoder).toList();
    for (final source in sources) {
      for (final tracker in source.split('\n')) {
        final trimmed = tracker.trim();
        if (trimmed.isNotEmpty) {
          magnetSources.add(trimmed);
        }
      }
    }
  }

  /// Add more trackers to a magnet url.
  static String? addTrackers(String? magnet) {
    // e.g. magnet:?xt=urn:btih:A2A78568F4CC7873E9E0088DDE28FA9D9976ACC7&dn=2001%3A+A+Space+Odyssey+%281968%29+%5B1080p%5D+%5BYTS.BZ%5D&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce
    // becomes magnet:?xt=urn:btih:A2A78568F4CC7873E9E0088DDE28FA9D9976ACC7&dn=2001%3A+A+Space+Odyssey+%281968%29+%5B1080p%5D+%5BYTS.BZ%5D&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.dler.org%3A6969%2Fannounce&tr=udp%3A%2F%2Fopen.stealth.si%3A80%2Fannounce&tr=https%3A%2F%2Ftracker.moeblog.cn%3A443%2Fannounce&dk=s4-_709HihG3TI-TNJRe3v_R6XqbQXhW_JH7sl5QMLOMCA&tr=https%3A%2F%2Ftracker.zhuqiy.com%3A443%2Fannounce
    if (null == magnet || !magnet.startsWith(magnetFragment1)) {
      return magnet;
    }

    final buffer = StringBuffer(magnet);

    // add trackers
    for (final tracker in magnetSources) {
      final uriEncoded = Uri.encodeComponent(tracker);
      final httpEncoded = Uri.encodeComponent(uriEncoded);
      if (!magnet.contains(uriEncoded) && !magnet.contains(httpEncoded)) {
        buffer.write('$magnetTracker$uriEncoded');
      }
    }
    return buffer.toString();
  }

  /// Download magnet link using the remote URL.
  static Future<bool> remoteDownload(String? magnet) async {
    if (null == magnet) {
      return false;
    }
    final server = Settings().magnetServer;
    final port = Settings().magnetPort;
    final username = Settings().magnetUsername;
    final password = Settings().magnetPassword;

    if (server == null || port == null) {
      return false;
    }
    //test connection
    await TorrentConnectionTester().testBasicGetRequest('$server:$port');
    // Open magnet link on remote server.
    final result = await TorrentRemoteService().uploadMagnetToServer(
      ipAddress: '$server:$port',
      username: username,
      password: password,
      magnetUri: magnet,
    );
    return result;
  }
}

class TorrentConnectionTester {
  /// Simple GET request to test if the ttorrents web interface is reachable.
  /// [ipAddress] should be "192.168.0.30:1080"
  Future<void> testBasicGetRequest(String ipAddress) async {
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 4);

    // We hit the base route to see if the webserver responds
    final url = 'http://$ipAddress/bt/';

    try {
      Logger().t('Initiating connection test to: $url');

      final request = await client.getUrl(Uri.parse(url));

      // Basic setup to simulate a standard browser transaction
      request.headers.set('Accept', 'text/html,application/xhtml+xml');
      request.headers.set('Connection', 'close');

      final response = await request.close();

      Logger().t(
        'HTTP Status Code: ${response.statusCode}',
      ); // Expecting 200 OK or 401 Unauthorized

      // Print the headers to verify it's actually tTorrent talking
      response.headers.forEach((name, values) {
        Logger().t('Header -> $name: ${values.join(', ')}');
      });
    } catch (e) {
      Logger().t('Connection Error Detail: $e');
    } finally {
      client.close(force: true);
    }
  }
}

class TorrentRemoteService {
  /// Sends a magnet URI straight to the remote ttorrent instance.
  /// [ipAddress] must include the port (e.g., "192.168.0.30:1080")
  Future<bool> uploadMagnetToServer({
    required String ipAddress,
    required String? username,
    required String? password,
    required String magnetUri,
  }) async {
    // The exact functional endpoint discovered via curl
    final url = 'http://$ipAddress/command/download';

    // Converts {'urls': magnetUri} into 'urls=magnet%3A...' in one clean step
    final bodyString = Uri(queryParameters: {'urls': magnetUri}).query;

    final client = HttpClient()..connectionTimeout = const Duration(seconds: 5);

    try {
      final request = await client.postUrl(Uri.parse(url));

      // MUST be form-urlencoded for the /command/download endpoint
      request.headers.chunkedTransferEncoding = false;
      request.headers.set('Content-Type', 'application/x-www-form-urlencoded');
      request.headers.set('Connection', 'close');

      // Inject your Basic Authentication headers
      if (username != null && password != null && username.isNotEmpty) {
        final credentials = '$username:$password';
        final encodedCredentials = base64Encode(utf8.encode(credentials));
        request.headers.set('Authorization', 'Basic $encodedCredentials');
      }

      // Convert body string to raw payload bytes
      final bodyBytes = utf8.encode(bodyString);
      request.headers.contentLength = bodyBytes.length;
      request.add(bodyBytes);

      final response = await request.close();

      // The server returns 200 OK on a successful ingestion trigger
      if (response.statusCode == HttpStatus.ok) {
        return true;
      }

      Logger().t(
        'tTorrent server rejected payload with code: ${response.statusCode}',
      );
      return false;
    } catch (e) {
      Logger().t('Network exception forwarding magnet link: $e');
      return false;
    } finally {
      client.close(force: true);
    }
  }
}
