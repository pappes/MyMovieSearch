import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/converters/imdb_name.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_name.dart';

const String _sampleMainCase = '''
{"@context": "http://schema.org", 
  "@type": "Person",
  "url": "/name/nm12345/",
  "name": "John Smith",
  "jobTitle": ["Actor",  "Writer",  "Producer"],
  "description": "John Smith is an actor and writer, known for Movie1 (2014),Movie2 (2004) and Movie3 (2014).",
  "related": 
  {
    "actor": [
      {"name": "Movie1", "url": "/title/tt456789/?ref=nm_flmg_act_1"}, 
      {"name": "Movie2", "url": "/title/tt987654/?ref_=nm_flmg_act_2"}
    ],
    "writer": [
      {"name": "Movie1", "url": "/title/tt456789/?ref_=nm_flmg_wr_1"}, 
      {"name": "Movie2", "url": "/title/tt987654/?ref_=nm_flmg_wr_2"}
    ],
    "producer": [
      {"name": "Movie1", "url": "/title/tt456789/?ref_=nm_flmg_prd_1"}, 
      {"name": "Movie2", "url": "/title/tt987654/?ref_=nm_flmg_prd_2"}
    ],
    "director": [
      {"name": "Movie1", "url": "/title/tt456789/?ref_=nm_flmg_dr_1"}, 
      {"name": "Movie2", "url": "/title/tt987654/?ref_=nm_flmg_dr_2"}
    ]
  }, 
  "id": "nm12345"
}
''';

const String _sampleGetRelatedIterable = '''
{"@context": "http://schema.org", 
  "@type": "Person",
  "url": "/name/nm12345/",
  "name": "John Smith",
  "jobTitle": ["Actor",  "Writer",  "Producer"],
  "description": "John Smith is an actor and writer, known for Movie1 (2014),Movie2 (2004) and Movie3 (2014).",
  "related": 
  [
    {
      "actor": [
        {"name": "Movie1", "url": "/title/tt456789/?ref=nm_flmg_act_1"}, 
        {"name": "Movie2", "url": "/title/tt987654/?ref_=nm_flmg_act_2"}
      ],
      "writer": [
        {"name": "Movie1", "url": "/title/tt456789/?ref_=nm_flmg_wr_1"}, 
        {"name": "Movie2", "url": "/title/tt987654/?ref_=nm_flmg_wr_2"}
      ]
    },
    {
      "producer": [
        {"name": "Movie1", "url": "/title/tt456789/?ref_=nm_flmg_prd_1"}, 
        {"name": "Movie2", "url": "/title/tt987654/?ref_=nm_flmg_prd_2"}
      ],
      "director": [
        {"name": "Movie1", "url": "/title/tt456789/?ref_=nm_flmg_dr_1"}, 
        {"name": "Movie2", "url": "/title/tt987654/?ref_=nm_flmg_dr_2"}
      ]
    }
  ], 
  "id": "nm12345"
}
''';

const String _sampleGetMoviesMap = '''
{"@context": "http://schema.org", 
  "@type": "Person",
  "url": "/name/nm12345/",
  "name": "John Smith",
  "jobTitle": ["Actor",  "Writer",  "Producer"],
  "description": "John Smith is an actor and writer, known for Movie1 (2014),Movie2 (2004) and Movie3 (2014).",
  "related": 
    {
      "actor": 
        {"name": "Movie1", "url": "/title/tt456789/?ref=nm_flmg_act_1"},
      "writer": 
        {"name": "Movie2", "url": "/title/tt987654/?ref_=nm_flmg_wr_2"},
      "producer": 
        {"name": "Movie1", "url": "/title/tt456789/?ref_=nm_flmg_prd_1"}, 
      "director": 
        {"name": "Movie2", "url": "/title/tt987654/?ref_=nm_flmg_dr_2"}
    },
  "id": "nm12345"
}
''';

