import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:previously_searched/previously_searched.dart';
import 'package:suggestions/suggestions.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: const PreviouslySearchedView(),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/');
          }
        },
      ),
      title: ScrollingSearchSuggestion(
        onTap: () => {},
      ),
      backgroundColor: Colors.grey[200],
      elevation: 0,
    );
  }
}
