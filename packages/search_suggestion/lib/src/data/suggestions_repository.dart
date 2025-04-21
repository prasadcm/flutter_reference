import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import 'suggestion_model.dart';

class SuggestionsRepository {
  const SuggestionsRepository();

  Future<List<SuggestionModel>> loadSuggestions() async {
    final String jsonString = await rootBundle
        .loadString('packages/search_suggestion/assets/suggestions.json');
    final List<dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse.map((data) => SuggestionModel.fromJson(data)).toList();
  }
}
