// Class to connect to the Meilisearch search engine.
// includes methods to connect to the search engine,
// add a document in the format of a DTO,
// retrieve a document in the format of a DTO
// and perform a search returning a list of DTOs.

import 'dart:convert';

import 'package:meilisearch/meilisearch.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/utilities/settings.dart';

const host = 'https://search.dvds.mms.pappes.net';
final apiKey = Settings().meiliadminkey;

class MeiliSearch {
  MeiliSearch({
    required String indexName,
  }) : _index = MeiliSearchClient(host, apiKey).index(indexName);

  final MeiliSearchIndex _index;

  // Add a document to the search engine.
  Future<void> addDocument(MovieResultDTO dto) async {
    final json = jsonEncode(dto.toMap(flattenRelated: true));
    await _index.addDocumentsJson(json, primaryKey: movieDTOUniqueId);
  }

  // Retrieve a document from the search engine.
  Future<MovieResultDTO?> getDocument(String uniqueId) async {
    final results = await _index.getDocument(uniqueId);
    if (results != null) {
      return results.toMovieResultDTO();
    }
    return null;
  }

  // Search the search engine for a list of documents.
  Future<List<MovieResultDTO>> search(String query) async {
    final results = await _index.search(query);
    return results.hits.map((hit) => hit.toMovieResultDTO()).toList();
  }
}
