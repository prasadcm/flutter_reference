import 'package:categories/categories.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:network/network.dart';
import 'package:previously_searched/previously_searched.dart';
import 'package:reference/app.dart';
import 'package:reference/routing/app_router.dart';
import 'package:search_recommendation/search_recommendation.dart';
import 'package:search_suggestion/search_suggestion.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppRouter.setup();
  await CoreServiceLocator.setup();
  NetworkServiceLocator.setup();
  CategoryServiceLocator.setup();
  SearchRecommendationServiceLocator.setup();
  PreviouslySearchedServiceLocator.setup();
  SearchSuggestionServiceLocator.setup();
  runApp(
    const ReferenceApp(),
  );
}
