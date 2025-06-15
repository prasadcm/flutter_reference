import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:previously_searched/previously_searched.dart';
import 'package:search_suggestion/search_suggestion.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Stack(
        children: [
          const Column(
            children: [
              SearchBarView(),
              Expanded(child: PreviouslySearchedView()),
            ],
          ),
          Positioned(
            top: 64,
            left: 8,
            right: 8,
            child: SearchSuggestionOverlay(
              onTap: (item) {
                // handle suggestion tap
              },
              onShowAll: () {
                // handle 'Show all'
              },
            ),
          ),
        ],
      ),
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
      title: const Text('Search products'),
      elevation: 0,
    );
  }
}
