import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search_suggestion/search_suggestion.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SuggestionsBloc(suggestionsRepository: SuggestionsRepository()),
      child:
          Scaffold(appBar: _appBar(), body: const ScrollingSearchSuggestion()),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      title: Center(
        child: Text(
          "Home",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20, // Adjust size if needed
          ),
        ),
      ),
    );
  }
}