const String _sampleDtoFromRelatedMapUnknownId = '''
{"@context": "http://schema.org", 
  "@type": "Person",
  "url": "/name/nm12345/",
  "name": "John Smith",
  "jobTitle": ["Actor",  "Writer",  "Producer"],
  "description": "John Smith is an actor and writer, known for Movie1 (2014),Movie2 (2004) and Movie3 (2014).",
  "related": 
  {
    "actor": [
      {"name": "Movie1", "url": "/title/tt456789/?ref=nm_flmg_act_1"}, 
      {"name": "Movie1a", "url": "/other/url/?ref=nm_flmg_act_1"}, 
      {"name": "Movie2", "url": "/title/tt987654/?ref_=nm_flmg_act_2"}
    ],
    "writer": [
      {"name": "Movie1", "url": "/title/tt456789/?ref_=nm_flmg_wr_1"}, 
      {"name": "Movie2", "url": "/title/tt987654/?ref_=nm_flmg_wr_2"}
    ],
    "producer": [
      {"name": "Movie1", "url": "/title/tt456789/?ref_=nm_flmg_prd_1"}, 
      {"name": "Movie2", "url": "/title/tt987654/?ref_=nm_flmg_prd_2"}
    ],
    "director": [
      {"name": "Movie1", "url": "/title/tt456789/?ref_=nm_flmg_dr_1"}, 
      {"name": "Movie2", "url": "/title/tt987654/?ref_=nm_flmg_dr_2"}
    ]
  }, 
  "id": "nm12345"
}
''';

const String _sampleNoRelated = '''
{"@context": "http://schema.org", 
  "@type": "Person",
  "url": "/name/nm12345/",
  "name": "John Smith",
  "jobTitle": ["Actor",  "Writer",  "Producer"],
  "description": "John Smith is an actor and writer, known for Movie1 (2014),Movie2 (2004) and Movie3 (2014).",
  "id": "nm12345"
}
''';

const String _expectedMainCase =
    '["{\\"source\\":\\"DataSourceType.imdb\\",\\"uniqueId\\":\\"nm12345\\",\\"title\\":\\"John Smith\\",\\"type\\":\\"MovieContentType.person\\",\\"yearRange\\":\\"0-\\",\\"languages\\":\\"[]\\",\\"genres\\":\\"[]\\",\\"keywords\\":\\"[]\\",\\"description\\":\\"John Smith is an actor and writer, known for Movie1 (2014),Movie2 (2004) and Movie3 (2014).\\",\\"related\\":\\"{actor: (tt456789, tt987654), writer: (tt456789, tt987654), producer: (tt456789, tt987654), director: (tt456789, tt987654)}\\"}"]';

const String _expectedGetMoviesMap =
    '["{\\"source\\":\\"DataSourceType.imdb\\",\\"uniqueId\\":\\"nm12345\\",\\"title\\":\\"John Smith\\",\\"type\\":\\"MovieContentType.person\\",\\"yearRange\\":\\"0-\\",\\"languages\\":\\"[]\\",\\"genres\\":\\"[]\\",\\"keywords\\":\\"[]\\",\\"description\\":\\"John Smith is an actor and writer, known for Movie1 (2014),Movie2 (2004) and Movie3 (2014).\\",\\"related\\":\\"{actor: (tt456789), writer: (tt987654), producer: (tt456789), director: (tt987654)}\\"}"]';

const String _expectedNoRelated =
    '["{\\"source\\":\\"DataSourceType.imdb\\",\\"uniqueId\\":\\"nm12345\\",\\"title\\":\\"John Smith\\",\\"type\\":\\"MovieContentType.person\\",\\"yearRange\\":\\"0-\\",\\"languages\\":\\"[]\\",\\"genres\\":\\"[]\\",\\"keywords\\":\\"[]\\",\\"description\\":\\"John Smith is an actor and writer, known for Movie1 (2014),Movie2 (2004) and Movie3 (2014).\\",\\"related\\":\\"{}\\"}"]';
