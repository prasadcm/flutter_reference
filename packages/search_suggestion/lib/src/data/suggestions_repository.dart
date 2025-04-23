import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:search_suggestion/src/data/suggestion_model.dart';

class SuggestionsRepository {
  const SuggestionsRepository();

  Future<List<SuggestionModel>> loadSuggestions() async {
    final jsonString = await rootBundle
        .loadString('packages/search_suggestion/assets/suggestions.json');
    final jsonResponse = json.decode(jsonString) as List<dynamic>;
    return jsonResponse
        .map((data) => SuggestionModel.fromJson(data as Map<String, dynamic>))
        .toList();
  }
}
