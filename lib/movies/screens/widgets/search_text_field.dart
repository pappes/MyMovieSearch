import 'dart:async';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/imdb_suggestions.dart';

typedef SearchFunction = void Function(String);

/// A text field for searching for movies with autocomplete suggestions.
class SearchTextField extends StatelessWidget {
  const SearchTextField({
    required this._onSelected,
    this._textEditingController,
    this._focusNode,
    super.key,
    this._prefixIcon,
    this._textStyle,
    this._initialValue,
  });

  final Widget? _prefixIcon;
  final TextEditingController? _textEditingController;
  final FocusNode? _focusNode;
  final SearchFunction _onSelected;
  final TextStyle? _textStyle;
  final TextEditingValue? _initialValue;

  /// Get the autocomplete options for the search text field.
  ///
  /// Reduce api calls by waiting for the user to stop typing for 400ms.
  Future<Iterable<String>> _getOptions(
    TextEditingValue textValue,
    BuildContext context,
  ) async {
    if (textValue.text.length < 3) {
      return const Iterable<String>.empty();
    }

    final completer = Completer<Iterable<String>>();
    EasyDebounce.debounce(
      'movie-search',
      const Duration(milliseconds: 400),
      () async {
        if (context.mounted) {
          try {
            // Fetch movie suggestions from IMDB.
            final results = await QueryIMDBSuggestions(
              SearchCriteriaDTO().fromString(textValue.text),
            ).readStringList();
            completer.complete(results);
          } catch (_) {
            completer.complete(const Iterable<String>.empty());
          }
        } else {
          completer.complete(const Iterable<String>.empty());
        }
      },
    );
    return completer.future;
  }

  @override
  Widget build(BuildContext context) => Autocomplete<String>(
    textEditingController: _textEditingController,
    focusNode: _focusNode,
    optionsBuilder: (textValue) => _getOptions(textValue, context),
    fieldViewBuilder: _buildTextField,
    onSelected: _onSelected,
    optionsViewOpenDirection: OptionsViewOpenDirection.mostSpace,
    initialValue: _initialValue,
  );

  /// Build the text field for the autocomplete.
  Widget _buildTextField(
    BuildContext context,
    TextEditingController controller,
    FocusNode focusNode,
    VoidCallback onFieldSubmitted,
  ) => TextField(
    controller: controller,
    focusNode: focusNode,
    style: _textStyle,
    decoration: InputDecoration(
      labelText: 'Movie',
      hintText: 'Enter movie or tv series to search for',
      suffixIcon: IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          controller.clear();
          focusNode.requestFocus();
        },
      ),
      prefixIcon: _prefixIcon,
    ),
    onSubmitted: _onSelected,
  );
}