void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests (uses DTO and DTO extension methods)
////////////////////////////////////////////////////////////////////////////////

  group('ImdbNamePageConverter dtoFromCompleteJsonMap edge case', () {
    // Convert 1 sample JSON Map into a dto.
    // e.g. nm0322164
    test('_SuccessfulConversion', () async {
      final map = json.decode(_sampleMainCase) as Map;
      final dtos = ImdbNamePageConverter.dtoFromCompleteJsonMap(map);
      final text = json.encode(dtos.encodeList());
      expect(text, _expectedMainCase);
    });
    // Convert 1 sample JSON Map into a dto.
    // Original error: on imdb data nm4240546 was
    //   _InternalLinkedHashMap<dynamic, dynamic>' is not a subtype of type of 'Iterable<dynamic>'
    test('_getRelated has Iterable categories', () async {
      final map = json.decode(_sampleGetRelatedIterable) as Map;
      final dtos = ImdbNamePageConverter.dtoFromCompleteJsonMap(map);
      final text = json.encode(dtos.encodeList());
      expect(text, _expectedMainCase);
    });
    // Convert 1 sample JSON Map into a dto.
    // Allow for single related movie in a category
    test('_sampleGetMovies Is not using a list for related movies', () async {
      final map = json.decode(_sampleGetMoviesMap) as Map;
      final dtos = ImdbNamePageConverter.dtoFromCompleteJsonMap(map);
      final text = json.encode(dtos.encodeList());
      expect(text, _expectedGetMoviesMap);
    });
    // Convert 1 sample JSON Map into a dto.
    // Handle unknown related links gracefully
    test('_sampleDtoFromRelatedMap has unexpected URL', () async {
      final map = json.decode(_sampleDtoFromRelatedMapUnknownId) as Map;
      final dtos = ImdbNamePageConverter.dtoFromCompleteJsonMap(map);
      final text = json.encode(dtos.encodeList());
      expect(text, _expectedMainCase);
    });
    // Convert 1 sample JSON Map into a dto.
    // Handle no related records gracefully
    test('person has no related movies', () async {
      final map = json.decode(_sampleNoRelated) as Map;
      final dtos = ImdbNamePageConverter.dtoFromCompleteJsonMap(map);
      final text = json.encode(dtos.encodeList());
      expect(text, _expectedNoRelated);
    });
  });

////////////////////////////////////////////////////////////////////////////////
  /// Integration tests (testing wrapper on ImdbNamePageConverter.dtoFromCompleteJsonMap)
  /// using QueryIMDBNameDetails.myTransformMapToOutput()
////////////////////////////////////////////////////////////////////////////////
  group('ImdbNamePageConverter dtoFromCompleteJsonMap edge case', () {
    // Convert 1 sample JSON Map into a dto.
    // e.g. nm0322164
    test('_SuccessfulConversion', () async {
      final map = json.decode(_sampleMainCase) as Map;
      final dtos = await QueryIMDBNameDetails().myConvertTreeToOutputType(map);
      final text = json.encode(dtos.encodeList());
      expect(text, _expectedMainCase);
    });
    // Convert 1 sample JSON Map into a dto.
    // Orginal error: on imdb data nm4240546 was
    //   _InternalLinkedHashMap<dynamic, dynamic>' is not a subtype of type of 'Iterable<dynamic>'
    /*test('_InternalLinkedHashMap', () async {
      final map = json.decode(_internalLinkedHashMapEdgeCase) as Map;
      final dtos = QueryIMDBNameDetails().myTransformMapToOutput(map);
      final text = json.encode(dtos.encodeList());
      expect(text, _expectedInternalLinkedHashMap);
    });*/
  });

////////////////////////////////////////////////////////////////////////////////
  /// Integration tests (testing wrapper on ImdbNamePageConverter.dtoFromCompleteJsonMap)
  /// using WebFetchBase<OUTPUT_TYPE, INPUT_TYPE>.baseTransformMapToOutputHandler
  /// via ScrapeIMDBNameDetails
  /// via QueryIMDBNameDetails
////////////////////////////////////////////////////////////////////////////////
  group('ImdbNamePageConverter dtoFromCompleteJsonMap edge case', () {
    // Convert 1 sample JSON Map into a dto.
    // e.g. nm0322164
    test('_SuccessfulConversion', () async {
      final map = json.decode(_sampleMainCase) as Map;
      final dtos = await QueryIMDBNameDetails().myConvertTreeToOutputType(map);
      final text = json.encode(dtos.encodeList());
      expect(text, _expectedMainCase);
    });
    // Convert 1 sample JSON Map into a dto.
    // Original error: on imdb data nm4240546 was
    //   _InternalLinkedHashMap<dynamic, dynamic>' is not a subtype of type of 'Iterable<dynamic>'
    /*test('_InternalLinkedHashMap', () async {
      final map = json.decode(_internalLinkedHashMapEdgeCase) as Map;
      final dtos = QueryIMDBNameDetails().baseTransformMapToOutputHandler(map);
      final text = json.encode(dtos.encodeList());
      expect(text, _expectedInternalLinkedHashMap);
    });*/
  });
}
