// Helper to manage magnet links.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members

import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';

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
}
