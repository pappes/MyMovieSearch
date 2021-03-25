import 'dart:async';

//query string https://api.themoviedb.org/3/search/movie?api_key={api_key}&query=wonder+woman
//json format
//name = title/name
//id = unique key
//logo_path = image url

final TmdbJsonSearchInner = r'''
    {
      "id": 34,
      "logo_path": "/GagSvqWlyPdkFHMfQ3pNq6ix9P.png",
      "name": "Sony Pictures"
    },
    {
      "id": 15454,
      "logo_path": null,
      "name": "Sony / Monumental Pictures"
    },
    {
      "id": 8285,
      "logo_path": null,
      "name": "Sony Pictures Studio"
    },
    {
      "id": 30692,
      "logo_path": null,
      "name": "Sony Pictures Imageworks (SPI)"
    },
    {
      "id": 3045,
      "logo_path": null,
      "name": "Sony Pictures Releasing"
    },
    {
      "id": 5752,
      "logo_path": "/sFg00KK0vVq3oqvkCxRQWApYB83.png",
      "name": "Sony Pictures Entertainment"
    },
    {
      "id": 7431,
      "logo_path": null,
      "name": "Sony Pictures Entertainment (SPE)"
    },
    {
      "id": 63520,
      "logo_path": null,
      "name": "Sony Pictures International"
    },
    {
      "id": 65451,
      "logo_path": null,
      "name": "Sony Pictures Digital"
    },
    {
      "id": 94444,
      "logo_path": null,
      "name": "Sony Pictures Networks"
    },
    {
      "id": 86203,
      "logo_path": null,
      "name": "Sony Pictures Television International"
    },
    {
      "id": 82346,
      "logo_path": null,
      "name": "Sony Pictures Entertainment Japan"
    },
    {
      "id": 101555,
      "logo_path": null,
      "name": "Sony Pictures Productions"
    },
    {
      "id": 5388,
      "logo_path": "/i6tbNeVEi7s1uN97s2o0LhEMuF0.png",
      "name": "Sony Pictures Home Entertainment"
    },
    {
      "id": 11073,
      "logo_path": "/wHs44fktdoj6c378ZbSWfzKsM2Z.png",
      "name": "Sony Pictures Television"
    },
    {
      "id": 58,
      "logo_path": "/voYCwlBHJQANtjvm5MNIkCF1dDH.png",
      "name": "Sony Pictures Classics"
    },
    {
      "id": 2251,
      "logo_path": "/8PUjvTVmtJDdDXURTaSoPID0Boj.png",
      "name": "Sony Pictures Animation"
    },
    {
      "id": 34686,
      "logo_path": null,
      "name": "Sony Pictures Entertainment Inc."
    },
    {
      "id": 14577,
      "logo_path": null,
      "name": "Sony Pictures Worldwide Acquisitions (SPWA)"
    }
''';
final TmdbJsonSearchFull =
    ' { "page": 1, "results": [ $TmdbJsonSearchInner ], "total_pages": 1, "total_results": 19 } ';
final TmdbJsonSearchEmpty =
    '{ "status_message": "The resource you requested could not be found.", "status_code": 34 }';
final TmdbJsonSearchError =
    '{ "status_message": "Invalid API key: You must be granted a valid key.", "success": false, "status_code": 7 }';

Future<Stream<String>> streamTmdbJsonOfflineData(String dummy) async {
  return emitTmdbJsonOfflineData(dummy);
}

Stream<String> emitTmdbJsonOfflineData(String dummy) async* {
  yield TmdbJsonSearchFull;
}

Stream<String> emitTmdbJsonEmpty(String dummy) async* {
  yield TmdbJsonSearchEmpty;
}

Stream<String> emitTmdbJsonError(String dummy) async* {
  yield TmdbJsonSearchError;
}
