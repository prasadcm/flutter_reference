import 'package:categories/categories.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:network/network.dart';
import 'package:reference/app.dart';
import 'package:suggestions/suggestions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await CoreServiceLocator.setup();
  NetworkServiceLocator.setup();
  CategoryServiceLocator.setup();
  SuggestionServiceLocator.setup();
  runApp(
    const ReferenceApp(),
  );
}
